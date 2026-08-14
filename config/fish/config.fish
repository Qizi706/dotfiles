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

    set -l conda_executable (command -s conda)
    if test -z "$conda_executable"; and test -x "$HOME/Programming/miniconda3/bin/conda"
        set conda_executable "$HOME/Programming/miniconda3/bin/conda"
    end

    if test -n "$conda_executable"
        "$conda_executable" shell.fish hook $argv | source
    else if test -f "$HOME/Programming/miniconda3/etc/fish/conf.d/conda.fish"
        source "$HOME/Programming/miniconda3/etc/fish/conf.d/conda.fish"
    end
end
