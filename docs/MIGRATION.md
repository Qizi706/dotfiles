# 多机器迁移手册

## 1. 克隆与选择配置层

桌面机器建议先使用通用层验证，再加入本机覆盖：

```sh
git clone https://github.com/Qizi706/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install --profile desktop --no-host --dry-run
./install --profile desktop --no-host
scripts/validate
```

`--no-host` 会把指向本仓库 `hosts/*` 的旧受管 local 软链移入私有备份，避免把上一台
机器的显示器/GPU 设置带到新机器；它不会触碰用户自建的 local 文件。

本机 `zq706` 可直接运行：

```sh
./install --profile desktop --host zq706
```

安装器会先完整验证所有 manifest，再备份冲突；它不会删除原文件。若发生替换，
最后一行会打印完整备份目录。备份目录为 `0700`，可能含旧 SSH/GnuPG 配置或应用状态，
必须按敏感数据对待，不要同步到公共位置。
恢复单个文件时，先移走新软链，再从备份中复制原文件；不要整目录覆盖新的 `$HOME`。

## 2. 为另一台机器建立覆盖层

不要把 `DP-4`、`2560x1440@143.999`、NVIDIA cursor-plane workaround 复制到未知硬件。
在新机器上先检查输出：

```sh
niri msg outputs
hyprctl monitors all
```

然后创建：

```text
hosts/<hostname>/links.conf
hosts/<hostname>/niri/outputs.kdl
hosts/<hostname>/niri/hardware.kdl
hosts/<hostname>/hypr/machine.lua
```

`links.conf` 可参考 `hosts/zq706/links.conf`。Niri/Hyprland 的 local include 都是可选的，
所以没有覆盖层时公共配置仍能解析。修改后运行：

```sh
./install --profile desktop --host <hostname>
scripts/validate
niri validate
Hyprland --verify-config -c ~/.config/hypr/hyprland.lua
```

## 3. 软件依赖

先做只读审计：

```sh
scripts/check-deps --profile desktop
```

`packages/arch-official.txt` 和 `packages/arch-aur.txt` 分为 required/optional。不要把清单
直接无脑交给包管理器；先处理检查器报告的 provider 与冲突。`uv` 已使用官方 Arch 包，
DMS 使用稳定版 `dms-shell + dms-shell-niri + dms-shell-hyprland`。Niri 与 Hyprland 的
截图入口全部只调用 `dms screenshot`，不再声明额外的截图 CLI 依赖。`wl-clipboard` 仍用于
两个合成器的剪贴板历史监听。

QQ、WeChat、Typora 等应用放在 optional 清单。新机应让软件包或 portable 包装器创建
自己的 desktop launcher，不把机器生成的用户 launcher 纳入 dotfiles。Linux QQ 使用
包自带的 `/usr/share/applications/qq.desktop`，无需额外创建 Niri 专用 launcher。

迁移 DMS 后执行：

```sh
systemctl --user daemon-reload
systemctl --user enable --now dms.service
```

tmux 在 TPM 尚未安装时也能启动。需要插件时，将 TPM 安装到
`~/.config/tmux/plugins/tpm`，进入 tmux 后按 `prefix + I`。Zsh 是主力交互 shell；
配置可识别 `~/.oh-my-zsh` 上游 clone 和 AUR 包提供的 `/usr/share/oh-my-zsh`。
`fzf-tab`、`zsh-autosuggestions`、`fast-syntax-highlighting` 是可选插件，只有实际存在时
才会按兼容顺序加载；`git`、`fzf`、`uv` 使用 Oh My Zsh 自带插件。未安装 Oh My Zsh
时仍会回退到 Zsh 原生补全、fzf、zoxide 和 Starship。

Yazi 使用官方 Catppuccin Mocha flavor。desktop profile 链接 `theme.toml` 和带固定 revision
的 `package.toml`；首次安装或更新后运行 `ya pkg install`，让 Yazi 在 HOME 的真实
`~/.config/yazi/flavors` 目录中部署主题资源。

Zathura 还需要一个 PDF backend；清单默认列出 `zathura-pdf-mupdf`，也可以经审阅后
改选 `zathura-pdf-poppler`。

