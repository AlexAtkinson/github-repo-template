#!/usr/bin/env bash

set -euo pipefail

readonly start_marker='# HOOKSYNC - AUTOCONFIG START --------------------------------------------------'
readonly end_marker='# HOOKSYNC - AUTOCONFIG END ----------------------------------------------------'

repo_root=$(git rev-parse --show-toplevel)
hooks_dir=$(git rev-parse --git-path hooks)
source_dir="$repo_root/.githooks/hooks"

cd "$repo_root"
mkdir -p "$hooks_dir"

strip_managed_block() {
  awk -v start="$start_marker" -v end="$end_marker" '
    $0 == start { skipping = 1; next }
    $0 == end { skipping = 0; next }
    !skipping { print }
  ' "$1"
}

sync_hook() {
  local source_hook=$1
  local hook_name target_hook temporary_file managed_block

  hook_name=$(basename "$source_hook")
  target_hook="$hooks_dir/$hook_name"
  temporary_file=$(mktemp)
  managed_block=$(mktemp)

  {
    printf '%s\n' "$start_marker"
    printf '%s\n' '# WARNING: Changes to this section will be overwritten.'
    printf '%s\n' '#          Maintained by .githooks/hooks.'
    printf '%s\n' '#'
    cat "$source_hook"
    # Keep the end marker on its own line when the source lacks a trailing newline.
    [[ -z $(tail -c 1 "$source_hook") ]] || printf '\n'
    printf '%s\n' "$end_marker"
  } > "$managed_block"

  if [[ -f "$target_hook" ]]; then
    strip_managed_block "$target_hook" > "$temporary_file"
  else
    printf '%s\n' '#!/usr/bin/env bash' > "$temporary_file"
  fi

  cat "$managed_block" >> "$temporary_file"

  if [[ ! -f "$target_hook" ]] || ! cmp -s "$temporary_file" "$target_hook"; then
    mv "$temporary_file" "$target_hook"
  else
    rm "$temporary_file"
  fi
  rm "$managed_block"
  chmod +x "$target_hook"
}

for source_hook in "$source_dir"/*; do
  [[ -f "$source_hook" ]] || continue
  sync_hook "$source_hook"
done

for target_hook in "$hooks_dir"/*; do
  [[ -f "$target_hook" ]] || continue
  hook_name=$(basename "$target_hook")
  [[ -f "$source_dir/$hook_name" ]] && continue
  grep -Fqx "$start_marker" "$target_hook" || continue

  temporary_file=$(mktemp)
  strip_managed_block "$target_hook" > "$temporary_file"
  mv "$temporary_file" "$target_hook"
done