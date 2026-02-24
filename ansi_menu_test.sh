#!/usr/bin/env bash
# ansi_menu_template.sh
# Demonstrates drawing a PNG (from a pre-rendered ANSI file) and overlaying an interactive menu

# -----------------------------
# Configuration
# -----------------------------
PNG_ANSI_FILE="$HOME/test.ansi"   # Your pre-rendered PNG as ANSI
MENU_ROW=10                       # Row to place menu text
MENU_COL=20                       # Column to start menu

# -----------------------------
# Helper: Move cursor to row,column
# -----------------------------
cursor_to() {
    local row=$1
    local col=$2
    printf '\e[%d;%dH' "$row" "$col"
}

# -----------------------------
# Setup terminal
# -----------------------------
printf '\e[2J'      # Clear screen
printf '\e[H'       # Move cursor to home
printf '\e[?25l'    # Hide cursor

# -----------------------------
# Draw PNG / ANSI background
# -----------------------------
if [[ -f "$PNG_ANSI_FILE" ]]; then
    cat "$PNG_ANSI_FILE"
else
    echo "ANSI file not found: $PNG_ANSI_FILE"
fi

# -----------------------------
# Draw menu overlay
# -----------------------------
cursor_to "$MENU_ROW" "$MENU_COL"
printf '\e[1;38;2;255;255;0m%s\e[0m' "Welcome to the menu!"  # Yellow bold text

cursor_to $((MENU_ROW+1)) "$MENU_COL"
printf '\e[38;2;0;255;255m%s\e[0m' "Enter your name: "       # Cyan text

# -----------------------------
# Read user input at menu position
# -----------------------------
cursor_to $((MENU_ROW+1)) $((MENU_COL + 17))   # Move cursor to input field
read -r name

# -----------------------------
# Display response below input
# -----------------------------
cursor_to $((MENU_ROW+2)) "$MENU_COL"
printf '\e[38;2;0;255;0mHello, %s!\e[0m\n' "$name"  # Green text

# -----------------------------
# Restore cursor before exiting
# -----------------------------
printf '\e[?25h'  # Show cursor
