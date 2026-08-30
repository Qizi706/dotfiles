# Login shells define the user session environment. niri-session deliberately
# starts a login shell before importing the environment into systemd and D-Bus.
if status is-login
    source "$HOME/.config/shell/profile.fish"
end

# Prompt helpers belong only to interactive terminals; keeping them here
# prevents the graphical session and GUI applications from inheriting
# interactive-only state.
if status is-interactive
    type -q zoxide; and zoxide init fish | source
    type -q starship; and starship init fish | source
end
