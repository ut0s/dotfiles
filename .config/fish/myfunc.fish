# User specific functions

function fish_user_key_bindings
  # fzf
  bind \cx\cf '__fzf_find_file'
  bind \cr '__fzf_reverse_isearch'
  # bind \ex '__fzf_find_and_execute'
  bind \ed '__fzf_cd'
  bind \eD '__fzf_cd --hidden'

  # select repos by fzf
  # bind \cg\cg fzf_select_repo_and_attach

  # kill process selected by fzf
  # bind \cx\ck fzf_kill

  # move recent directory
  bind \cx\cr fzf_recentd

  # git add & diff preview by fzf
  # bind \cg\ca fzf_git_add_and_diff

  # git diff by fzf
  # bind \cg\cd fzf_git_diff

  # git diff & preview after added by fzf
  # bind \cg\ce fzf_git_diff_cached

  # git diff & preview after added by fzf
  # bind \ct\ct fzf_select_tmux_session

  # git diff & preview after added by fzf
  # bind \cc\co fzf_parse_url_and_open
end


# function fzf_select_repo_and_attach
#   eval $HOME/dotfiles/bin/fzf_select_repo_and_attach.sh
#   commandline -f repaint
# end

# function fzf_kill
#   ps ax -o pid,time,command | fzf --query "$LBUFFER" | awk '{print $1}' | xargs kill
# end

function fzf_recentd
  # z --list --recent | fzf $FZF_CD_OPTS | awk '{print $2}' | read recentd #evalでないと動かない
  z --list --recent | eval "fzf $FZF_DEFAULT_OPTS --preview 'tree -C {2}| head -200'" | awk '{print $2}' | read recentd
  cd $recentd
  commandline -f repaint
end

function fzf_git_add_and_diff
  eval $HOME/dotfiles/bin/fzf_git_add8diff.sh
  commandline -f repaint
end

function fzf_git_diff
  git status --short | fzf --multi --preview 'git diff {2} | pygmentize -f terminal256 -O style=native -g'
  commandline -f repaint
end

function fzf_git_diff_cached
  eval $HOME/dotfiles/bin/fzf_git_diff_cached.sh
  commandline -f repaint
end

function fzf_select_tmux_session
  eval $HOME/dotfiles/bin/fzf_select_tmux_session.sh
  commandline -f repaint
end

function fzf_parse_url_and_open
  eval $HOME/dotfiles/bin/fzf_parse_url8open.sh
  commandline -f repaint
end


function pip-upgrade-all
  if test -n '$VIRTUAL_ENV'
  echo "pip upgrade all in VIRTUAL_ENV:" $VIRTUAL_ENV
  pip freeze --user | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U --user
  else
  echo "pip upgrade all in local"
  pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install --user -U
  end
end


# Defined in /usr/local/share/fish/functions/cd.fish @ line 4
function cd --description 'Change directory'
  set -l MAX_DIR_HIST 25

  if test (count $argv) -gt 1
    printf "%s\n" (_ "Too many args for cd command")
    return 1
  end

  # Skip history in subshells.
  if status --is-command-substitution
    builtin cd $argv
    ls -la
    return $status
  end

  # Avoid set completions.
  set -l previous $PWD

  if test "$argv" = "-"
    if test "$__fish_cd_direction" = "next"
      nextd
    else
      prevd
    end
    ls -la
    return $status
  end

  builtin cd $argv
  set -l cd_status $status

  if test $cd_status -eq 0 -a "$PWD" != "$previous"
    set -q dirprev[$MAX_DIR_HIST]
    and set -e dirprev[1]
    set -g dirprev $dirprev $previous
    set -e dirnext
    set -g __fish_cd_direction prev
  end

  ls -la
  return $cd_status
end


function pynote;
  cd $HOME/git/jupyter_notebook;
  source note_env/bin/activate.fish;

  if test -d ./data
     mkdir data
  end

  if test -n '$VIRTUAL_ENV'
  echo "in VIRTUAL_ENV:" $VIRTUAL_ENV "Jupyter Notebook Process Start"
  jupyter-notebook;
  end
end


function pylab;
  cd $HOME/git/jupyter_notebook;
  source note_env/bin/activate.fish;

  if test -d ./data
     mkdir data
  end

  if test -n '$VIRTUAL_ENV'
  echo "in VIRTUAL_ENV:" $VIRTUAL_ENV "Jupyter Lab Process Start"
  jupyter lab;
  end
end

function virtualenv_requiements_update;
   if test -n '$VIRTUAL_ENV' -a -f requiements.txt
      pip freeze >requiements.txt
      git status |grep requiements.txt
      if test $status -eq 0
        git add requiements.txt note_env
        git commit -m "Update requiements.txt"
      end
  else
      echo "not in virtualenv"
  end
end

function set_ssh_theme;
    if test -n '$SSH_CONNECTION' -a -n '$SSH_CLIENT' -a -n '$SSH_TTY'
       echo -n $SSH_CONNECTION
       # set theme_color_scheme solarized-light
       # set theme_color_scheme light
    else
       echo "NOT SSH CONECTION"
    end
end

function dia;
  emacsclient ~/til/(date +%y%m)/log(date +%y%m%d).org &
end

function uma;
  man -C $HOME/usr/local/share/man $argv
end

function ec;
  emacsclient $argv &
end

# vterm configuration
function vterm_printf;
    if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end
        # tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
    else if string match -q -- "screen*" "$TERM"
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$argv"
    else
        printf "\e]%s\e\\" "$argv"
    end
end
