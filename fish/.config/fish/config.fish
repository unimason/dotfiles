# Fish main config — kept minimal.
# Actual configuration lives in conf.d/ (auto-sourced), organized by concern:
#   00-env.fish        PATH and environment variables
#   10-aliases.fish    aliases & abbreviations (cross-platform)
#   20-tools.fish      starship / zoxide / fzf integrations
#   50-os-darwin.fish  macOS-only (brew, etc.)
#   50-os-linux.fish   Linux-only (ROS, robotics toolchains)

if status is-interactive
    # Disable fish greeting
    set -g fish_greeting ""
end
