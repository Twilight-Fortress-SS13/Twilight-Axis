#!/bin/bash
set -euo pipefail

game_dir="$(cd "${1:?game directory required}" && pwd)"
rsc="$game_dir/roguetown.rsc"
marker="$game_dir/ta_full_rsc_url.txt"
cdn="${CDN_ROOT:-/var/www/cdn}"
base="${CDN_BASE_URL:?CDN_BASE_URL must be set}"
base="${base%/}"

# A failed publication must never leave a stale URL in this deployment.
rm -f -- "$marker"
[[ -s "$rsc" && -d "$cdn" ]]
hash="$(sha256sum "$rsc" | cut -d' ' -f1)"
name="roguetown_${hash}.zip"
target="$cdn/$name"
work="$(mktemp -d "$cdn/.rsc-build.XXXXXX")"
marker_tmp=""
trap 'rm -rf -- "$work"; if [[ -n "$marker_tmp" ]]; then rm -f -- "$marker_tmp"; fi' EXIT

if [[ ! -f "$target" ]]; then
    nice -n 10 zip -0 -j -q "$work/$name" "$rsc"
    [[ "$(unzip -p "$work/$name" roguetown.rsc | sha256sum | cut -d' ' -f1)" == "$hash" ]]
    chmod 644 "$work/$name"
    mv -- "$work/$name" "$target"
fi
[[ "$(unzip -p "$target" roguetown.rsc | sha256sum | cut -d' ' -f1)" == "$hash" ]]
[[ "$(sha256sum "$rsc" | cut -d' ' -f1)" == "$hash" ]]

url="$base/$name"
headers="$(curl -fsSI --max-time 20 "$url" | tr -d '\r')"
status="$(awk '/^HTTP\// {code=$2} END {print code}' <<< "$headers")"
remote_size="$(awk 'tolower($1)=="content-length:" {size=$2} END {print size}' <<< "$headers")"
[[ "$status" == 200 && "$remote_size" == "$(stat -c %s "$target")" ]]

marker_tmp="$(mktemp "$game_dir/.ta_full_rsc_url.XXXXXX")"
printf '%s\n' "$url" > "$marker_tmp"
chmod 644 "$marker_tmp"
mv -- "$marker_tmp" "$marker"
echo "Published build RSC: $url"
