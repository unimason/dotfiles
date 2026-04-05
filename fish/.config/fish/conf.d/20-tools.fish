# Tool integrations — only load if tool is installed & shell is interactive

status is-interactive; or exit 0

# ── Starship prompt ──
type -q starship; and starship init fish | source

# ── zoxide (smarter cd) ──
if type -q zoxide
    zoxide init fish --cmd cd | source
end

# ── fzf keybindings (Ctrl+R history, Ctrl+T files, Alt+C dirs) ──
if type -q fzf
    # Prefer official fish integration (fzf >= 0.48)
    fzf --fish 2>/dev/null | source
    # Use fd for faster file listing if available
    if type -q fd
        set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
        set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
        set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
    end
    # Catppuccin Latte theme for fzf (matches light terminal)
    set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
--color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
--color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
--height 40% --layout=reverse --border"
end

# ── direnv (per-directory env) ──
type -q direnv; and direnv hook fish | source

# ── uv (Python package manager) ──
type -q uv; and uv generate-shell-completion fish | source 2>/dev/null
