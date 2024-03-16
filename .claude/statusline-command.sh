#!/bin/bash
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
window_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // empty')

# Git branch and status
git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$git_branch" ]; then
  git_status=$(git status --porcelain 2>/dev/null)
  if [ -n "$git_status" ]; then
    git_dirty="\033[0;33m*\033[00m"
  else
    git_dirty=""
  fi
  printf "\033[0;36m%s\033[00m%b" "$git_branch" "$git_dirty"
fi

# Model name
if [ -n "$model" ]; then
  if [ -n "$git_branch" ]; then
    printf " \033[0;90m│\033[00m "
  fi
  printf "%s" "$model"
fi

# Context usage: "Context: 11% (22K/200K) │ Remaining: 178K"
if [ -n "$used_pct" ] && [ -n "$window_size" ] && [ -n "$input_tokens" ]; then
  used_k=$(echo "$input_tokens" | awk '{printf "%.0f", $1/1000}')
  total_k=$(echo "$window_size" | awk '{printf "%.0f", $1/1000}')
  remaining_k=$(echo "$input_tokens $window_size" | awk '{printf "%.0f", ($2-$1)/1000}')
  pct_int=$(echo "$used_pct" | awk '{printf "%.0f", $1}')
  if [ "$pct_int" -ge 80 ]; then
    ctx_color="\033[0;31m"   # red
  elif [ "$pct_int" -ge 50 ]; then
    ctx_color="\033[0;33m"   # yellow
  else
    ctx_color="\033[0;32m"   # green
  fi
  printf " \033[0;90m│\033[00m Context: ${ctx_color}%.0f%% (%sK/%sK)\033[00m \033[0;90m│\033[00m Remaining: %sK" \
    "$used_pct" "$used_k" "$total_k" "$remaining_k"
fi
