# Environment variables & PATH (cross-platform)

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx LESS "-R -F -X --mouse"
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# XDG base dirs
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME   $HOME/.local/share
set -gx XDG_CACHE_HOME  $HOME/.cache

# Common tool paths (harmless if dirs don't exist — fish_add_path -a no-ops)
fish_add_path -g $HOME/.local/bin
fish_add_path -g $HOME/.cargo/bin
fish_add_path -g $HOME/go/bin

# Rust
set -q CARGO_HOME; or set -gx CARGO_HOME $HOME/.cargo
