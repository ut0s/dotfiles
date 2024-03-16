# load alias & function
source ~/.config/fish/alias.fish
source ~/.config/fish/myfunc.fish

# load my functions
set -a fish_function_path ~/.config/fish/my_functions

# load env
source ~/.config/fish/env.fish

# load completion
source ~/.config/fish/completions.fish

# load bobthefish config
source ~/.config/fish/bobthe.fish

set_ssh_theme

# Start tmux only in an initial interactive shell attached to a terminal.
if status is-interactive; and isatty stdin; and not set -q TMUX; and test "$SHLVL" -eq 1
    tmux
end
