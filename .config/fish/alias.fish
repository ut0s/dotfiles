# User specific aliases
alias rm="rm -iv" # interactive
alias mv="mv -iv" # interavtive
alias scp="scp -Cpr" # compress, preserve

# some more ls aliases
switch (uname)
  case Darwin
    alias cp="cp -iv" # interactive, preserve timestamp

    alias ll='gls -alFh --color=auto'
    alias la='gls -Ah --color=auto'
    alias l='gls -CFh --color=auto'
    alias sl='gls -CFh --color=auto'

    abbr -a google-chrome "open /Applications/Google\ Chrome.app"
  case '*'
    alias cp="cp -iv --preserve=timestamps" # interactive, preserve timestamp

    alias ll='ls -alFh --color=auto'
    alias la='ls -Ah --color=auto'
    alias l='ls -CFh --color=auto'
    alias sl='ls -CFh --color=auto'

    # some more aliases
    alias install='sudo apt install'
    alias reinstall='sudo apt-get install --reinstall'
    alias finstall='sudo apt -f install'
    alias update='sudo apt update'
    # alias upgrade='sudo apt dist-upgrade'
    # alias dupgrade='sudo apt update && sudo apt dist-upgrade'
    alias remove='sudo apt-get remove'
    alias autoremove='sudo apt-get autoremove'
    alias purge='sudo apt-get remove --purge'
    alias search='apt-cache search'
    alias clean='sudo apt-get clean'
    alias autoclean='sudo apt-get autoclean'

    alias xclip="xclip -selection CLIPBOARD"
end


# color output
alias less="less -R"
which bat && alias cat=bat

# move aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd-='cd -'

# grep color
alias grep='grep --color'

# clear
alias c=clear

# Disk size
alias df='df -hT'

# git
alias g='git'
alias gs='git status'
alias gis='git status'
alias gits='git status'
alias pull='git pull'
alias push='git push'

alias dots='cd ~/dotfiles'
alias dotfiles='cd ~/dotfiles'

alias ttmux='tmux new-session -A -s Default'
which trahs-put && alias rm='trash-put'
alias rng='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

alias yarn='pnpm'
alias npm='pnpm'
