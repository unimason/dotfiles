# Linux-only configuration (robotics / autonomous-driving workstation)
test (uname) = Linux; or exit 0
status is-interactive; or exit 0

# xdg-open alias mirroring macOS `open`
type -q xdg-open; and alias open='xdg-open'

# ── ROS 2 (set ROS_DISTRO before sourcing) ──
# Edit $ROS_DISTRO per-machine; the source is guarded so missing installs are ignored.
set -q ROS_DISTRO; or set -gx ROS_DISTRO humble

if test -f /opt/ros/$ROS_DISTRO/setup.bash
    # Fish can't source bash directly — use bass if available, otherwise a helper function
    if type -q bass
        bass source /opt/ros/$ROS_DISTRO/setup.bash
    end
    # Colcon convenience
    abbr -a cb  'colcon build --symlink-install'
    abbr -a cbp 'colcon build --symlink-install --packages-select'
    abbr -a ct  'colcon test'
end

# CUDA (common path)
if test -d /usr/local/cuda/bin
    fish_add_path -g /usr/local/cuda/bin
    set -gx LD_LIBRARY_PATH /usr/local/cuda/lib64 $LD_LIBRARY_PATH
end

# Clipboard helpers (X11 / Wayland)
if type -q wl-copy
    alias pbcopy='wl-copy'
    alias pbpaste='wl-paste'
else if type -q xclip
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
end
