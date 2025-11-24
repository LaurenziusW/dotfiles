# ═══════════════════════════════════════════════════════════
# UNIFIED KEYBOARD ENVIRONMENT - ZSH CONFIGURATION
# Cross-platform shell config for macOS and Linux
# ═══════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────
# OS Detection
# ───────────────────────────────────────────────────────────
case "$(uname -s)" in
    Darwin*)    OS="macos" ;;
    Linux*)     OS="linux" ;;
    *)          OS="unknown" ;;
esac

# ───────────────────────────────────────────────────────────
# History Configuration
# ───────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY           # Share history between sessions
setopt HIST_IGNORE_DUPS        # Don't record duplicates
setopt HIST_IGNORE_SPACE       # Don't record commands starting with space
setopt HIST_VERIFY             # Show command before executing from history
setopt APPEND_HISTORY          # Append to history file
setopt INC_APPEND_HISTORY      # Write to history file immediately

# ───────────────────────────────────────────────────────────
# Directory Navigation
# ───────────────────────────────────────────────────────────
# setopt AUTO_CD                 # cd by typing directory name
# setopt AUTO_PUSHD              # Push directories to stack
# setopt PUSHD_IGNORE_DUPS       # Don't push duplicates
# setopt PUSHD_SILENT            # Don't print directory stack

# ───────────────────────────────────────────────────────────
# Completion System
# ───────────────────────────────────────────────────────────
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Colored completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Menu-style completion
zstyle ':completion:*' menu select

# ───────────────────────────────────────────────────────────
# Key Bindings (Respect Ctrl Layer!)
# ───────────────────────────────────────────────────────────
# Use emacs-style keybindings (Ctrl+A, Ctrl+E, etc.)
# indkey -e

# Ctrl+A: Beginning of line (preserved for Tmux when in tmux!)
# Ctrl+E: End of line
# Ctrl+U: Kill line backward
# Ctrl+K: Kill line forward
# Ctrl+W: Kill word backward
# Ctrl+R: Reverse search
# Ctrl+L: Clear screen

# Arrow keys for history
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ───────────────────────────────────────────────────────────
# Environment Variables
# ───────────────────────────────────────────────────────────
# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Pager
export PAGER='less'
export LESS='-R'  # ANSI colors in less

# Language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ───────────────────────────────────────────────────────────
# PATH Configuration
# ───────────────────────────────────────────────────────────
# Bunches system
if [ -d "$HOME/workflow/bunches" ]; then
    export PATH="$HOME/workflow/bunches:$PATH"
fi

# Local bin
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Platform-specific PATH
if [ "$OS" = "macos" ]; then
    # Homebrew
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# ───────────────────────────────────────────────────────────
# Aliases - Cross-Platform
# ───────────────────────────────────────────────────────────
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
# alias -- -='cd -'  # Go to previous directory

# List files
if command -v eza &> /dev/null; then
    # Use eza if available (modern replacement for ls)
    alias ls='eza --icons'
    alias ll='eza -l --icons --git'
    alias la='eza -la --icons --git'
    alias lt='eza --tree --icons'
else
    # Fallback to traditional ls
    if [ "$OS" = "macos" ]; then
        alias ls='ls -G'
    else
        alias ls='ls --color=auto'
    fi
    alias ll='ls -lh'
    alias la='ls -lah'
fi

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Editor
alias v='nvim'
alias vim='nvim'
alias vi='nvim'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'

# Dotfiles management
alias dots='cd ~/dotfiles'
alias dotfiles='cd ~/dotfiles'

# Tmux
alias ta='tmux attach'
alias tn='tmux new -s'
alias tl='tmux list-sessions'

# Quick config edits
alias zshrc='nvim ~/.zshrc'
alias vimrc='nvim ~/.config/nvim/init.lua'
alias tmuxrc='nvim ~/.tmux.conf'
alias yabairc='nvim ~/.config/yabai/yabairc'
alias skhdrc='nvim ~/.config/skhd/skhdrc'

# Reload shell config
alias reload='source ~/.zshrc'

# System monitoring
alias top='htop'  # if htop is installed

# Network
alias myip='curl -s ifconfig.me'
alias ports='ss -tulanp' # Linux (ss replaces netstat)  # Linux
if [ "$OS" = "macos" ]; then
    alias ports='lsof -i -P'
fi

# ───────────────────────────────────────────────────────────
# Platform-Specific Aliases
# ───────────────────────────────────────────────────────────
if [ "$OS" = "macos" ]; then
    # macOS specific
    alias yabai-restart='yabai --restart-service'
    alias skhd-restart='skhd --restart-service'
    alias yabai-r='yabai --restart-service'
    alias skhd-r='skhd --restart-service'
    alias yabai-log='tail -f /tmp/yabai_*.err.log'
    alias skhd-log='tail -f /tmp/skhd_*.err.log'
    
    # Quick access to common macOS locations
    alias dl='cd ~/Downloads'
    alias desk='cd ~/Desktop'
    alias docs='cd ~/Documents'
    
    # Clipboard
    alias pbcopy='pbcopy'
    alias pbpaste='pbpaste'
    
