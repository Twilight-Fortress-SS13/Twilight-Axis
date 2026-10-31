#!/usr/bin/env python3
"""Asset bundler: packs .dmi/.png/.ogg assets into content-addressed ZIP bundles.

What it does:
  1. Walks the repo and collects every .dmi/.png (icons) and .ogg (sounds) file.
  2. Sorts each category by relative path, so the ordering is stable across
     machines/OSes regardless of filesystem iteration order.
  3. Greedily slices each sorted list into chunks no bigger than --chunk-size-mb.
     Icons and sounds are always chunked separately, never mixed into the same bundle.
  4. For each chunk, copies the files into a staging folder (path preserved from
     the repo root) named after a hash of the chunk's contents, then zips that
     folder into "<hash>.zip" with no compression (ZIP_STORED).

Because the bundle hash is derived from each file's own content hash plus its
path (not from file mtimes or zip metadata), a chunk whose files did not change
produces a byte-identical zip on every rebuild. A file whose content is
unchanged always sorts into the same position, so it only moves to a
different bundle if files added/removed/resized elsewhere shift chunk
boundaries around it.

Usage:
    python asset_bundler.py [--root PATH] [--output PATH] [--chunk-size-mb 50]
"""
import argparse
import hashlib
import json
import os
import shutil
import zipfile
from pathlib import Path

ICON_EXTENSIONS = {".dmi", ".png"}
SOUND_EXTENSIONS = {".ogg"}
ALL_EXTENSIONS = ICON_EXTENSIONS | SOUND_EXTENSIONS

# Pruned wherever they occur, at any depth (never legitimate game content).
ANYWHERE_EXCLUDE_DIRS = {".git", "node_modules", "__pycache__"}

# Pruned only as an immediate child of --root: these are common enough directory
# names (e.g. code/modules/.../cook/tools, code/modules/.../character_setup/data)
# that matching them by basename anywhere in the tree silently drops real assets.
TOP_LEVEL_EXCLUDE_DIRS = {".github", "tmp", "data", "tools", "bin", "build", "dist"}

ZIP_EPOCH = (1980, 1, 1, 0, 0, 0)  # fixed timestamp so zip bytes are reproducible


def iter_asset_files(root: Path, extra_exclude_dirs: set):
    anywhere = ANYWHERE_EXCLUDE_DIRS | extra_exclude_dirs
    for dirpath, dirnames, filenames in os.walk(root):
        is_top_level = Path(dirpath) == root
        dirnames[:] = [
            d for d in dirnames
            if not d.startswith(".")
            and d not in anywhere
            and not (is_top_level and d in TOP_LEVEL_EXCLUDE_DIRS)
        ]
        for name in filenames:
            if os.path.splitext(name)[1].lower() in ALL_EXTENSIONS:
                yield Path(dirpath) / name


def relpath_posix(path: Path, root: Path) -> str:
    return path.relative_to(root).as_posix()


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def pack_into_chunks(entries, max_bytes):
    """entries: sorted [(relpath, size)]. Greedily fills chunks up to max_bytes.

    A single file larger than max_bytes gets a chunk of its own instead of
    being split or blowing up an unrelated chunk.
    """
    chunks = []
    current = []
    current_size = 0
    for relpath, size in entries:
        if current and current_size + size > max_bytes:
            chunks.append(current)
            current = []
            current_size = 0
        current.append((relpath, size))
        current_size += size
    if current:
        chunks.append(current)
    return chunks


def hash_chunk(file_hashes):
    """file_hashes: [(relpath, sha256)] sorted by relpath. Order-independent
    of anything outside this chunk, so unrelated chunks never affect this hash."""
    h = hashlib.sha256()
    for relpath, filehash in file_hashes:
        h.update(relpath.encode("utf-8"))
        h.update(b"\0")
        h.update(filehash.encode("utf-8"))
        h.update(b"\n")
    return h.hexdigest()


