# dotfiles

跨平台（macOS + Linux + Windows）终端环境 — Mac 端 Claude Code vibe-coding，Linux 端机器人/自动驾驶开发，Windows 端日常开发。

**Stack**: Ghostty · Fish · Starship · WezTerm 　**Theme**: Ghostty/WezTerm Solarized Light · Starship Catppuccin Mocha · fzf Latte

---

## 目录结构

Stow 兼容布局 — 每个"包"下的路径即 `$HOME` 下的目标路径。

```
dotfiles/
├── README.md
├── install.sh                             零依赖 symlink 安装器（macOS/Linux）
├── .gitignore
├── ghostty/.config/ghostty/config         字体 · 主题 · 窗口 · 快捷键（macOS/Linux）
├── wezterm/.config/wezterm/wezterm.lua    字体 · 主题 · 窗口 · 快捷键（Windows）
├── starship/.config/starship.toml         双行 prompt · SSH hostname（跨平台）
└── fish/.config/fish/
    ├── config.fish                        入口（仅关闭 greeting）
    ├── conf.d/                            模块化配置，按字母序加载
    │   ├── 00-env.fish                    PATH · EDITOR · XDG
    │   ├── 05-os-darwin.fish              Homebrew · pbcopy（必须早于 20-tools）
    │   ├── 05-os-linux.fish               ROS2 · CUDA · wl-copy
    │   ├── 10-aliases.fish                git abbr · 现代 CLI 替换
    │   └── 20-tools.fish                  starship · zoxide · fzf · direnv
    └── functions/
        ├── mkcd.fish
        └── extract.fish
```

---

## 安装

### 新机器上首次部署

```bash
git clone <repo> ~/Code/dotfiles
cd ~/Code/dotfiles
./install.sh               # 安装全部
./install.sh --dry-run     # 预览，不写入
./install.sh fish          # 只装某个包
./install.sh --uninstall   # 卸载 symlink
```

已有同名文件会被备份为 `<file>.bak.<timestamp>`。

### 推荐工具链

配置在工具缺失时会优雅降级（`type -q` 守卫），以下工具安装后体验最佳：

**macOS：**
```bash
brew install fish starship eza bat fd ripgrep fzf zoxide direnv btop duf uv
brew install --cask ghostty font-jetbrains-mono-nerd-font
```

**Ubuntu/Debian：**
```bash
sudo apt install fish fzf ripgrep fd-find bat
curl -sS https://starship.rs/install.sh | sh

# Debian 把 fd → fdfind、bat → batcat，需要 symlink
mkdir -p ~/.local/bin
ln -sf "$(command -v fdfind)" ~/.local/bin/fd
ln -sf "$(command -v batcat)" ~/.local/bin/bat

cargo install eza zoxide        # eza / zoxide 通常通过 cargo 装

# Nerd Font
mkdir -p ~/.local/share/fonts && cd /tmp
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o JetBrainsMono.zip -d ~/.local/share/fonts && fc-cache -f
```

把 fish 设为默认 shell：
```bash
command -v fish | sudo tee -a /etc/shells
chsh -s "$(command -v fish)"
```

