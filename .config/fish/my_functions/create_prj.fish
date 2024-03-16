function create_prj --description 'Create a project with git and mise.toml'
    argparse h/help m/mise-only -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: create_prj [PROJECT_NAME] [TMUX_WINDOW_NAME]"
        echo "       create_prj --mise-only [TMUX_WINDOW_NAME]"
        echo ""
        echo "Options:"
        echo "  -m, --mise-only  Only create mise.toml in the current directory (for existing repositories)"
        echo "  -h, --help       Show this help"
        echo ""
        echo "Missing arguments are prompted interactively."
        return 0
    end

    if set -q _flag_mise_only
        if test (count $argv) -gt 1
            echo "Error: Too many arguments. See 'create_prj --help'."
            return 1
        end
        if test -e mise.toml
            echo "Error: mise.toml already exists in "(pwd)". Exiting."
            return 1
        end
    else if test (count $argv) -gt 2
        echo "Error: Too many arguments. See 'create_prj --help'."
        return 1
    end

    # In mise-only mode, the current directory is the project and the only argument is the Tmux window name
    set -l PRJ_NAME
    set -l TMUX_WIN_NAME
    if set -q _flag_mise_only
        set PRJ_NAME (basename (pwd))
        set TMUX_WIN_NAME $argv[1]
    else
        set PRJ_NAME $argv[1]
        set TMUX_WIN_NAME $argv[2]
    end

    # Prompt for missing project name and Tmux window name
    if test -z "$PRJ_NAME"
        read -l -p 'set_color green; echo -n "Enter project name: "; set_color normal' input
        set PRJ_NAME $input
    end
    if test -z "$PRJ_NAME"
        echo "Error: Project name is empty. Exiting."
        return 1
    end

    if test -z "$TMUX_WIN_NAME"
        read -l -p 'set_color green; echo -n "Enter Tmux Window name: "; set_color normal' input
        set TMUX_WIN_NAME $input
    end
    if test -z "$TMUX_WIN_NAME"
        echo "Error: Tmux Window name is empty. Exiting."
        return 1
    end

    if not set -q _flag_mise_only
        # Create and navigate to the project directory
        mkdir -p $PRJ_NAME
        cd $PRJ_NAME

        # STEP 1: Initialize Git repository
        git init

        # STEP 2: Create an empty initial commit
        git commit --allow-empty -m "add: empty initial commit"
    end

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

PROJECT_DIR="$(pwd -P)"
# Target the pane running this task, not the active pane of the client,
# so switching windows/panes during startup does not misdirect commands
ORIGINAL_PANE_ID="$TMUX_PANE"

# Rename the window that owns this pane
tmux rename-window -t "$ORIGINAL_PANE_ID" "$TMUX_WINDOW_TITLE"

# Start agy in the original pane (top)
tmux send-keys -t "$ORIGINAL_PANE_ID" "agy" C-m

# Split below the original pane without moving focus (-d)
tmux split-window -d -v -l 50% -t "$ORIGINAL_PANE_ID" -c "$PROJECT_DIR"
"""'

    echo "$mise_content" > mise.toml

    # Additional step: Run mise trust
    mise trust

    echo "----------------------------------------"
    if set -q _flag_mise_only
        echo "mise.toml creation and mise trust completed in '"(pwd)"'."
    else
        echo "Project '$PRJ_NAME' creation, initial commit, and mise trust completed."
    end
end
