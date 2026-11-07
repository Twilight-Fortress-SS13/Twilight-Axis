#!/bin/bash
# Builds asset bundles with tools/asset_bundler.py and publishes them to the CDN:
#
#   <CDN_ROOT>/bundles/{icons,sounds}/<hash>.zip   shared pool, one file per bundle hash
#   <CDN_ROOT>/DD_MM_YYYY/manifest.json            what each build consists of
#   <CDN_ROOT>/DD_MM_YYYY/resource_urls.json
#
# Bundles are content-addressed, so an unchanged bundle keeps the same URL across
# builds and clients never download it twice. Before publishing, old dated dirs are
# dropped and every pool archive no remaining manifest references is deleted.
#
# Also writes resource_urls.json, which SSresource_preload reads at world init.
#
# Usage: deploy_asset_bundles.sh <game_dir>
#
# Environment overrides:
#   CDN_ROOT            webroot to publish into          (default: /var/www/cdn)
#   CDN_BASE_URL        public URL of CDN_ROOT           (required)
#   CDN_KEEP_DIRS       how many older dated dirs to keep besides the new one (default: 7)
#   CHUNK_SIZE_MB       max bundle size, passed through  (default: 50)
#   RESOURCE_URLS_PATH  where to write the url list      (default: <game_dir>/config/resource_urls.json)
#                       Under TGS point it at Configuration/GameStaticFiles/config/resource_urls.json,
#                       since the deployment's own config/ is replaced by the static files symlink.

set -euo pipefail

game_dir="$(cd "${1:?game directory required}" && pwd)"

CDN_ROOT="${CDN_ROOT:-/var/www/cdn}"
CDN_BASE_URL="${CDN_BASE_URL:?CDN_BASE_URL must be set, e.g. https://cdn.example.com}"
CDN_KEEP_DIRS="${CDN_KEEP_DIRS:-7}"
CHUNK_SIZE_MB="${CHUNK_SIZE_MB:-50}"
RESOURCE_URLS_PATH="${RESOURCE_URLS_PATH:-$game_dir/config/resource_urls.json}"

CDN_BASE_URL="${CDN_BASE_URL%/}"
version="$(date +%d_%m_%Y)"
target_dir="$CDN_ROOT/$version"
pool_dir="$CDN_ROOT/bundles"

staging="$(mktemp -d)"
trap 'rm -rf "$staging"' EXIT

echo "Building asset bundles from $game_dir..."
python3 "$game_dir/tools/asset_bundler.py" \
	--root "$game_dir" \
	--output "$staging/bundles" \
	--chunk-size-mb "$CHUNK_SIZE_MB" \
	--no-staging

mkdir -p "$pool_dir"

# Drop the oldest dated directories (today's is about to be replaced anyway).
# A still-running round keeps using the previous build until reboot, so keep >= 1.
mapfile -t dated_dirs < <(
	find "$CDN_ROOT" -mindepth 1 -maxdepth 1 -type d -regextype posix-extended \
		-regex '.*/[0-9]{2}_[0-9]{2}_[0-9]{4}' ! -name "$version" -printf '%T@ %p\n' | sort -rn | cut -d' ' -f2-
)
for old_dir in "${dated_dirs[@]:$CDN_KEEP_DIRS}"; do
	echo "Removing old build dir $old_dir"
	rm -rf "$old_dir"
done

# Clean the pool: keep only archives referenced by the remaining builds' manifests.
# Archives of the new build are copied in right after, so they need no protection here.
# A same-day earlier build counts too: a server may already be running on it.
echo "Pruning bundle pool..."
python3 - "$CDN_ROOT" "$pool_dir" <<'EOF'
import json
import os
import re
import sys

cdn_root, pool_dir = sys.argv[1:3]
referenced = set()
for name in os.listdir(cdn_root):
    manifest_path = os.path.join(cdn_root, name, "manifest.json")
    if not re.fullmatch(r"\d{2}_\d{2}_\d{4}", name) or not os.path.isfile(manifest_path):
        continue
    with open(manifest_path, encoding="utf-8") as fh:
        manifest = json.load(fh)
    for bundles in manifest["categories"].values():
        referenced.update(bundle["archive"] for bundle in bundles)

removed = 0
for dirpath, _dirnames, filenames in os.walk(pool_dir):
    for name in filenames:
        path = os.path.join(dirpath, name)
        if os.path.relpath(path, pool_dir).replace(os.sep, "/") not in referenced:
            os.remove(path)
            removed += 1
print(f"{len(referenced)} archives still referenced, {removed} removed")
EOF

# Copy new archives into the pool. Same name means same content, so existing ones
# are left untouched; new ones go in under a temp name and are renamed into place.
echo "Publishing bundles to $pool_dir..."
added=0
while IFS= read -r -d '' archive; do
	rel="${archive#"$staging/bundles/"}"
	dst="$pool_dir/$rel"
	[ -f "$dst" ] && continue
	mkdir -p "$(dirname "$dst")"
	cp "$archive" "$dst.tmp"
	chmod a+r "$dst.tmp"
	mv "$dst.tmp" "$dst"
	added=$((added + 1))
done < <(find "$staging/bundles" -name '*.zip' -print0)
echo "$added new archives added"

echo "Writing $RESOURCE_URLS_PATH..."
mkdir -p "$(dirname "$RESOURCE_URLS_PATH")"
python3 - "$staging/bundles/manifest.json" "$staging/resource_urls.json" "$CDN_BASE_URL/bundles" "$version" <<'EOF'
import json
import sys

manifest_path, out_path, base_url, version = sys.argv[1:5]
with open(manifest_path, encoding="utf-8") as fh:
    manifest = json.load(fh)

result = {"version": version, "base_url": base_url + "/"}
# Icons first, then sounds: the order here is the order clients download in.
for category in ("icons", "sounds"):
    result[category] = [
        {"url": f"{base_url}/{bundle['archive']}", "size": bundle["total_size"]}
        for bundle in manifest["categories"].get(category, [])
    ]

with open(out_path, "w", encoding="utf-8") as fh:
    json.dump(result, fh, indent=2)
print(f"{len(result['icons'])} icon bundles, {len(result['sounds'])} sound bundles")
EOF
cp "$staging/resource_urls.json" "$RESOURCE_URLS_PATH.tmp"
mv "$RESOURCE_URLS_PATH.tmp" "$RESOURCE_URLS_PATH"

# Record this build last, once every archive it references is in the pool.
incoming="$(mktemp -d "$CDN_ROOT/.incoming_${version}_XXXXXX")"
cp "$staging/bundles/manifest.json" "$staging/resource_urls.json" "$incoming/"
chmod -R a+rX "$incoming"
rm -rf "$target_dir"
mv "$incoming" "$target_dir"

echo "Asset bundles deployed: $CDN_BASE_URL/bundles/ (build $version)"
