# load alias & function
source ~/.config/fish/alias.fish
source ~/.config/fish/myfunc.fish

# load env
source ~/.config/fish/env.fish

# load bobthefish confit
source ~/.config/fish/bobthe.fish

set_ssh_theme

# execute tmux only initial shell
if [ $SHLVL -eq 1 ]
  tmux
end
