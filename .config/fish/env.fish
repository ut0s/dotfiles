# path setting
set -gx fish_user_paths $HOME/bin $fish_user_paths
set -gx fish_user_paths $HOME/.local/bin $fish_user_paths
set -gx fish_user_paths $HOME/.cargo/bin $fish_user_paths
set -gx fish_user_paths $HOME/usr/bin $fish_user_paths
set -gx fish_user_paths $HOME/usr/local/bin $fish_user_paths

set -gx LD_LIBRARY_PATH /usr/local/lib/ $LD_LIBRARY_PATH
set -gx LD_LIBRARY_PATH $HOME/usr/lib $LD_LIBRARY_PATH

#set PKG_CONFIG_PATH
set -gx  PKG_CONFIG_PATH /usr/local/lib/pkgconfig/ $PKG_CONFIG_PATH


#重複履歴を無視
set HISTCONTROL ignoreboth

#全履歴に渡り重複コマンドを削除します
set HISTCONTROL erasedups

# append to the history file, don't overwrite it
# shopt -s histappend


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

set -gx EDITOR "emacs -nw --no-desktop"
set -gx VIEWER less

# make cap lock additional ctrl.
# setxkbmap -option ctrl:nocapsexport PATH="$HOME/.rbenv/bin:$PATH"

#for virtualenv
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1 $VIRTUAL_ENV_DISABLE_PROMPT

# for go lang
set -gx GOPATH $HOME/.go
set -gx PATH $HOME/.go/bin $PATH
set -gx PATH $HOME/usr/local/go/bin $PATH

# for rust lang
set -gx CARGO_HOME $HOME/.cargo
set -gx PATH $HOME/.cargo/bin $PATH
set -gx CARGO_TARGET_DIR $HOME/usr

# for fzy
set -gx $FZY_LIST_NUM 10
