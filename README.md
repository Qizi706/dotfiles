# dotfiles

这是一套面向 Arch Linux 的可迁移配置，覆盖 Niri、Hyprland、Zsh/Bash、
可选的 Fish fallback、Vim、Ghostty/tmux、Fcitx 5 以及 GTK/Qt。机器相关的显示器和
驱动设置与公共配置分离。

## 当前机器

`zq706` 使用 `hosts/zq706` 覆盖层。

## 安装

先预览，再应用：

```sh
git clone https://github.com/Qizi706/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install --profile desktop --host zq706 --dry-run
./install --profile desktop --host zq706
./install --profile desktop --host zq706 --check
scripts/validate
scripts/check-deps --profile desktop
```

`./install` 不联网，也不删除冲突文件。它会先验证完整清单，再开始
写入；冲突会先移动到权限为 `0700` 的
`$XDG_STATE_HOME/dotfiles/backups/<时间>-<进程号>/`。旧版配置留下的整目录软链会先
拆成真实目录，以免 Fish 变量、tmux 插件、Pulse cookie 等运行时状态继续写进仓库。

可用安装模式：

- `--profile core`：安装主力 Zsh、Bash fallback、Git、SSH/GnuPG 配置和终端基础工具。
- `--profile desktop`：在 core 之上安装桌面、输入法、终端和合成器配置。
- `--host NAME`：叠加 `hosts/NAME/links.conf`；本机也会自动识别 `zq706`。
- `--no-host`：不安装主机层；会备份并移走指向本仓库 `hosts/*` 的旧受管软链，
  但不会触碰用户自建 local 文件。
- `--dry-run` / `--check`：分别预览操作和只读检查当前链接。

## 目录边界

- `config/niri/include`、`config/hypr`：跨机器公共行为。
- `hosts/<主机名>`：输出接口、分辨率、缩放、GPU workaround。
- `manifests`：逐文件/目录安装清单，避免链接整个动态状态目录。
- `packages`：Arch 官方仓库与 AUR 依赖清单；检查器只读，不会安装或升级。
- `docs`：迁移步骤和已发现问题。

SSH 私钥、GnuPG 私钥、浏览器资料、Rime 用户数据库、cookies、历史、日志、缓存、
DMS 生成文件以及 Neovim 的独立 Git 仓库均不进入本仓库。

详细步骤见 [迁移手册](docs/MIGRATION.md)，审计结果见
[问题与解决办法](docs/KNOWN_ISSUES.md)。
