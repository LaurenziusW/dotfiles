# ==============================================================================
# ZSH CONFIG - Unified Keyboard Environment
# ==============================================================================
# Cross-platform shell config for macOS and Linux
# ==============================================================================

# ─────────────────────────────────────────────────────────────────────────────
# OS Detection
# ─────────────────────────────────────────────────────────────────────────────
case "$(uname -s)" in
    Darwin*) export UKE_OS="macos" ;;
    Linux*)  export UKE_OS="linux" ;;
    *)       export UKE_OS="unknown" ;;
esac

# ─────────────────────────────────────────────────────────────────────────────
# History
# ─────────────────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# ─────────────────────────────────────────────────────────────────────────────
# Directory Navigation
# ─────────────────────────────────────────────────────────────────────────────
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# ─────────────────────────────────────────────────────────────────────────────
# Completion
# ─────────────────────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# ─────────────────────────────────────────────────────────────────────────────
# Key Bindings (Emacs-style, preserves Ctrl layer)
# ─────────────────────────────────────────────────────────────────────────────
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ─────────────────────────────────────────────────────────────────────────────
# Environment Variables
# ─────────────────────────────────────────────────────────────────────────────
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ─────────────────────────────────────────────────────────────────────────────
# PATH Configuration
# ─────────────────────────────────────────────────────────────────────────────
# UKE binaries
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# Dotfiles UKE
[[ -d "$HOME/dotfiles/uke/bin" ]] && export PATH="$HOME/dotfiles/uke/bin:$PATH"

# Platform-specific
if [[ "$UKE_OS" == "macos" ]]; then
    [[ -f "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    [[ -f "/usr/local/bin/brew" ]] && eval "$(/usr/local/bin/brew shellenv)"
fi

# ─────────────────────────────────────────────────────────────────────────────
# Aliases - Universal
# ─────────────────────────────────────────────────────────────────────────────
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# Listing
if command -v eza &>/dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons --git'
    alias la='eza -la --icons --git'
    alias lt='eza --tree --icons'
else
    [[ "$UKE_OS" == "macos" ]] && alias ls='ls -G' || alias ls='ls --color=auto'
    alias ll='ls -lh'
    alias la='ls -lah'
fi

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Editor
alias v='nvim'
alias vim='nvim'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'

# Dotfiles
alias dots='cd ~/dotfiles'

# Tmux
alias ta='tmux attach'
alias tn='tmux new -s'
alias tl='tmux list-sessions'

# Config editing
alias zshrc='$EDITOR ~/.zshrc'
alias vimrc='$EDITOR ~/.config/nvim/init.lua'
alias tmuxrc='$EDITOR ~/.tmux.conf'
alias reload='source ~/.zshrc'

# Network
alias myip='curl -s ifconfig.me'

# ─────────────────────────────────────────────────────────────────────────────
# Aliases - UKE Specific
# ─────────────────────────────────────────────────────────────────────────────
alias uke-edit='uke edit'
alias uke-reload='uke gen && uke reload'
alias b='uke-bunch'

# ─────────────────────────────────────────────────────────────────────────────
# Aliases - Platform Specific
# ─────────────────────────────────────────────────────────────────────────────
if [[ "$UKE_OS" == "macos" ]]; then
    alias yabai-restart='yabai --restart-service'
    alias skhd-restart='skhd --restart-service'
    alias yabai-log='tail -f /tmp/yabai_*.err.log'
    alias skhd-log='tail -f /tmp/skhd_*.err.log'
    alias dl='cd ~/Downloads'
    alias desk='cd ~/Desktop'
    alias ports='lsof -i -P'
else
    alias hypr-restart='hyprctl reload'
    alias hypr-log='cat ~/.hyprland.log'
    [[ -x "$(command -v pacman)" ]] && {
        alias update='sudo pacman -Syu'
        alias install='sudo pacman -S'
        alias search='pacman -Ss'
    }
    [[ -x "$(command -v yay)" ]] && {
        alias yayu='yay -Syu'
        alias yays='yay -Ss'
    }
    [[ -x "$(command -v wl-copy)" ]] && {
        alias pbcopy='wl-copy'
        alias pbpaste='wl-paste'
    }
    alias sc='systemctl'
    alias scu='systemctl --user'
fi

# ─────────────────────────────────────────────────────────────────────────────
# Functions
# ─────────────────────────────────────────────────────────────────────────────
mkcd() { mkdir -p "$1" && cd "$1"; }

extract() {
    [[ -f "$1" ]] || { echo "'$1' is not a valid file"; return 1; }
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.gz)      gunzip "$1" ;;
        *.tar)     tar xf "$1" ;;
        *.tbz2)    tar xjf "$1" ;;
        *.tgz)     tar xzf "$1" ;;
        *.zip)     unzip "$1" ;;
        *.7z)      7z x "$1" ;;
        *)         echo "'$1' cannot be extracted" ;;
    esac
}

ff() { find . -type f -iname "*$1*"; }

gcl() { git clone "$1" && cd "$(basename "$1" .git)"; }

# Stow helpers
stowit()   { cd ~/dotfiles && stow "$@" && cd -; }
unstowit() { cd ~/dotfiles && stow -D "$@" && cd -; }
restowit() { cd ~/dotfiles && stow -R "$@" && cd -; }

# Show current workspace
workspace() {
    if [[ "$UKE_OS" == "macos" ]]; then
        yabai -m query --spaces --space 2>/dev/null | jq -r '.index'
    else
        hyprctl activeworkspace 2>/dev/null | grep "workspace ID" | awk '{print $3}'
    fi
}

# Environment info
envinfo() {
    echo "OS: $UKE_OS"
    echo "Shell: $SHELL"
    echo "Editor: $EDITOR"
    [[ -n "$TMUX" ]] && echo "Tmux: $(tmux display-message -p '#S')" || echo "Tmux: -"
    echo "Workspace: $(workspace 2>/dev/null || echo '-')"
}

# ─────────────────────────────────────────────────────────────────────────────
# Tool Integration
# ─────────────────────────────────────────────────────────────────────────────
# FZF
if command -v fzf &>/dev/null; then
    source <(fzf --zsh) 2>/dev/null || true
    command -v fd &>/dev/null && {
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    }
    export FZF_DEFAULT_OPTS="--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
fi

# Zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)" && alias cd='z'

# Starship
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
else
    setopt PROMPT_SUBST
    PROMPT='%F{blue}%~%f %F{green}❯%f '
fi

# Syntax highlighting
if [[ "$UKE_OS" == "macos" ]]; then
    [[ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
        source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    [[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Autosuggestions
if [[ "$UKE_OS" == "macos" ]]; then
    [[ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
        source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    [[ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
        source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ─────────────────────────────────────────────────────────────────────────────
# Local Customizations
# ─────────────────────────────────────────────────────────────────────────────
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
