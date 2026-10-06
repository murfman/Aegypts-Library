#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

read -rp "Enter version tag (e.g. v1, v1.0): " version

if [[ ! "$version" =~ ^[[:alnum:]_.-]+$ ]]; then
  echo "Invalid version: use letters, numbers, dots, underscores, or hyphens." >&2
  exit 1
fi

# Look for .out files in subfolders, including nested subfolders.
while IFS= read -r -d '' out; do
  # Replace the final .out extension with .pdf.
  pdf="${out%.out}.pdf"

  if [[ ! -f "$pdf" ]]; then
    printf 'Skipping: no matching PDF for %q\n' "$out" >&2
    continue
  fi

  dir="${out%/*}"
  prefix="${dir##*/}"

  stem="Aegypts_Library-${prefix}-${version}"
  new="${stem}.pdf"
  count=2

  # Avoid existing files, directories, and dangling symlinks.
  while [[ -e "$ROOT_DIR/$new" || -L "$ROOT_DIR/$new" ]]; do
    new="${stem}-${count}.pdf"
    count=$((count + 1))
  done

  printf 'Copying %q -> %q\n' "$pdf" "$new"
  printf 'DRY RUN: would copy %q to %q\n' "$pdf" "$ROOT_DIR/$new"
  #cp -nT -- "$pdf" "$ROOT_DIR/$new"

done < <(find . -mindepth 2 -type f -name '*.out' -print0)
