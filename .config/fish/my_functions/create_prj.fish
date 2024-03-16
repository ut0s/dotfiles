function create_prj
    # Prompt for project name and Tmux window name
    read -l -p 'set_color green; echo -n "Enter project name: "; set_color normal' PRJ_NAME
    if test -z "$PRJ_NAME"
        echo "Error: Project name is empty. Exiting."
        return 1
    end

    read -l -p 'set_color green; echo -n "Enter Tmux Window name: "; set_color normal' TMUX_WIN_NAME
    if test -z "$TMUX_WIN_NAME"
        echo "Error: Tmux Window name is empty. Exiting."
        return 1
    end

    # Create and navigate to the project directory
    mkdir -p $PRJ_NAME
    cd $PRJ_NAME

    # STEP 1: Initialize Git repository
    git init

    # STEP 2: Create an empty initial commit
    git commit --allow-empty -m "add: empty initial commit"

    # STEP 3 & 4: Create mise.toml and set TMUX_WINDOW_TITLE
    set -l mise_content '[env]
TMUX_WINDOW_TITLE = "'$TMUX_WIN_NAME'"

[tasks.tmux]
description = "Rename the current window, split panes, and execute development commands"
run = """
#!/bin/bash

# Ensure this command is run within a TMux session
if [ -z "$TMUX" ]; then
  echo "Error: This command must be run inside a TMux session."
  exit 1
fi

# Rename the current window
tmux rename-window "$TMUX_WINDOW_TITLE"

# Start the frontend development server in the current pane (left)
tmux send-keys "agy" C-m

# Split the right pane vertically (bottom right) and start the local LLM
tmux split-window -v -p 50

# Return focus to the original left pane
tmux select-pane -L
"""'

    echo "$mise_content" > mise.toml

    # Additional step: Run mise trust
    mise trust

    echo "----------------------------------------"
    echo "Project '$PRJ_NAME' creation, initial commit, and mise trust completed."
end