**Windows：**
```powershell
# 安装 WezTerm、PowerShell 7、Starship
winget install --id wez.wezterm
winget install --id Microsoft.PowerShell
winget install --id Starship.Starship

# 安装 Nerd Font
winget install --id JBMONO.JetBrainsMono.NerdFont   # 或从 nerdfonts.com 手动下载

# 部署配置
mkdir -p "$HOME/.config/wezterm"
cp wezterm/.config/wezterm/wezterm.lua "$HOME/.config/wezterm/wezterm.lua"

# PowerShell 7 profile（加载 Starship + 修正补全颜色）
mkdir -p "$HOME/Documents/PowerShell"
cat > "$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1" << 'EOF'
# Starship prompt
$ENV:STARSHIP_CONFIG = "<repo-path>\starship\.config\starship.toml"
Invoke-Expression (&starship init powershell)

# PSReadLine: fix InlinePrediction color for Solarized Light background
Set-PSReadLineOption -Colors @{
    InlinePrediction = "`e[38;2;131;148;150m"  # Solarized base0 (#839496)
}
EOF
```

---

## 自定义速查

### 切换 Starship 调色板

`starship.toml` 内已定义 4 种 Catppuccin 变体。改顶部这一行：
```toml
palette = 'catppuccin_mocha'
# 可选：catppuccin_latte · catppuccin_frappe · catppuccin_macchiato
```

### 启用/禁用 Prompt 段

Prompt 显示顺序在 `starship.toml` 顶部的 `format = """..."""` 中控制。
要启用某段，加入对应 `$xxx\` 行；禁用则删除该行。

**默认渲染（命中即显示）**：os · user · hostname(SSH) · dir · git · c/rust/go/node/php/java/kotlin/haskell/python · conda · time · cmd_duration

**已定义但未加入 format**（可在 format 中添加 `$docker_context\` 激活）：docker_context

### 禁用 cmd_duration 的系统通知

`starship.toml` 的 `[cmd_duration]`：
```toml
show_notifications = false    # 默认 true：命令 ≥45s 时 macOS/Linux 通知
min_time_to_notify = 45000    # 触发阈值（毫秒）
```

### 添加自定义 alias/abbr

- **跨平台**：编辑 `fish/.config/fish/conf.d/10-aliases.fish`
- **仅 macOS**：编辑 `conf.d/05-os-darwin.fish`
- **仅 Linux**：编辑 `conf.d/05-os-linux.fish`

添加新 fish 函数：在 `fish/.config/fish/functions/` 下新建 `<name>.fish`，格式：
```fish
function <name> --description '...'
    ...
end
```

### Ghostty 快捷键（macOS/Linux）

已配置（`ghostty/.config/ghostty/config`）：
- `Cmd+D` / `Cmd+Shift+D`　左右/上下分屏
- `Cmd+Alt+方向键`　　　　 切换分屏焦点
- `Cmd+T`　　　　　　　　 新 tab
- `Cmd+Shift+方向键`　　　 tab 切换
- `Cmd+±` / `Cmd+0`　　　　字号调整

### WezTerm 快捷键（Windows）

已配置（`wezterm/.config/wezterm/wezterm.lua`）：
- `Alt+D` / `Alt+Shift+D`　左右/上下分屏
- `Ctrl+Alt+方向键`　　　　切换分屏焦点
- `Alt+T`　　　　　　　　 新 tab
- `Alt+Shift+方向键`　　　 tab 切换
- `Ctrl+±` / `Ctrl+0`　　　 字号调整

---

## 设计决策

| 维度 | 方案 | 理由 |
|---|---|---|
| 主题分层 | Ghostty/WezTerm Solarized Light 底色 + starship Mocha pastel 色块 + fzf Latte | 浅底上用 Mocha 的柔和 pastel 做分段视觉点缀 |
| Prompt 行数 | 双行（信息行 + ❯ 输入行） | 长路径/大量元信息不挤压输入区 |
| Hostname | `ssh_only = true` | 本地 Mac 不显示，远程 Linux 自动出现 |
| Git abbr | `abbr` 代替 `alias` | 空格展开成完整命令，历史/屏幕共享可读 |
| OS 隔离 | `05-os-{darwin,linux}.fish` 自守卫 | 同一 repo 跑两端，误执行自动退出 |
| 工具降级 | `type -q xxx; and ...` 守卫 | 缺少工具不会报错 |
| 调色板保留 | 4 个 Catppuccin 变体全部内嵌 | 切换主题零成本 |
| 语言段保留 | 所有语言 section 都定义 | 未来进其他项目自动显示 |
| PSReadLine 补全色 | InlinePrediction 设为 Solarized base0 (`#839496`) | 默认颜色在 Solarized Light 背景上不可见 |

### Starship Prompt 结构

```
  󰀵  unimason  …/Desktop/Code/dotfiles   main !1   Py 3.11    10:32
❯
```

色段颜色：`red` → `peach` → `yellow` → `green` → `sapphire` → `lavender`
- red：OS + user (+ hostname@SSH)
- peach：当前目录
- yellow：git branch / status
- green：编程语言版本（自动检测）
- sapphire：conda 环境
- lavender：时间 + cmd_duration

