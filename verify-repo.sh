
#!/bin/bash

echo "🔍 Verifying Repo Integrity (OS-Aware)..."



OS="unknown"

[[ "$OSTYPE" == "darwin"* ]] && OS="macos"

[[ "$OSTYPE" == "linux-gnu"* ]] && OS="linux"



check_exec() {

    if command -v "$1" &> /dev/null; then

        echo "✅ EXEC: $1"

    else

        echo "❌ MISSING: $1"

    fi

}



echo "--- Common Tools ---"

check_exec "nvim"

check_exec "tmux"

check_exec "zsh"

check_exec "gather-current-space"



if [[ "$OS" == "macos" ]]; then

    echo "--- macOS Specific ---"

    check_exec "yabai"

    check_exec "skhd"

elif [[ "$OS" == "linux" ]]; then

    echo "--- Linux Specific ---"

    check_exec "hyprctl"

    # We purposefully do NOT check for yabai/skhd on Linux

fi

echo "✅ Verification Complete."

