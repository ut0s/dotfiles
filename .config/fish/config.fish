# load alias & function
source ~/.config/fish/alias.fish
source ~/.config/fish/myfunc.fish

# load env
source ~/.config/fish/env.fish

# load completion
source ~/.config/fish/completions.fish

# load bobthefish config
source ~/.config/fish/bobthe.fish

set_ssh_theme

# execute tmux only initial shell
if [ $SHLVL -eq 1 ]
  tmux
end
