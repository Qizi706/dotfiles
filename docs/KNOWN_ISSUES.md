# 尚未解决的问题

这里只保留当前仍需修改、人工决策或运行时验收的项目。已完成且通过静态验证的修复不再保留。

| 项目 | 当前证据 | 建议解决办法 |
| --- | --- | --- |
| Niri 非 xray blur | 浮动窗口仍使用实验性的真实 blur；`niri validate` 只能证明语法，不能证明 GPU 运行稳定 | 继续使用时观察渲染；若出现 `GL_INVALID_VALUE` 或画面异常，先禁用浮动规则中的 blur 做 A/B 对照，稳定后再删除本条 |
| DMS 截图与 Hyprland Overview | 截图绑定只调用 `dms screenshot`，`Alt+Tab` 只调用 DMS Overview；但当前会话是 Niri，尚未在 Hyprland 实测 | 进入 Hyprland 后测试区域/全屏/窗口截图、保存目录，以及 Overview 的打开、导航、切换和退出 |
| 当前修改与远端历史尚未发布 | 本地 `main` 已重写并将 pack 从约 64.5 MiB 降到 1.7 MiB，但工作树仍未提交；本地已删除旧 `origin/main` 跟踪引用，本地最后记录的远端提交是重写前的 `4123fe4` | 审阅 diff 和敏感审计后提交；重新读取并确认远端 SHA，再以该旧 SHA 作为显式 lease 推送重写后的 `main`，最后从另一目录重新 clone 验收 |
