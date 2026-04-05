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
    # Catppuccin Mocha theme for fzf
    set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--height 40% --layout=reverse --border"
end

# ── direnv (per-directory env) ──
type -q direnv; and direnv hook fish | source

# ── uv (Python package manager) ──
type -q uv; and uv generate-shell-completion fish | source 2>/dev/null
