#!/usr/bin/env bash
# Dotfiles installer — symlinks config files into $HOME.
# Works on macOS & Linux. No dependencies (stow not required).
#
# Usage:
#   ./install.sh              # install all packages
#   ./install.sh fish ghostty # install selected packages
#   ./install.sh --dry-run    # preview without changes
#   ./install.sh --uninstall  # remove symlinks that point into this repo

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALL_PACKAGES=(fish ghostty starship)

DRY_RUN=0
UNINSTALL=0
PACKAGES=()

for arg in "$@"; do
    case "$arg" in
        --dry-run)   DRY_RUN=1 ;;
        --uninstall) UNINSTALL=1 ;;
        -h|--help)
            sed -n '2,9p' "$0"; exit 0 ;;
        *) PACKAGES+=("$arg") ;;
    esac
done
[[ ${#PACKAGES[@]} -eq 0 ]] && PACKAGES=("${ALL_PACKAGES[@]}")

c_reset=$'\033[0m'; c_dim=$'\033[2m'; c_green=$'\033[32m'
c_yellow=$'\033[33m'; c_red=$'\033[31m'; c_blue=$'\033[34m'

run() {
    if [[ $DRY_RUN -eq 1 ]]; then
        echo "${c_dim}[dry-run]${c_reset} $*"
    else
        eval "$@"
    fi
}

link_file() {
    local src="$1" dst="$2"
    local dst_dir; dst_dir="$(dirname "$dst")"

    if [[ $UNINSTALL -eq 1 ]]; then
        if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
            echo "${c_yellow}remove${c_reset} $dst"
            run "rm '$dst'"
        fi
        return
    fi

    run "mkdir -p '$dst_dir'"

    if [[ -L "$dst" ]]; then
        if [[ "$(readlink "$dst")" == "$src" ]]; then
            echo "${c_dim}ok    ${c_reset} $dst"
            return
        fi
        echo "${c_yellow}relink${c_reset} $dst"
        run "rm '$dst'"
    elif [[ -e "$dst" ]]; then
        local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
        echo "${c_yellow}backup${c_reset} $dst -> $backup"
        run "mv '$dst' '$backup'"
    else
        echo "${c_green}link  ${c_reset} $dst"
    fi
    run "ln -s '$src' '$dst'"
}

install_package() {
    local pkg="$1"
    local pkg_dir="$DOTFILES_DIR/$pkg"
    [[ -d "$pkg_dir" ]] || { echo "${c_red}skip  ${c_reset} $pkg (not found)"; return; }

    echo "${c_blue}── $pkg ──${c_reset}"
    # Walk every regular file under $pkg_dir, mirror path into $HOME
    while IFS= read -r -d '' src; do
        local rel="${src#$pkg_dir/}"
        link_file "$src" "$HOME/$rel"
    done < <(find "$pkg_dir" -type f -print0)
}

echo "dotfiles: $DOTFILES_DIR"
[[ $DRY_RUN -eq 1 ]] && echo "(dry-run mode — no changes will be made)"
[[ $UNINSTALL -eq 1 ]] && echo "(uninstall mode)"

for pkg in "${PACKAGES[@]}"; do
    install_package "$pkg"
done

echo "${c_green}done${c_reset}"
