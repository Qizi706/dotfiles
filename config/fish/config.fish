function fish_preexec
    # $argv[1] 是将要执行的命令
    set -l command $argv[1]

    # ----------------------------------------------------
    # 1. 定义您要忽略的命令列表
    # ----------------------------------------------------
    set -l ignore_list cd "cd -" "cd .." pwd ls l ll la exit clear history

    # ----------------------------------------------------
    # 2. 检查命令是否在忽略列表中
    # ----------------------------------------------------

    # 提取命令的第一个单词（即主命令）
    set -l main_command (string split " " $command)[1]

    # 使用 contains 函数检查主命令是否在忽略列表中
    if contains $main_command $ignore_list
        # 如果在列表中，设置特殊变量阻止命令被写入历史文件
        set -g __fish_disable_cmd_save 1
    end
end

source $HOME/.config/shell/profile.fish

if status is-interactive
    # Commands to run in interactive sessions can go here
end

zoxide init fish | source
starship init fish | source
