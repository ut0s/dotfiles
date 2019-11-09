# User specific functions
function fish_user_key_bindings
  # fzy
  bind \cx\cf fzy_find_file
  bind \cr fzy_reverse_isearch
  bind \cx\cr fzy_recentd

end


function fzy_find_file
  find . | fzy | read file
  emacsclient $file &
end

function fzy_reverse_isearch
  history | fzy -l $FZY_LIST_NUM | read recen_cmd
  cd $recent_cmd
  commandline -f repaint    
end

# move recent directory
function fzy_recentd
  z --list --recent | fzy | read recentd
  cd $recentd
  commandline -f repaint
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

function dia;
  emacsclient ~/til/(date +%y%m)/log(date +%y%m%d).org &
end
