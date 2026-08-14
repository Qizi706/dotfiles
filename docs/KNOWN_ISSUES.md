# 配置审计：问题与解决办法

## 已落实修复

| 问题 | 处理结果 | 验证 |
| --- | --- | --- |
| 旧 Dotbot 目录是普通文件与损坏子模块的混合体，`./install` 无法可靠启动；同时 `clean: ['~']` 范围过大 | 移除 Dotbot 和危险 clean，改为本地、主机感知、完整 preflight、私有冲突备份的安装器 | 空 HOME 安装、错误清单零写入、冲突备份、重复 `--check` 均通过 |
| 旧安装器整目录链接 Fish/tmux/Fcitx/Pulse 等动态目录，运行时数据会落入仓库 | 新清单只链接必要文件；首次安装会安全拆离指向本仓库的旧目录软链并保留内容 | 隔离迁移验证了 Fish 状态保留且配置改为逐项软链 |
| 旧目录清单中的路径若指向其他仓库，预检曾可能把它误判为“稍后可拆离”；权限目录也可能跟随外部软链执行 chmod | 只有“末端确为软链且解析到当前 checkout”的旧目录才允许拆离；其他 parent/directory symlink 在首个写入前拒绝 | 新增外部 Fish 与 SSH 目录软链零写入回归用例；连同生成态/回滚/host 切换共 9 项回归通过 |
| Niri 仓库版本陈旧，且 `Mod+J/K` 的旧动作会在窗口和工作区之间混合跳转 | 按 Niri 26.04 拆分配置；`Mod+J/K` 固定为 `focus-workspace-down/up` | 公共配置与 `zq706` 集成配置均通过 `niri validate` |
| “切换工作区、移动窗口到工作区、重排整个工作区”容易混淆 | `Mod+J/K` 只切换；`Mod+Shift+U/I` 或 `Mod+Ctrl+U/I` 移动窗口；未给 J/K 绑定 `move-workspace-*` | 对所有 Niri bind 做了动作分类检查 |
| `zq706` 的 DP-4、缩放、NVIDIA workaround 混在公共配置，且配置过 VRR，但连接器报告不支持 | 移入 `hosts/zq706`；DP-4 使用 `2560x1440@143.999`、scale 1.25，VRR 明确禁用；cursor-plane workaround 仅本机加载 | 主机集成 validator 通过；输出能力来自本机运行时审计 |
| 合成器运行中安装时，先链接入口文件会让自动 reload 短暂看到缺失的 host/include | 安装顺序改为 host overlay → include/scripts → compositor entrypoint；本次另执行一次 Niri 安全 reload | 运行时事件已返回 `ConfigLoaded.failed=false`，最新 reload 无 optional include warning |
| Hyprland 仓库版本仍是过时 hyprlang，0.56 会拒绝旧 `dwindle:pseudotile` | 同步为 0.56 Lua 配置，公共 preferred-mode fallback 与本机 monitor override 分离 | 公共及主机集成配置均通过 `Hyprland --verify-config` |
| Fish 使用不存在的 `fish_preexec` 历史过滤；`cd`、fastfetch、Conda 在工具缺失时会报错 | 改用 `fish_should_add_to_history`，为 zoxide/fastfetch/Conda 加能力检测与 fallback | Fish 语法和隔离功能断言通过 |
| Zsh 无条件加载 Oh My Zsh、插件、zoxide、starship 和 proxy 文件 | 所有可选组件均按存在性加载；缺失时保留可用基础 prompt | `zsh -n` 通过；缺依赖路径为静态验证 |
| Bash/Fish Conda 初始化硬编码用户名路径 | 优先使用 PATH 中的 conda，回退 `$HOME/Programming/miniconda3` | 两种 shell 初始化测试通过 |
| Fish/Zsh proxy 分别使用 7890/7897，协议和大小写变量不一致 | 统一到 `127.0.0.1:7890`，HTTP(S)+SOCKS5 和 `no_proxy` 同步 | 开关与变量断言通过 |
| tmux 扩展键配置使用 `on`，TPM/Catppuccin 路径分裂，新机无插件时解析失败 | 改为 `extended-keys always` + CSI-u，统一 XDG 插件目录并条件加载 | 隔离 tmux server 解析通过 |
| tmux 仍有重复的旧 `~/.tmux/plugins/tpm`，Catppuccin 不在 TPM 清单且版本漂移 | 旧 TPM 移入私有备份；Catppuccin 固定 `v2.1.3`，标准 TPM 路径优先并兼容一次旧 nested checkout | 当前 XDG TPM 保留；新机 `prefix + I` 可安装声明的主题 |
| qt6ct 有重复段、窗口几何状态和用户名绝对路径 | 只保留单一 Appearance 段，palette 使用用户目录形式 | INI 静态检查通过；真实 Qt GUI 外观仍需人工检查 |
| Foot 主题使用已弃用 `[colors]` | 纳管 Foot，并把 palette 改为 `[colors-dark]` | 隔离 `foot -C` 无 warning 通过 |
| DMS/Matugen 会重写 Alacritty、Kitty、Foot、Ghostty、GTK、Qt、Firefox 等主题输出；目录或输出文件软链会把一次换主题直接写进仓库 | 这些目录改为 HOME 真实目录，只链接静态入口/备用主题；所有已知 Matugen 输出均从 Git 移除并 ignore，Kitty 用可选 `globinclude`，GTK 默认仅导入静态 Noctalia，避免新机缺生成文件时报 CSS provider 错误 | 隔离 Matugen 实测确认写入路径；validator 逐项断言生成文件未跟踪、已 ignore、且不再整目录链接 |
| DMS 自定义主题、插件和 `settings.json` 不能由公共配置或 Matugen 输出重建，且可能含本机偏好 | 不进入公共仓库；迁移手册改用 `dms backup create/restore` 放到加密或私有位置 | 本机 `dms backup` 两个子命令的 help 已核对；未替用户创建可能含私密设置的归档 |
| 截图目录同时出现 `Screenshot`、`Screenshots`，Hyprland 固定文件名会覆盖 | 全部统一到 `$HOME/Pictures/Screenshots`，安装器创建目录 | Niri/Hyprland validator 与 profile 断言通过 |
| 已卸载的 Clash Verge/mihomo autostart 与用户级 MIME handler 残留 | 删除失效 autostart；把调用不存在 `/usr/bin/clash-verge` 的 handler 移入私有备份；scheme handler 改为当前 `flclash.desktop`，刷新 desktop database | 两个 clash scheme 的 `xdg-mime query default` 均返回 `flclash.desktop` |
| 用户级 `qq.desktop` 是指向已删除 Niri launcher 的断链，会遮蔽系统 Linux QQ 启动器 | 把断链移入私有备份并刷新 desktop database，继续使用软件包提供的 `/usr/share/applications/qq.desktop` | 系统 launcher 的 `Exec=linuxqq %U`，`/usr/bin/linuxqq` 归属于已安装的 `linuxqq` 包；菜单显示仍需人工确认 |
| DankSearch 未安装，却监听所有接口并索引整个 home | 仓库和 HOME 中的旧配置均移除；本机副本可从 `20260814-final-cleanup` 私有备份恢复。若以后启用，应只监听 loopback、限定白名单目录并设置合理深度 | 当前 HOME 与仓库均无生效配置，旧 cache 仅为不可执行的索引数据 |
| `~/.config/dgop/colors.json` 及 Neovim 的 DMS colors/lualine 文件也是运行时配色，不是稳定手写配置 | 保留在各自 HOME/独立 Neovim 仓库并明确不纳管；不要为了“仓库无残留”删除仍在使用的生成态 | `dgop` 是当前 `dms-shell-git` 依赖；Neovim 保持独立仓库边界，当前未生成这两个文件 |
| xwaylandvideobridge 未安装，Niri/Hyprland 却保留隐藏窗口规则 | 删除孤儿规则；原生 portal 屏幕共享走 Niri/Hyprland backend | 配置 validator 通过；真实屏幕共享需会话内验证 |
| Pot 截图翻译未创建缓存目录，curl 失败也无提示 | 两个合成器都先建 XDG cache，再使用 `curl --fail --silent --show-error` | 配置解析通过；Pot 60828 服务仍属可选运行时依赖 |
| 仓库包含大壁纸、视频、数十个未使用 shader 和预览图 | 保留当前实际使用的 `cursor_warp_hex.glsl`，移除其余资产 | 当前受管文件体积已显著下降 |
| SSH/GnuPG、Pulse、浏览器、应用 state 容易被误提交 | 强化 `.gitignore`，只链接 SSH/GnuPG 配置文件，加入只输出文件名的敏感信息审计 | `scripts/audit-secrets` 通过 |
| 全局 Git 姓名/邮箱直接跟踪会公开身份，并在公司或多身份机器产生错误作者信息 | 受管 `~/.gitconfig` 只 include 未跟踪的 `~/.config/git/local.conf`；提供占位模板，各机器自行设置身份 | 本机身份已迁到权限 `0600` 的 local 文件；敏感审计不再让真实邮箱进入暂存快照 |
| Git ignore 只能阻止提交，仓库目录里仍遗留 cookie、日志、tmux 插件、旧系统快照和重复 Neovim clone | 在确认 HOME 运行时副本已保留后，将 11 MiB ignored 遗留移动到本次 XDG state 备份的 `repo-ignored-state/` | `git clean -ndX` 当前无候选，HOME 中 Fish/Fcitx/Pulse/tmux 等状态仍存在 |
| VLC `vlcrc` 是带 BOM 的 64 KiB、跨版本自动生成模板，真正自定义只有 3 项 | 收缩为 `[qt]`/`[core]` 的最小配置，避免迁移旧版本全部默认值 | 当前 VLC `-H` 确认三个选项仍受支持；真实 GUI 行为待人工检查 |
| 通用 Electron flags 同时设置 `ozone-platform-hint=auto` 与 `ozone-platform=wayland`，并重复声明 feature switch | 收敛为单一 native Wayland 策略；QQ 保留独立 scale 1.0，Typora 保留 auto hint | 参数静态去重通过；QQ/Typora 需在新会话人工启动验收 |
| Yazi `theme.toml` 引用不存在的 `Catppuccin-mocha.tmTheme`，且是 36 KiB 自动导出的整套图标规则 | 暂不纳管该缺陷文件；先用 Yazi 官方 flavor/完整 theme asset 重建，再加入 desktop manifest | 当前 Yazi 仍可使用内置 fallback；迁移不会宣称复现该主题 |

