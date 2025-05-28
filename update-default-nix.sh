#!/usr/bin/env bash
# update.sh  ── bump Waterfox version & hash in default.nix
# --------------------------------------------------------
# deps: curl, jq, sed (GNU), nix-prefetch-url
set -euo pipefail

file="default.nix"
repo="BrowserWorks/Waterfox"

# -------- 1. discover latest stable release tag on GitHub --------------------
api="https://api.github.com/repos/${repo}/releases/latest"
echo "Fetching latest release info from GitHub…"
tag=$(curl -fsSL "$api" | jq -r .tag_name)           # e.g. "6.5.9"
[[ "$tag" == "null" || -z "$tag" ]] && {
  echo "Could not determine latest version (GitHub API rate-limited?)" >&2
  exit 1
}

version=$(sed -E 's/^[^0-9]*//' <<<"$tag")           # strip leading v/G if present
echo "Latest Waterfox version: $version"

# -------- 2. construct CDN URL & prefetch ------------------------------------
url="https://cdn1.waterfox.net/waterfox/releases/${version}/Linux_x86_64/waterfox-${version}.tar.bz2"
echo "Prefetching ${url} …"
hash=$(nix-prefetch-url --type sha256 "$url")

echo "sha256 (base-32): $hash"

# -------- 3. patch default.nix ------------------------------------------------
echo "Patching ${file} …"
sed -i -E \
  -e "s|version = \".*\";|version = \"${version}\";|" \
  -e "s|sha256[[:space:]]*= \".*\";|sha256 = \"${hash}\";|" \
  "$file"

echo "Done!  ${file} now targets Waterfox ${version}"