---

## 常见问题

**Q: 安装后 prompt 图标显示方块/乱码**
A: 终端字体不是 Nerd Font。安装 JetBrainsMono Nerd Font 并在 Ghostty 配置 `font-family` 指向它。

**Q: fzf 的 Ctrl+R 没反应**
A: 检查 fzf 版本 `fzf --version`，需要 ≥ 0.48（`--fish` 参数引入时间）。旧版本需手动 source integration 脚本。

**Q: Linux 端 ROS 环境没自动 source**
A: `conf.d/05-os-linux.fish` 需要 `bass`（fish 的 bash 兼容层）来 source `.bash` 文件：`fisher install edc/bass`。或手动把 ROS 变量重写为 fish 版本。

**Q: 修改了 dotfiles 但没生效**
A: 文件是 symlink 指向仓库，改后立即生效。Fish 配置变更执行 `exec fish` 重载；Ghostty 配置改动仅影响**新窗口**；WezTerm 支持热重载，保存即生效。

**Q: Ghostty 主题/字体改了但没生效（macOS）**
A: Ghostty 在 macOS 上还会读 `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`，
这个路径**优先级高于** `~/.config/ghostty/config`（通常由 GUI 菜单写入）。`install.sh` 会
自动在这里也建 symlink 指向仓库。如果之后又用 GUI 菜单改了主题，需重跑 `./install.sh ghostty`。

---

## 版本同步工作流

```bash
cd ~/Code/dotfiles
git pull                     # 拉最新
./install.sh --dry-run       # 看看会动哪些文件
./install.sh                 # 应用（新文件自动 symlink；已 symlink 的无需操作）
exec fish                    # 重载 shell
```

---

## GitHub CLI (`gh`) 速查

本仓库用 `gh` 做建仓/鉴权，比 git 原生更省事。

### 新机器初始化

```bash
# 安装
brew install gh                              # macOS
sudo apt install gh                          # Debian/Ubuntu（或 https://cli.github.com）

# 登录（交互式：选 github.com → HTTPS → 浏览器授权）
gh auth login

# 验证
gh auth status
```

登录后 `git clone/pull/push` 走 HTTPS 自动用 token 认证，无需每次输密码。

### 日常命令

```bash
# 仓库
gh repo view --web                           # 浏览器打开当前仓库
gh repo clone unimason/dotfiles              # clone（自动用你登录的账号）
gh repo create <name> --public --source=. --remote=origin --push

# 提交 / PR
gh pr create --fill --web                    # 从当前 branch 建 PR
gh pr list                                   # 列 PR
gh pr view 123 --web                         # 看 PR
gh pr checkout 123                           # 本地切到别人的 PR

# Issue
gh issue list
gh issue create --title "..." --body "..."

# CI
gh run list                                  # Actions 运行历史
gh run watch                                 # 实时跟踪最新一次

# SSH key 管理
gh ssh-key list
gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(hostname -s)"
```

### 协议切换（HTTPS ↔ SSH）

当前仓库用 HTTPS（代理环境下更稳）。未来要切 SSH：

```bash
# 改默认协议（影响未来 gh clone 的仓库）
gh config set git_protocol ssh -h github.com

# 改当前仓库的 remote
git remote set-url origin git@github.com:unimason/dotfiles.git
```

### 增加 token 权限 scope

`gh` 默认只申请基础 scope。用到高级功能时扩容：

```bash
gh auth refresh -h github.com -s admin:public_key          # 上传 SSH key
gh auth refresh -h github.com -s admin:ssh_signing_key     # 签名用 SSH key
gh auth refresh -h github.com -s delete_repo               # 删除仓库
gh auth refresh -h github.com -s workflow                  # 改 Actions workflow
```

### 代理环境注意事项

如果本机有 ClashX/Surge 等透明 HTTPS 代理，**优先用 HTTPS 协议**走 git。SSH over 443
(`ssh.github.com:443`) 可能被代理 MITM 破坏签名。要走 SSH，需在代理规则里把
`ssh.github.com` 和 `github.com` 设为 DIRECT 直连。
