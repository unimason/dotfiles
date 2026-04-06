# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Cross-platform (macOS + Linux) terminal environment dotfiles: Ghostty + Fish + Starship. Mac side is for Claude Code work, Linux side for robotics/autonomous-driving dev. README.md is in Chinese and is the authoritative user-facing doc.

## Installation / common commands

There is no build, no test suite, no linter. The only "command" is the installer:

```bash
./install.sh              # symlink all packages into $HOME
./install.sh --dry-run    # preview
./install.sh fish         # install one package only
./install.sh --uninstall  # remove symlinks pointing into this repo
```

After editing fish config, reload with `exec fish`. Ghostty config changes only affect **new windows**. Files are symlinks to the repo, so edits take effect immediately (no re-run of `install.sh` needed unless you add new files).

## Architecture

**Stow-compatible layout.** Each top-level package dir (`fish/`, `ghostty/`, `starship/`) mirrors a path that gets symlinked into `$HOME`. Example: `fish/.config/fish/config.fish` → `~/.config/fish/config.fish`. `install.sh` is a zero-dependency replacement for GNU stow — it `find`s every regular file under a package dir and creates symlinks, backing up pre-existing non-symlink files to `<file>.bak.<timestamp>`.

**Special case — Ghostty on macOS** (`install.sh:87-91`): macOS Ghostty also reads `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`, which **takes precedence over** `~/.config/ghostty/config` (the GUI menu writes there). The installer creates a symlink at that path too. If the user changes a theme via Ghostty's GUI, re-run `./install.sh ghostty` to restore the repo symlink.

**Fish conf.d load order matters.** Files in `fish/.config/fish/conf.d/` load alphabetically:
- `00-env.fish` — PATH / EDITOR / XDG
- `05-os-darwin.fish` / `05-os-linux.fish` — OS-specific setup, each **self-guards** with a uname check so a wrong-OS file exits early. **Must load before `20-tools.fish`** because Homebrew PATH setup is needed before `starship`/`zoxide`/etc. are located (see commit 6d6903b).
- `10-aliases.fish` — cross-platform abbrs/aliases
- `20-tools.fish` — starship, zoxide, fzf, direnv init

**Graceful degradation.** Tool integrations are guarded with `type -q <tool>; and ...` so missing tools never error out. This lets the same repo work on a freshly-cloned machine with partial tool installs.

**Theme layering.** Ghostty uses Solarized Light; Starship uses Catppuccin Mocha pastel color blocks; fzf uses Catppuccin Latte. The four Catppuccin palettes are all embedded in `starship.toml` — switch by changing the single `palette = '...'` line at the top.

**Git abbr over alias.** Git shortcuts use fish `abbr` (space-expands to full command) instead of `alias`, so shell history and screen-sharing remain readable.

## Adding new config

- New cross-platform alias → `fish/.config/fish/conf.d/10-aliases.fish`
- New macOS-only / Linux-only tweak → `05-os-darwin.fish` / `05-os-linux.fish`
- New fish function → new file in `fish/.config/fish/functions/<name>.fish`
- New top-level package → add a dir, add its name to `ALL_PACKAGES` in `install.sh:14`

When adding a new file under an existing package, run `./install.sh <pkg>` once so the new symlink gets created.
