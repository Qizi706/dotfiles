# dotfiles

个人 Shell 配置仓库。目前以 Zsh 为主，包含通用环境变量、Oh My Zsh
插件、fzf 配置以及少量 Fish 旧配置。

## 功能

- Oh My Zsh、Starship 和 zoxide
- fzf-tab 交互式补全
- zsh-autosuggestions 与命令补全建议
- zsh-syntax-highlighting
- Git、Homebrew 和常用命令补全
- 共享的 XDG、编辑器和开发工具环境变量
- 独立的 Zsh 历史文件：`$XDG_STATE_HOME/zsh/history`

## 仓库结构

```text
.
├── .zprofile                  # Zsh 登录环境
├── .zshrc                     # Zsh 交互配置
├── config
│   ├── bootstrap.zsh          # 安装 Oh My Zsh 和第三方插件
│   ├── fzf/fzfrc              # fzf 参数
│   └── shell
│       ├── profile.sh         # Bash/Zsh 通用环境变量
│       └── profile.fish       # Fish 环境变量（保留配置）
└── .gitignore
```

## 依赖

最低依赖：

```text
zsh
git
```

推荐安装：

```text
fzf
bat
fd
ripgrep
zoxide
starship
neovim
less
```

macOS 可以使用 Homebrew：

```bash
brew install zsh git fzf bat fd ripgrep zoxide starship neovim
```

Linux 请使用发行版包管理器安装对应软件。Debian/Ubuntu 中 `bat` 和
`fd` 的命令名可能分别是 `batcat` 和 `fdfind`，需要按系统情况提供
`bat`、`fd` 命令或调整配置。

## 安装

### 1. 克隆仓库

当前 Zsh 配置位于 `zsh` 分支：

```bash
git clone --branch zsh \
  git@github.com:Qizi706/dotfiles.git \
  "$HOME/.dotfiles"
```

尚未配置 GitHub SSH 时可以使用 HTTPS：

```bash
git clone --branch zsh \
  https://github.com/Qizi706/dotfiles.git \
  "$HOME/.dotfiles"
```

### 2. 备份已有配置

以下命令只移动已经存在的文件或符号链接：

```zsh
backup_suffix="before-dotfiles-$(date +%Y%m%d-%H%M%S)"

for config_path in \
  "$HOME/.zshrc" \
  "$HOME/.zprofile" \
  "$HOME/.config/shell/profile.sh" \
  "$HOME/.config/fzf/fzfrc"
do
  if [[ -e "$config_path" || -L "$config_path" ]]; then
    mv "$config_path" "${config_path}.${backup_suffix}"
  fi
done
```

### 3. 创建符号链接

```bash
mkdir -p "$HOME/.config/shell" "$HOME/.config/fzf"

ln -s "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"
ln -s "$HOME/.dotfiles/.zprofile" "$HOME/.zprofile"
ln -s "$HOME/.dotfiles/config/shell/profile.sh" \
  "$HOME/.config/shell/profile.sh"
ln -s "$HOME/.dotfiles/config/fzf/fzfrc" \
  "$HOME/.config/fzf/fzfrc"
```

### 4. 安装 Oh My Zsh 和插件

```bash
zsh "$HOME/.dotfiles/config/bootstrap.zsh"
```

脚本会安装 Oh My Zsh 及以下第三方插件：

- `fzf-tab`
- `zsh-autosuggestions`
- `zsh-bat`
- `zsh-completions`
- `zsh-syntax-highlighting`

`git`、`fzf`、`sudo`、`copypath` 和 `history-substring-search` 来自
Oh My Zsh，无需单独下载。

### 5. 启动 Zsh

```bash
exec zsh -l
```

如需设置为系统默认 Shell：

```bash
chsh -s "$(command -v zsh)"
```

某些受管 Devbox、容器或远程环境不允许 `chsh`，直接运行 `zsh -l`，
或将终端启动命令设置为 `zsh -l` 即可。

## Devbox 和其他系统

dotfiles 负责配置，目标系统仍需提供上文列出的命令。对于 Jetify
Devbox，可以在 Devbox 项目中声明这些包，然后进入环境后执行同样的
符号链接和 bootstrap 步骤：

```bash
devbox shell
zsh "$HOME/.dotfiles/config/bootstrap.zsh"
exec zsh -l
```

配置中的 Homebrew 初始化带有存在性检查，因此没有 Homebrew 的 Linux
环境会自动跳过。Git 补全也会优先选择目标系统提供的原生 Zsh `_git`，
不会要求固定的 Homebrew 安装路径。

## 验证

```bash
zsh -n "$HOME/.zshrc"
zsh -n "$HOME/.zprofile"

zsh -lic 'print -r -- "$HISTFILE"'
zsh -lic 'whence -v _git'
zsh -lic 'bindkey "^I"'
```

交互测试：

```text
git switch -<Tab>    # 补全短参数和长参数
git switch <Tab>     # 补全分支
brew install <Tab>   # macOS/Homebrew 包补全
```

## 日常更新

从 GitHub 获取配置并补装新增插件：

```bash
cd "$HOME/.dotfiles"
git pull --ff-only
zsh config/bootstrap.zsh
exec zsh -l
```

配置文件通过符号链接指向仓库，因此可以直接编辑 `~/.zshrc` 或
`~/.zprofile`，然后在仓库中提交：

```bash
cd "$HOME/.dotfiles"
git status
git diff
git add .zshrc .zprofile config
git diff --cached
git commit -m "Update shell configuration"
git push
```

## 安全说明

不要提交以下内容：

- Shell 历史文件和 `.zcompdump`
- `~/.ssh`、私钥、访问令牌和密码
- `.env`、缓存和运行时状态
- 整个 `~/.oh-my-zsh` 目录

这些内容已经在 `.gitignore` 中声明，但提交前仍应使用
`git diff --cached` 检查实际将要上传的内容。

## 故障排查

### 出现 `plugin not found`

重新运行：

```bash
zsh "$HOME/.dotfiles/config/bootstrap.zsh"
exec zsh -l
```

### 配置没有加载

确认链接目标正确：

```bash
ls -l "$HOME/.zshrc" "$HOME/.zprofile"
```

`.zprofile` 只在登录 Shell 中加载。Devbox 或集成终端没有启动登录
Shell 时，请使用 `zsh -l`。

### 补全没有刷新

先开启一个全新的登录 Shell：

```bash
exec zsh -l
```

Oh My Zsh 会根据 `fpath` 变化自动更新补全缓存，通常不需要手动删除
`.zcompdump`。
