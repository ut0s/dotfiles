# User specific aliases
alias rm="rm -iv" # interactive
alias cp="cp -iv --preserve=timestamps" # interactive, preserve timestamp
alias mv="mv -iv" # interavtive
alias scp="scp -Cpr" # compress, preserve

# some more ls aliases
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

# color output
alias less="less -R"
alias pcat='pygmentize -O style=native -f console256 -g'

# move aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd-='cd -'

# grep color
# grep -r hogeで./以下のファイルの中身からhogeを検索
alias grep='grep --color'

# clear
alias c=clear

# Disk size
alias df='df -hT'

# git
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gd='git diff'
alias gs='git status'
alias gst='git status'
alias gis='git status'
alias gits='git status'
alias gco='git checkout'
alias gf='git fetch'
alias gc='git commit'
alias pull='git pull'
alias push='git push'

# dotfiles
alias dots='cd ~/dotfiles'
alias dotfiles='cd ~/dotfiles'

# tmux
alias ttmux='tmux new-session -A -s Default'

alias rm='trash-put'

alias dia='emacsclient ~/til/(date +%y%m)/log(date +%y%m%d).org &'

abbr -a rng ranger

abbr -a ggg "googler --noua"
