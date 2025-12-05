# ==============================================================================
# UKE ZSH Configuration v7.2 - Cross-Platform
# ==============================================================================
# Works on both macOS and Linux (Arch)
# ==============================================================================

# ==============================================================================
# OS Detection
# ==============================================================================
case "$(uname -s)" in
    Darwin*) export UKE_OS="macos" ;;
    Linux*)  export UKE_OS="linux" ;;
    *)       export UKE_OS="unknown" ;;
esac

# ==============================================================================
# Path Configuration
# ==============================================================================
export PATH="$HOME/.local/bin:$PATH"
export UKE_ROOT="${UKE_ROOT:-$HOME/dotfiles/uke}"

# Add UKE bin to path
[[ -d "$UKE_ROOT/bin" ]] && export PATH="$UKE_ROOT/bin:$PATH"

# Platform-specific paths
if [[ "$UKE_OS" == "macos" ]]; then
    # Homebrew (Apple Silicon first, then Intel)
    [[ -f "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    [[ -f "/usr/local/bin/brew" ]] && eval "$(/usr/local/bin/brew shellenv)"
fi

# ==============================================================================
# History
# ==============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt APPEND_HISTORY

# ==============================================================================
# Directory Navigation
# ==============================================================================
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# ==============================================================================
# Completion
# ==============================================================================
autoload -Uz compinit
compinit -C

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ==============================================================================
# Key Bindings (Emacs mode)
# ==============================================================================
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# ==============================================================================
# Environment Variables
# ==============================================================================
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"
export PAGER='less'
export LESS='-R'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ==============================================================================
# Aliases - Universal
# ==============================================================================
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# Listing (prefer eza, fall back to ls)
if command -v eza &>/dev/null; then
    alias ls='eza --icons'
    alias ll='eza -la --icons --git'
    alias la='eza -a --icons'
    alias lt='eza --tree --level=2 --icons'
    alias l='eza -l --icons'
else
    if [[ "$UKE_OS" == "macos" ]]; then
        alias ls='ls -G'
    else
        alias ls='ls --color=auto'
    fi
    alias ll='ls -lah'
    alias la='ls -a'
fi

# Safety
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Better defaults
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h' 2>/dev/null || true

# Editor
alias v='$EDITOR'
alias vim='$EDITOR'
alias vimrc='$EDITOR ~/.config/nvim/init.lua'
alias zshrc='$EDITOR ~/.zshrc'
alias reload='source ~/.zshrc'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
gcl() { git clone "$1" && cd "$(basename "$1" .git)"; }

# Tmux
alias ta='tmux attach'
alias tn='tmux new -s'
alias tl='tmux list-sessions'
alias tmuxrc='$EDITOR ~/.tmux.conf'

# UKE shortcuts
alias ug='uke gen'
alias ur='uke reload'
alias us='uke status'
alias ud='uke doctor'
alias up='uke profile'
alias ua='uke apply'
alias uf='uke-fix'
alias uu='uke-update'
alias usv='uke-services'
alias b='uke-bunch'
alias uke-edit='uke edit'
alias uke-reload='uke gen && uke reload'

# Dotfiles
alias dots='cd ~/dotfiles'

# Network
alias myip='curl -s ifconfig.me'

# ==============================================================================
# Aliases - Platform Specific
# ==============================================================================
if [[ "$UKE_OS" == "macos" ]]; then
    # macOS Window Manager
    alias yabai-restart='yabai --restart-service'
    alias skhd-restart='skhd --restart-service'
    alias yabai-log='tail -f /tmp/yabai_*.err.log'
    alias skhd-log='tail -f /tmp/skhd_*.err.log'
    
    # macOS Directories
    alias dl='cd ~/Downloads'
    alias desk='cd ~/Desktop'
    
    # macOS Utilities
    alias ports='lsof -i -P'
    alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
else
    # Linux (Hyprland)
    alias hypr-restart='hyprctl reload'
    alias hypr-log='cat ~/.hyprland.log'
    
    # Systemd
    alias sc='systemctl'
    alias scu='systemctl --user'
    
    # Clipboard (Wayland)
    if command -v wl-copy &>/dev/null; then
        alias pbcopy='wl-copy'
        alias pbpaste='wl-paste'
    fi
    
    # Arch Linux
    if [[ -f /etc/arch-release ]]; then
        alias pac='sudo pacman'
        alias pacs='sudo pacman -S'
        alias pacr='sudo pacman -Rns'
        alias pacq='pacman -Qs'
        alias pacu='uke-update --all'
        
        if command -v yay &>/dev/null; then
            alias yayu='yay -Syu'
            alias yays='yay -Ss'
        fi
    fi
fi

# ==============================================================================
# Functions
# ==============================================================================
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

# Stow helpers
stowit()   { cd ~/dotfiles && stow "$@" && cd - >/dev/null; }
unstowit() { cd ~/dotfiles && stow -D "$@" && cd - >/dev/null; }
restowit() { cd ~/dotfiles && stow -R "$@" && cd - >/dev/null; }

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

# ==============================================================================
# FZF Integration
# ==============================================================================
if command -v fzf &>/dev/null; then
    # Source fzf - try different paths
    if [[ "$UKE_OS" == "macos" ]]; then
        [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
        # Homebrew fzf
        [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
        [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]] && source /opt/homebrew/opt/fzf/shell/completion.zsh
    else
        [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
        [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
    fi
    
    # Try new fzf --zsh syntax (fzf 0.48+)
    source <(fzf --zsh 2>/dev/null) || true
    
    # FZF theme (Nord-inspired, works with Catppuccin too)
    export FZF_DEFAULT_OPTS="
        --height 40% --layout=reverse --border
        --color=bg+:#3b4252,bg:#2e3440,spinner:#81a1c1,hl:#88c0d0
        --color=fg:#d8dee9,header:#88c0d0,info:#5e81ac,pointer:#81a1c1
        --color=marker:#88c0d0,fg+:#d8dee9,prompt:#81a1c1,hl+:#88c0d0
    "
    
    # Use fd if available (faster than find)
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
    
    # Fuzzy cd with preview
    fcd() {
        local dir
        dir=$(fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf --preview 'eza --tree --level=1 --icons {} 2>/dev/null || ls -la {}') && cd "$dir"
    }
    
    # Fuzzy history
    fh() {
        print -z $(fc -l 1 | fzf +s --tac | sed 's/ *[0-9]* *//')
    }
    
    # Fuzzy kill process
    fkill() {
        local pid
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
        if [[ -n "$pid" ]]; then
            echo "$pid" | xargs kill -${1:-9}
        fi
    }
fi

# ==============================================================================
# Zoxide (smart cd)
# ==============================================================================
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# ==============================================================================
# Prompt
# ==============================================================================
# Use Starship if available, otherwise custom prompt
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
else
    # Custom prompt with git integration
    autoload -Uz vcs_info
    precmd() { vcs_info }
    
    zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'
    zstyle ':vcs_info:git:*' actionformats ' %F{yellow}(%b|%a)%f'
    setopt PROMPT_SUBST
    
    # Two-line prompt with path and git
    PROMPT='%F{blue}%~%f${vcs_info_msg_0_}
%F{cyan}❯%f '
    
    # Right prompt with time
    RPROMPT='%F{8}%T%f'
fi

# ==============================================================================
# Window Title
# ==============================================================================
case $TERM in
    xterm*|rxvt*|alacritty|wezterm|foot)
        precmd() {
            [[ -z "${STARSHIP_SHELL:-}" ]] && vcs_info
            print -Pn "\e]0;%~\a"
        }
        preexec() {
            print -Pn "\e]0;$1\a"
        }
        ;;
esac

# ==============================================================================
# Plugins
# ==============================================================================
# zsh-autosuggestions
if [[ "$UKE_OS" == "macos" ]]; then
    [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
        source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
        source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting (must be last plugin)
if [[ "$UKE_OS" == "macos" ]]; then
    [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
        source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ==============================================================================
# Local Overrides
# ==============================================================================
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
