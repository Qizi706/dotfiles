source $HOME/.config/shell/profile.fish

if status is-interactive
    # Commands to run in interactive sessions can go here
end

zoxide init fish | source
starship init fish | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/celeb/Programming/miniconda3/bin/conda
    eval /home/celeb/Programming/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/celeb/Programming/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/celeb/Programming/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/celeb/Programming/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

