# alias & function 読み込み
source ~/.config/fish/alias.fish
source ~/.config/fish/myfunc.fish

# 環境変数 読み込み
source ~/.config/fish/env.fish

# bobthefish
source ~/.config/fish/bobthe.fish

# execute tmux only initial shell
if [ $SHLVL -eq 1 ]
  tmux
end