## 仍需人工决策或运行时验收

| 项目 | 当前状态 | 建议解决办法 |
| --- | --- | --- |
| DMS provider | 安装的是 `dms-shell-git`，`dms.service` 已 enable 但当前 inactive；会话中有旧式 `dms run` 进程 | 下次维护窗口将 git/debug 包与 `dms-shell + dms-shell-niri + dms-shell-hyprland` 同一事务替换，重新登录后确认 user service active |
| 当前会话环境 | Niri 进程仍继承旧 `GRIM_DEFAULT_DIR=/home/celeb/tmp`；配置 reload 不会重导入 login 环境 | 注销并重新进入 Niri 后检查 `systemctl --user show-environment`；显式 DMS 截图目录已立即生效，grim/grimblast 默认值要等新会话 |
| 包可复现性 | `uv` 在 Cargo 目录、`grimblast` 在 `/usr/local/bin`，都无 pacman 归属 | 安装清单对应包，或明确记录并固定另一种安装来源；`scripts/check-deps` 在解决前会返回 1 |
| Niri 非 xray blur | 浮动窗口使用实验性真实 blur；validator 只证明语法 | 若再次出现 `GL_INVALID_VALUE` 或渲染异常，先在 `window-rules.kdl` 的浮动规则中禁用 blur 做 A/B 对照 |
| Hyprland Alt-Tab | Lua 与脚本语法通过，但当前会话是 Niri，未实际走完整 foot/fzf/Hyprland dispatch 链路 | 进入 Hyprland 后测试 Alt+Tab、取消和选中；失败时按 `enable.sh -> alttab.sh -> disable.sh` 顺序查日志 |
| tmux 扩展按键 | 新配置的 server 解析通过，当前长期运行的 tmux server 尚未重载 | 执行 `tmux source-file ~/.config/tmux/tmux.conf`，再实际测试终端 → tmux → Neovim；静态检查不能模拟物理按键 |
| Qt/GTK/Fcitx 外观 | 配置文件可解析，未逐个启动 GUI，避免应用自动重写配置 | 重新登录后打开 qt6ct、Qt 6 应用、GTK 3/4 应用和 Fcitx 配置器做目视检查；如 GUI 重写绝对路径，只提交 palette，不提交窗口状态 |
| Pot 翻译 | `Mod+C` 仍依赖本地 Pot HTTP 服务 `127.0.0.1:60828` | 不使用就删除绑定；使用则安装 Pot、启用 OCR 服务并做一次真实截图测试 |
| Neovim | 独立仓库，当前 live 分支为 `macos` 且有修改过的 `nvim.log` | 迁移前确认分支；日志不要提交，Neovim 仓库单独 clone/pull |
| Vim | 本机另有 `~/.vimrc` 和 Catppuccin colorscheme，但主编辑器是独立 Neovim 仓库 | 本次不把旧 Vim 兼容配置并入 core；若另一台机器需要 Vim，先精简 `.vimrc` 再作为 optional profile 纳管 |
| WeChat 用户 launcher | `~/.local/share/applications/com.qq.weixin.desktop` 由 portable 包生成且硬编码 `/home/celeb`，当前机器可用但不可直接复制 | 不纳管该生成文件；新机安装 `wechat`/`wechat-bin` 后让包装器重新生成，或按新机 HOME 重建，切勿原样迁移 |
| Git 历史体积 | 大资产已从工作树删除，但旧提交对象仍保留 | 先正常提交；若确需缩小 clone，再在完整备份后单独使用新 root/filter-repo，并通过 `--force-with-lease` 协调远端历史重写 |
| 多 Git 身份 | 全局 local 文件适合个人默认身份，但工作仓库可能要求公司账号 | 为工作目录增加 `includeIf "gitdir:~/path/to/work/"` 指向另一未跟踪文件，并用 `git config --show-origin --get user.email` 在提交前确认 |
| 远端状态 | 本次只整理本地工作树，没有替用户 commit 或 push | 审阅 `git diff --stat` 和敏感审计后自行提交、推送；远端迁移能力要在另一台机器 clone 后才算最终验证 |
| 旧 host overlay 会把 DP-4/NVIDIA 设置带到新机器 | 安装器只识别并备份指向本仓库 `hosts/*` 的旧受管软链；`--no-host` 因此能安全清除旧主机层 | 用户自建 local 文件不受影响；host 切换与 no-host 都有隔离测试 |
