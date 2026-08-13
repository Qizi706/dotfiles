# Login shells define the user session environment. niri-session deliberately
# starts a login shell before importing the environment into systemd and D-Bus.
if status is-login
    source "$HOME/.config/shell/profile.fish"
end

# Prompt helpers and Conda belong only to interactive terminals; keeping them
# here prevents the graphical session and GUI applications from inheriting a
# Conda-modified PATH.
if status is-interactive
    type -q zoxide; and zoxide init fish | source
    type -q starship; and starship init fish | source

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    if test -f /home/celeb/Programming/miniconda3/bin/conda
        eval /home/celeb/Programming/miniconda3/bin/conda "shell.fish" "hook" $argv | source
    else if test -f /home/celeb/Programming/miniconda3/etc/fish/conf.d/conda.fish
        source /home/celeb/Programming/miniconda3/etc/fish/conf.d/conda.fish
    else
        fish_add_path --global --prepend /home/celeb/Programming/miniconda3/bin
    end
    # <<< conda initialize <<<
end
