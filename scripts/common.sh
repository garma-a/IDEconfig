#!/usr/bin/env bash
backup_path() {
  local target=$1
  if [[ -e "$target" || -L "$target" ]]; then
    local saved="${target}.backup.$(date +%Y%m%d-%H%M%S).$$"
    mv -- "$target" "$saved"
    printf 'Backed up %s to %s\n' "$target" "$saved"
  fi
}
link_file() {
  local source=$1 target=$2
  [[ "$(readlink -- "$target" 2>/dev/null || true)" == "$source" ]] && return 0
  mkdir -p -- "$(dirname -- "$target")"
  backup_path "$target"
  ln -s -- "$source" "$target"
}
replace_tree() { backup_path "$2"; mv -- "$1" "$2"; }
clone_if_missing() {
  [[ -d "$2/.git" ]] && return 0
  [[ ! -e "$2" ]] || { echo "Expected Git checkout at $2; move it aside before rerunning." >&2; return 1; }
  git clone --depth 1 "$1" "$2"
}
