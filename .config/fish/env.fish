# path setting
set -gx fish_user_paths /usr/local/cuda/bin $fish_user_paths
set -gx fish_user_paths $HOME/bin $fish_user_paths
set -gx fish_user_paths $HOME/.local/bin $fish_user_paths
set -gx fish_user_paths $HOME/usr/bin $fish_user_paths
set -gx fish_user_paths $HOME/usr/local/bin $fish_user_paths
set -gx fish_user_paths $HOME/.cargo/bin $fish_user_paths

switch (uname)
  case Darwin
    set -gx fish_user_paths $HOME/Library/Python/3.9/bin $fish_user_paths
    set -gx fish_user_paths /opt/homebrew/bin $fish_user_paths
    set -gx fish_user_paths /opt/homebrew/sbin $fish_user_paths
    set -gx fish_user_paths /usr/local/bin $fish_user_paths
    set -gx fish_user_paths /usr/local/go/bin $fish_user_paths
  case '*'
    echo ""
end

set -gx LD_LIBRARY_PATH /usr/local/lib/ $LD_LIBRARY_PATH
set -gx LD_LIBRARY_PATH /usr/local/Aria/lib/ $LD_LIBRARY_PATH
set -gx LD_LIBRARY_PATH /usr/local/cuda/lib64/ $LD_LIBRARY_PATH
set -gx LD_LIBRARY_PATH $HOME/usr/lib $LD_LIBRARY_PATH

#set PKG_CONFIG_PATH
set -gx  PKG_CONFIG_PATH /usr/local/lib/pkgconfig/ $PKG_CONFIG_PATH


set HISTCONTROL ignoreboth
set HISTCONTROL erasedups

# append to the history file, don't overwrite it
# shopt -s histappend


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

set -gx EDITOR "nano"
set -gx VIEWER less
# set -gx BROWSER "w3m"
set -gx PAGER "less"

# make cap lock additional ctrl.
# setxkbmap -option ctrl:nocapsexport PATH="$HOME/.rbenv/bin:$PATH"

#for virtualenv
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1 $VIRTUAL_ENV_DISABLE_PROMPT

# for go lang
set -gx GOPATH $HOME/.go
set -gx PATH $HOME/.go/bin $PATH
set -gx PATH $HOME/usr/local/go/bin $PATH

# for fzf
set -gx FZF_DEFAULT_OPTS "--ansi --exit-0 --multi --reverse --cycle --extended --no-mouse --height 60% --border"
set -gx FZF_FIND_FILE_OPTS "--preview 'head -100 {} | pygmentize -f terminal256 -O style=native -g'"
set -gx FZF_CD_OPTS "--preview 'tree -C {} | head -100'"

# direnv
eval (direnv hook fish)