切换登录 shell 前先开一个交互 Zsh 验收插件与 PATH，然后执行：

```sh
zsh -l
chsh -s /usr/bin/zsh
getent passwd "$USER"
```

`chsh` 只影响新登录会话。Niri 的 `niri-session` 会在下次注销登录时启动 login Zsh，
再把 `profile.sh` 中的环境导入 systemd 与 D-Bus；现有图形会话不会就地换 shell。

## 4. 独立配置与私密数据

Neovim 不嵌套进 dotfiles，它继续使用独立仓库：

```sh
git clone --branch macos git@github.com:Qizi706/nvim.git ~/.config/nvim
```

`macos` 是本机当前分支名；迁移前应确认目标机器真正需要的分支。`nvim.log` 是运行
日志，已从该仓库取消跟踪并加入忽略，不应作为配置迁移。

传统 Vim 仍在使用，其 `.vimrc` 与 Catppuccin Mocha 配色由 core profile 纳管；
`.vim/.netrwhist` 等运行态继续留在 HOME，不进入仓库。

DMS/Matugen 主题输出（Kitty/Ghostty/Alacritty、GTK/Qt palette、Firefox CSS、
dgop 和 Neovim colors）不作为配置快照迁移。安装后由 DMS 在 HOME 的真实目录重新生成；
受管的静态入口和 Catppuccin/Noctalia fallback 保证生成前仍有可用基础主题。不要把这些
输出改成指向仓库的软链，否则切换壁纸或主题会直接修改 Git 工作树。

DMS 的自定义主题、插件和 `settings.json` 不是公开 dotfiles，也不能只靠 Matugen 重建。
它们应进入加密或私有备份（归档中可能包含插件设置），源机与新机分别执行：

```sh
dms backup create -o /path/to/private/dms-backup.tar.gz
dms backup restore /path/to/private/dms-backup.tar.gz
```

不要把该归档放进本仓库。restore 后重新登录，再检查 DMS service、主题、插件和 Matugen
开关；本机当前相关终端模板开关为关闭状态，但文件边界已经为以后启用做好隔离。

以下内容必须通过密码管理器、加密备份或硬件密钥单独恢复：

- `~/.ssh` 私钥与 `known_hosts`；仓库只含通用 `.ssh/config`。
- GnuPG keybox、trustdb 和私钥；仓库只含 `.gnupg/common.conf`。
- 浏览器 profile、Pulse cookie、Rime 用户词库、应用 token 和 shell history。
- DMS/dgop 生成的 `~/.config/dgop/colors.json`；它应由新会话重新生成。

安装器会确保 `~/.ssh`、`~/.gnupg` 权限为 `0700`，但不会生成或复制任何密钥。

Git 姓名与邮箱同样不进入公共仓库。首次安装后执行：

```sh
install -m 0600 templates/git-local.conf.example ~/.config/git/local.conf
$EDITOR ~/.config/git/local.conf
git config --show-origin --get user.email
```

本配置只使用 `Qizi706` 这一套 Git 身份；本机已有的邮箱保留在该 local 文件中。不要增加
条件 include，也不要把真实邮箱写回受管 `.gitconfig`。命令输出的 origin 应为
`~/.config/git/local.conf`。

## 5. 登录后验收

```sh
./install --profile desktop --host "${HOSTNAME%%.*}" --check
scripts/validate
systemctl --user status dms.service
niri validate
```

若安装时 Niri 正在运行，完成后再执行一次 `niri msg action load-config-file`，确保当前进程
加载了最后写入的 host overlay；该动作只重载配置，不会切换工作区或移动窗口。

然后人工检查以下运行时行为：

- 截图写入 `~/Pictures/Screenshots`。
- Fcitx 5、DMS、portal 屏幕共享、音频和显示器缩放正常。
- 重载 tmux（`prefix + r`）后，终端到 tmux 再到 Neovim 的扩展按键链路正常。

静态 validator 无法替代物理按键、GPU 渲染、屏幕共享和真实 GUI 主题测试。