def build_category(category, files, root, output_dir, chunk_bytes, keep_staging, dry_run):
    entries = [(relpath_posix(f, root), f.stat().st_size, f) for f in files]
    entries.sort(key=lambda e: e[0])
    path_map = {rel: full for rel, _, full in entries}

    chunks = pack_into_chunks([(rel, size) for rel, size, _ in entries], chunk_bytes)

    category_dir = output_dir / category
    if not dry_run:
        category_dir.mkdir(parents=True, exist_ok=True)

    bundles = []
    file_index = {}

    for chunk in chunks:
        file_bytes = {}
        file_hashes = []
        for rel, _size in chunk:
            data = path_map[rel].read_bytes()
            file_bytes[rel] = data
            file_hashes.append((rel, sha256_bytes(data)))

        bundle_hash = hash_chunk(file_hashes)
        total_size = sum(size for _, size in chunk)

        bundles.append({
            "hash": bundle_hash,
            "archive": f"{category}/{bundle_hash}.zip",
            "file_count": len(chunk),
            "total_size": total_size,
            "files": [rel for rel, _ in chunk],
        })
        for rel, _ in chunk:
            file_index[rel] = {"category": category, "hash": bundle_hash, "archive": f"{category}/{bundle_hash}.zip"}

        if dry_run:
            continue

        staging_dir = category_dir / bundle_hash
        if staging_dir.exists():
            shutil.rmtree(staging_dir)

        if keep_staging:
            staging_dir.mkdir(parents=True)
            for rel in file_bytes:
                dst = staging_dir / rel
                dst.parent.mkdir(parents=True, exist_ok=True)
                dst.write_bytes(file_bytes[rel])

        bundle_path = category_dir / f"{bundle_hash}.zip"
        with zipfile.ZipFile(bundle_path, "w", compression=zipfile.ZIP_STORED) as zf:
            for rel, _ in chunk:  # already sorted -> reproducible member order
                zinfo = zipfile.ZipInfo(rel, date_time=ZIP_EPOCH)
                zinfo.external_attr = 0o644 << 16
                zf.writestr(zinfo, file_bytes[rel])

    return bundles, file_index


def main():
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1],
                         help="Repo root to scan (default: parent of tools/)")
    parser.add_argument("--output", type=Path, default=None,
                         help="Output directory (default: <root>/data/asset_bundles)")
    parser.add_argument("--chunk-size-mb", type=float, default=50,
                         help="Max uncompressed size per bundle, in MB (default: 50)")
    parser.add_argument("--exclude", action="append", default=[],
                         help="Extra directory name to exclude, pruned wherever it occurs (repeatable)")
    parser.add_argument("--keep-staging", dest="keep_staging", action="store_true", default=True,
                         help="Keep the unzipped staging folders next to the archives (default)")
    parser.add_argument("--no-staging", dest="keep_staging", action="store_false",
                         help="Skip writing staging folders, only produce the zip archives")
    parser.add_argument("--dry-run", action="store_true",
                         help="Only scan/chunk/hash and print a summary, write nothing to disk")
    args = parser.parse_args()

    root = args.root.resolve()
    output_dir = (args.output or (root / "data" / "asset_bundles")).resolve()
    chunk_bytes = int(args.chunk_size_mb * 1024 * 1024)
    extra_exclude_dirs = set(args.exclude)

    if not args.dry_run:
        if output_dir.exists():
            shutil.rmtree(output_dir)
        output_dir.mkdir(parents=True)

    icon_files, sound_files = [], []
    for f in iter_asset_files(root, extra_exclude_dirs):
        (icon_files if f.suffix.lower() in ICON_EXTENSIONS else sound_files).append(f)

    manifest = {"categories": {}, "files": {}}
    for category, files in (("icons", icon_files), ("sounds", sound_files)):
        bundles, file_index = build_category(
            category, files, root, output_dir, chunk_bytes, args.keep_staging, args.dry_run)
        manifest["categories"][category] = bundles
        manifest["files"].update(file_index)

    if not args.dry_run:
        with open(output_dir / "manifest.json", "w", encoding="utf-8") as fh:
            json.dump(manifest, fh, indent=2, sort_keys=True)

    total_files = len(icon_files) + len(sound_files)
    for category in ("icons", "sounds"):
        bundles = manifest["categories"][category]
        total_size = sum(b["total_size"] for b in bundles)
        print(f"{category}: {sum(b['file_count'] for b in bundles)} files, "
              f"{len(bundles)} bundles, {total_size / (1024 * 1024):.1f} MB")
    print(f"total: {total_files} files scanned")
    if not args.dry_run:
        print(f"output: {output_dir}")


if __name__ == "__main__":
    main()
