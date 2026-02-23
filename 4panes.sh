#!/usr/bin/env bash
# 4panes.sh — Open a tmux session with one window split into 4 panes.
#
# USAGE:
#   ./4panes.sh [dir1] [dir2] [dir3] [dir4]
#
# Each pane opens in the corresponding directory.
# Any omitted directories default to: ~/helpful-tools-for-me/tmux-scripts
#
# ── COMMANDS ──────────────────────────────────────────────────────────────────
# Set a command for each pane below. Leave empty ("") to just open a shell.
#
# Examples:
#   CMD1="npm run dev"      → runs a dev server in pane 1
#   CMD1="htop"             → runs htop in pane 1
#   CMD1=""                 → just opens a shell prompt in pane 1

CMD1="pwd"   # Command to run in pane 1 (top-left)    — leave "" for plain shell
CMD2="pwd"   # Command to run in pane 2 (top-right)   — leave "" for plain shell
CMD3="pwd"   # Command to run in pane 3 (bottom-left)  — leave "" for plain shell
CMD4="pwd"   # Command to run in pane 4 (bottom-right) — leave "" for plain shell

# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail  # Exit on error (-e), treat unset vars as errors (-u), catch pipe failures (-o pipefail)

SESSION="4panes"                                   # Name of the tmux session
DEFAULT_DIR="/Users/chris/whatever"     # Fallback directory if none are given as arguments

DIR1="${1:-$DEFAULT_DIR}"  # Pane 1 directory — first arg, or default if not provided
DIR2="${2:-$DEFAULT_DIR}"  # Pane 2 directory — second arg, or default if not provided
DIR3="${3:-$DEFAULT_DIR}"  # Pane 3 directory — third arg, or default if not provided
DIR4="${4:-$DEFAULT_DIR}"  # Pane 4 directory — fourth arg, or default if not provided

# Validate that every directory actually exists before we start tmux
for dir in "$DIR1" "$DIR2" "$DIR3" "$DIR4"; do
    if [[ ! -d "$dir" ]]; then          # -d checks if the path is a real directory
        echo "Error: Not a directory: $dir"
        exit 1                           # Stop the script if any directory is missing
    fi
done

# Kill any existing tmux session with the same name so we start fresh
# The "|| true" prevents the script from failing if no session existed
tmux kill-session -t "$SESSION" 2>/dev/null || true

# Create a new detached (-d) tmux session; the first pane starts in DIR1
tmux new-session -d -s "$SESSION" -c "$DIR1"

# Layout we're building:
#  ┌──────────┬──────────┐
#  │  Pane 1  │  Pane 2  │
#  ├──────────┼──────────┤
#  │  Pane 3  │  Pane 4  │
#  └──────────┴──────────┘

# Split pane 0 vertically (-h = side by side) to create pane 1 on the right
tmux split-window -h -t "$SESSION:0.0" -c "$DIR2"

# Split pane 0 horizontally (-v = top/bottom) to create pane 2 (bottom-left)
tmux split-window -v -t "$SESSION:0.0" -c "$DIR3"

# Split pane 1 horizontally (-v) to create pane 3 (bottom-right)
tmux split-window -v -t "$SESSION:0.1" -c "$DIR4"

# Resize all panes to equal size using the "tiled" layout
tmux select-layout -t "$SESSION" tiled

# Helper function: sends a command to a pane only if the command string is non-empty
send_cmd() {
    local pane="$1"   # Which pane to target, e.g. "$SESSION:0.0"
    local cmd="$2"    # The command string to send
    if [[ -n "$cmd" ]]; then                           # -n means "non-empty string"
        tmux send-keys -t "$pane" "$cmd" Enter         # Types the command and presses Enter in that pane
    fi
}

# Send commands to each pane (does nothing if the CMD variable is empty)
send_cmd "$SESSION:0.0" "$CMD1"  # Pane 1 — top-left
send_cmd "$SESSION:0.2" "$CMD2"  # Pane 2 — top-right  (index shifts after splits)
send_cmd "$SESSION:0.3" "$CMD3"  # Pane 3 — bottom-left
send_cmd "$SESSION:0.1" "$CMD4"  # Pane 4 — bottom-right

# Move focus back to pane 1 (top-left) so that's where your cursor lands
tmux select-pane -t "$SESSION:0.0"

# Finally, attach to the session so it appears in your terminal
tmux attach-session -t "$SESSION"




# DIR1="${1:-~/awsprojects}"
# DIR2="${2:-~/scripts-for-me}" 
# DIR3="${3:-~/Documents}"
# DIR4="${4:-~}"  # Home directory