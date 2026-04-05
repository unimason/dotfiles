# Aliases & abbreviations (cross-platform)
# - `abbr` expands in place (visible before execution) — preferred for git/docker
# - `alias` is a wrapper function — use for tool substitution

status is-interactive; or exit 0

# ── Tool substitution (only if installed) ──
if type -q eza
    alias ls='eza --group-directories-first --icons'
    alias ll='eza -l --group-directories-first --icons --git'
    alias la='eza -la --group-directories-first --icons --git'
    alias tree='eza --tree --icons'
else
    alias ll='ls -lh'
    alias la='ls -lAh'
end

type -q bat     ; and alias cat='bat --paging=never'
type -q fd      ; and alias find='fd'
type -q rg      ; and alias grep='rg'
type -q duf     ; and alias df='duf'
type -q btop    ; and alias top='btop'

# ── Git abbreviations ──
abbr -a g    git
abbr -a gs   git status
abbr -a gd   git diff
abbr -a gds  git diff --staged
abbr -a ga   git add
abbr -a gap  git add -p
abbr -a gc   git commit
abbr -a gcm  git commit -m
abbr -a gca  git commit --amend
abbr -a gco  git checkout
abbr -a gcb  git checkout -b
abbr -a gl   git log --oneline --graph --decorate
abbr -a gll  git log --oneline --graph --decorate --all
abbr -a gp   git push
abbr -a gpl  git pull
abbr -a gf   git fetch --all --prune
abbr -a gb   git branch
abbr -a gst  git stash
abbr -a gstp git stash pop

# ── Docker ──
abbr -a d   docker
abbr -a dc  docker compose
abbr -a dps docker ps
abbr -a dpa docker ps -a

# ── Navigation ──
abbr -a ..     cd ..
abbr -a ...    cd ../..
abbr -a ....   cd ../../..
abbr -a -     'cd -'

# ── Claude Code ──
abbr -a cc  claude