elif [ "$OS" = "linux" ]; then
    # Linux specific
    alias hypr-restart='hyprctl reload'
    alias hypr-r='hyprctl reload'
    alias hypr-log='cat ~/.hyprland.log'
    
    # Package management (Arch)
    if command -v pacman &> /dev/null; then
        alias pacupdate='sudo pacman -Syu'
        alias pacinstall='sudo pacman -S'
        alias pacsearch='pacman -Ss'
        alias pacremove='sudo pacman -Rs'
    fi
    
    # AUR helper (if using yay)
    if command -v yay &> /dev/null; then
        alias yayu='yay -Syu'
        alias yays='yay -Ss'
    fi
    
    # Clipboard (Wayland)
    if command -v wl-copy &> /dev/null; then
        alias pbcopy='wl-copy'
        alias pbpaste='wl-paste'
    fi
    
    # Systemd shortcuts
    alias sc='systemctl'
    alias scu='systemctl --user'
    alias jc='journalctl'
    alias jcu='journalctl --user'
fi

# ───────────────────────────────────────────────────────────
# Functions
# ───────────────────────────────────────────────────────────

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick find file/directory
ff() {
    find . -type f -iname "*$1*"
}

fd() {
    find . -type d -iname "*$1*"
}

# Backup file
backup() {
    cp "$1"{,.bak}
}

# Quick server (Python)
serve() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

# Git clone and cd
gcl() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# Quick bunch runner
bunch() {
    if [ -z "$1" ]; then
        bunch-manager.sh
    else
        bunch-manager.sh "$1"
    fi
}

# Stow helper for dotfiles
stowit() {
    cd ~/dotfiles && stow "$@" && cd -
}

# Unstow helper
unstowit() {
    cd ~/dotfiles && stow -D "$@" && cd -
}

# Re-stow (refresh symlinks)
restowit() {
    cd ~/dotfiles && stow -R "$@" && cd -
}

# List stow packages
stowlist() {
    cd ~/dotfiles && ls -d */ | sed 's|/||' && cd -
}

# Show what stow would do (dry run)
stowcheck() {
    cd ~/dotfiles && stow -n -v "$@" && cd -
}

# ───────────────────────────────────────────────────────────
# Tool Integration
# ───────────────────────────────────────────────────────────

# FZF (Fuzzy Finder)
if command -v fzf &> /dev/null; then
    # Key bindings
    source <(fzf --zsh) 2>/dev/null || true
    
    # Use fd for fzf if available (faster)
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
    
    # Catppuccin theme for fzf (optional)
    export FZF_DEFAULT_OPTS=" \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
fi

# Zoxide (smarter cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# Starship prompt (if installed)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
else
    # Simple fallback prompt
    setopt PROMPT_SUBST
    PROMPT='%F{blue}%~%f %F{green}❯%f '
fi

# Syntax highlighting (if installed)
if [ "$OS" = "macos" ]; then
    if [ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
        source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    elif [ -f "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
        source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi
elif [ "$OS" = "linux" ]; then
    if [ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi
fi

# Autosuggestions (if installed)
if [ "$OS" = "macos" ]; then
    if [ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
        source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    elif [ -f "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
        source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi
elif [ "$OS" = "linux" ]; then
    if [ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
        source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi
fi

# ───────────────────────────────────────────────────────────
# Workspace & Environment Helpers
# ───────────────────────────────────────────────────────────

# Show current workspace (Hyprland/Yabai)
workspace() {
    if [ "$OS" = "macos" ]; then
        yabai -m query --spaces --space | jq -r '.index'
    elif [ "$OS" = "linux" ]; then
        hyprctl activeworkspace | grep "workspace ID" | awk '{print $3}'
    fi
}

# Environment info
envinfo() {
    echo "OS: $OS"
    echo "Shell: $SHELL"
    echo "Editor: $EDITOR"
    if command -v tmux &> /dev/null && [ -n "$TMUX" ]; then
        echo "Tmux: Active (session: $(tmux display-message -p '#S'))"
    else
        echo "Tmux: Not active"
    fi
    if [ -d "$HOME/dotfiles/.git" ]; then
        echo "Dotfiles: ~/dotfiles ($(cd ~/dotfiles && git rev-parse --abbrev-ref HEAD))"
    fi
}

# ───────────────────────────────────────────────────────────
# Local Customizations
# ───────────────────────────────────────────────────────────
# Source local config if it exists (not tracked in git)
# if [ -f ~/.zshrc.local ]; then
#    source ~/.zshrc.local
# fi

# ───────────────────────────────────────────────────────────
# Welcome Message (optional - comment out if not wanted)
# ───────────────────────────────────────────────────────────
# echo "🚀 Unified Keyboard Environment ready!"

