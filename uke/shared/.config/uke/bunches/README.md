# UKE Bunches

This directory contains "Bunch" definitions.
A Bunch is a shell script that sets up a specific environment (e.g., "coding", "study").

## How to create a Bunch

Create a file named `<name>.sh` in this directory (e.g., `coding.sh`).
Make it executable: `chmod +x coding.sh`

## Template

```bash
#!/usr/bin/env bash
# BUNCH: coding - VS Code, Terminal, Browser

source "$UKE_ROOT/lib/core.sh"

log_info "Starting Coding Bunch..."

if is_macos; then
    open -a "Visual Studio Code"
    open -a "WezTerm"
    open -a "Brave Browser"
else
    code &
    wezterm &
    brave &
fi

# Wait for apps
sleep 2

# Arrange windows
uke-gather
```

## Usage

Run from terminal:
```bash
uke-bunch coding
```

Or via hotkey (Cmd+Ctrl+Number).
