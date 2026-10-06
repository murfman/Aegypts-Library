#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

# Ask once for version string (e.g. v1, v1.0, 2026-03-27)
read -rp "Enter version tag (e.g. v1, v1.0): " version

find . -mindepth 2 -type f -name '*.pdf' | while IFS= read -r pdf; do
  rel="${pdf#./}"
  dir="${rel%/*}"
  base="${rel##*/}"
  pre="Aegypts_Library"

  prefix="${dir##*/}"

  # New name: Prefix_Version.pdf
  new="${pre}-${prefix}-${version}"

  echo "Moving '$rel' -> '$new'"
  mv -- "$pdf" "$ROOT_DIR/$new"
done
