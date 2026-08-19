function fish_should_add_to_history --description "Filter trivial commands from Fish history"
    set -l commandline "$argv[1]"

    # Preserve Fish's default convention: a leading space keeps a command out
    # of history, which is also useful for one-off sensitive commands.
    if string match --quiet --regex '^[[:space:]]' -- "$commandline"
        return 1
    end

    set commandline (string trim -- "$commandline")
    set -l main_command (string match --regex '^[^[:space:]]+' -- "$commandline")
    set -l ignored_commands cd pwd ls l ll la exit clear history

    if contains -- "$main_command" $ignored_commands
        return 1
    end

    return 0
end
