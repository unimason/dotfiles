# dotfiles

跨平台（macOS + Linux）终端环境 — Mac 端 Claude Code vibe-coding，Linux 端机器人/自动驾驶开发。

**Stack**: Ghostty · Fish · Starship 　**Theme**: Catppuccin Mocha

---

## 目录结构

Stow 兼容布局 — 每个"包"下的路径即 `$HOME` 下的目标路径。

```
dotfiles/
├── README.md
├── install.sh                             零依赖 symlink 安装器
├── .gitignore
├── ghostty/.config/ghostty/config         字体 · 主题 · 窗口 · 快捷键
├── starship/.config/starship.toml         双行 prompt · SSH hostname
└── fish/.config/fish/
    ├── config.fish                        入口（仅关闭 greeting）
    ├── conf.d/                            模块化配置，自动加载
    │   ├── 00-env.fish                    PATH · EDITOR · XDG
    │   ├── 10-aliases.fish                git abbr · 现代 CLI 替换
    │   ├── 20-tools.fish                  starship · zoxide · fzf · direnv
    │   ├── 50-os-darwin.fish              Homebrew · pbcopy
    │   └── 50-os-linux.fish               ROS2 · CUDA · wl-copy
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

---

## 自定义速查

### 切换 Starship 调色板

`starship.toml` 内已定义 4 种 Catppuccin 变体。改顶部这一行：
```toml
palette = 'catppuccin_mocha'
# 可选：catppuccin_frappe · catppuccin_latte · catppuccin_macchiato
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
- **仅 macOS**：编辑 `conf.d/50-os-darwin.fish`
- **仅 Linux**：编辑 `conf.d/50-os-linux.fish`

添加新 fish 函数：在 `fish/.config/fish/functions/` 下新建 `<name>.fish`，格式：
```fish
function <name> --description '...'
    ...
end
```

### Ghostty 快捷键

已配置（`ghostty/.config/ghostty/config`）：
- `Cmd+D` / `Cmd+Shift+D`　左右/上下分屏
- `Cmd+Alt+方向键`　　　　 切换分屏焦点
- `Cmd+T`　　　　　　　　 新 tab
- `Cmd+Shift+方向键`　　　 tab 切换
- `Cmd+±` / `Cmd+0`　　　　字号调整

---

## 设计决策

| 维度 | 方案 | 理由 |
|---|---|---|
| 主题统一 | Catppuccin Mocha 贯穿 ghostty + starship + fzf | 视觉一致、跨 OS 都有支持 |
| Prompt 行数 | 双行（信息行 + ❯ 输入行） | 长路径/大量元信息不挤压输入区 |
| Hostname | `ssh_only = true` | 本地 Mac 不显示，远程 Linux 自动出现 |
| Git abbr | `abbr` 代替 `alias` | 空格展开成完整命令，历史/屏幕共享可读 |
| OS 隔离 | `50-os-{darwin,linux}.fish` 自守卫 | 同一 repo 跑两端，误执行自动退出 |
| 工具降级 | `type -q xxx; and ...` 守卫 | 缺少工具不会报错 |
| 调色板保留 | 4 个 Catppuccin 变体全部内嵌 | 切换主题零成本 |
| 语言段保留 | 所有语言 section 都定义 | 未来进其他项目自动显示 |

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
A: `conf.d/50-os-linux.fish` 需要 `bass`（fish 的 bash 兼容层）来 source `.bash` 文件：`fisher install edc/bass`。或手动把 ROS 变量重写为 fish 版本。

**Q: 修改了 dotfiles 但没生效**
A: 文件是 symlink 指向仓库，改后立即生效。Fish 配置变更执行 `exec fish` 重载；Ghostty 配置改动仅影响**新窗口**。

---

## 版本同步工作流

```bash
cd ~/Code/dotfiles
git pull                     # 拉最新
./install.sh --dry-run       # 看看会动哪些文件
./install.sh                 # 应用（新文件自动 symlink；已 symlink 的无需操作）
exec fish                    # 重载 shell
```
