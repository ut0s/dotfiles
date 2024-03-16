# User specific aliases
alias mv="mv -iv" # interactive
alias scp="scp -Cpr" # compress, preserve

if command -q trash-put
    alias rm="trash-put"
else
    alias rm="rm -iv" # interactive
end

# some more ls aliases
switch (uname)
    case Darwin
        alias cp="cp -iv" # interactive, preserve timestamp

        if command -q gls
            alias ll="gls -alFh --color=auto"
            alias la="gls -Ah --color=auto"
            alias l="gls -CFh --color=auto"
            alias sl="gls -CFh --color=auto"
        else
            alias ll="ls -alFGh"
            alias la="ls -AGh"
            alias l="ls -CFGh"
            alias sl="ls -CFGh"
        end

        abbr -a google-chrome "open /Applications/Google\\ Chrome.app"
    case '*'
        alias cp="cp -iv --preserve=timestamps" # interactive, preserve timestamp

        alias ll="ls -alFh --color=auto"
        alias la="ls -Ah --color=auto"
        alias l="ls -CFh --color=auto"
        alias sl="ls -CFh --color=auto"

        # some more aliases
        alias install="sudo apt install"
        alias reinstall="sudo apt-get install --reinstall"
        alias finstall="sudo apt -f install"
        alias update="sudo apt update"
        # alias upgrade="sudo apt dist-upgrade"
        # alias dupgrade="sudo apt update && sudo apt dist-upgrade"
        alias remove="sudo apt-get remove"
        alias autoremove="sudo apt-get autoremove"
        alias purge="sudo apt-get remove --purge"
        alias search="apt-cache search"
        alias clean="sudo apt-get clean"
        alias autoclean="sudo apt-get autoclean"

        alias xclip="xclip -selection CLIPBOARD"
end

# color output
alias less="less -R"
if command -q bat
    alias cat="bat"
end

# move abbreviations
abbr -a .. "cd .."
abbr -a ... "cd ../.."
abbr -a .... "cd ../../.."
abbr -a cd- "cd -"

# grep color
alias grep="grep --color"

# clear
abbr -a c clear

# Disk size
switch (uname)
    case Darwin
        alias df="df -h"
    case '*'
        alias df="df -hT"
end

# git
abbr -a g git
abbr -a gs "git status"
abbr -a gis "git status"
abbr -a gits "git status"
abbr -a pull "git pull"
abbr -a push "git push"

function cdr --description "Change directory to the git repository root"
    builtin cd (git rev-parse --show-toplevel)
end

function cdrr --description "Change directory to the git common directory root"
    builtin cd (git rev-parse --git-common-dir)/..
end

function dots --description "Change directory to ~/dotfiles"
    builtin cd ~/dotfiles
end

function dotfiles --description "Change directory to ~/dotfiles"
    builtin cd ~/dotfiles
end

alias ttmux="tmux new-session -A -s Default"

function rng --description "Open ranger and change to the selected directory"
    set -l lastdir_file "$HOME/.rangerdir"
    command ranger --choosedir="$lastdir_file" $argv

    if test -f "$lastdir_file"
        set -l lastdir (string trim -- (cat "$lastdir_file"))
        if test -n "$lastdir"
            builtin cd "$lastdir"
        end
    end
end

abbr -a yarn pnpm
abbr -a npm pnpm
