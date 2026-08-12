#!/usr/bin/env bash
# Symlinks this repo into ~/.config/quickshell/neon-drift so it can be
# launched as `qs -n -d -c neon-drift`.
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_dir="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/neon-drift"

mkdir -p "$(dirname "$target_dir")"

if [ -e "$target_dir" ] && [ ! -L "$target_dir" ]; then
    echo "error: $target_dir already exists and is not a symlink, refusing to overwrite" >&2
    exit 1
fi

ln -sfn "$repo_dir" "$target_dir"
echo "Linked $target_dir -> $repo_dir"
echo "Start it with: qs -n -d -c neon-drift"
