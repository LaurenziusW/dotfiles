# ==============================================================================
# UKE v8.1 - ZSH CONFIGURATION (Consolidated)
# ==============================================================================
# Cross-platform (macOS/Linux) | Hand-crafted | Feature-rich
# ==============================================================================

# ──────────────────────────────────────────────────────────────────────────────
# OS Detection
# ──────────────────────────────────────────────────────────────────────────────
case "$(uname -s)" in
    Darwin*)    OS="macos" ;;
    Linux*)     OS="linux" ;;
    *)          OS="unknown" ;;
esac

# ──────────────────────────────────────────────────────────────────────────────
# Path & Environment
# ──────────────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

if [[ "$OS" == "macos" ]]; then
    # Homebrew
    [[ -x "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    [[ -x "/usr/local/bin/brew" ]] && eval "$(/usr/local/bin/brew shellenv)"
elif [[ "$OS" == "linux" ]]; then
    # Cargo / Go
    [[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
    [[ -d "$HOME/go/bin" ]] && export PATH="$HOME/go/bin:$PATH"
fi

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"
export PAGER="less"
export LESS="-R"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ──────────────────────────────────────────────────────────────────────────────
# History
# ──────────────────────────────────────────────────────────────────────────────
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

# ──────────────────────────────────────────────────────────────────────────────
# Directory Navigation
# ──────────────────────────────────────────────────────────────────────────────
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# ──────────────────────────────────────────────────────────────────────────────
# Completion
# ──────────────────────────────────────────────────────────────────────────────
autoload -Uz compinit
compinit -C

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ──────────────────────────────────────────────────────────────────────────────
# Key Bindings
# ──────────────────────────────────────────────────────────────────────────────
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# ──────────────────────────────────────────────────────────────────────────────
# Aliases: General
# ──────────────────────────────────────────────────────────────────────────────
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# Modern ls replacement
if command -v eza &>/dev/null; then
    alias ls='eza --icons'
    alias l='eza -l --icons'
    alias ll='eza -la --icons --git'
    alias la='eza -a --icons' # For consistency
    alias lt='eza --tree --level=2 --icons'
else
    alias ls='ls --color=auto'
    alias ll='ls -lah'
    alias la='ls -a'
fi

# Safety & Better Defaults
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h' 2>/dev/null || true
alias myip='curl -s ifconfig.me'

# Editors
alias v='nvim'
alias vim='nvim'
alias zshrc='$EDITOR ~/.zshrc'
alias vimrc='$EDITOR ~/.config/nvim/init.lua'
alias reload='source ~/.zshrc'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glo='git log --oneline --graph --decorate -20'

# Tmux
alias ta='tmux attach'
alias tn='tmux new -s'
alias tl='tmux list-sessions'
alias tmuxrc='$EDITOR ~/.config/tmux/tmux.conf'

# ──────────────────────────────────────────────────────────────────────────────
# Aliases: UKE & Dotfiles
# ──────────────────────────────────────────────────────────────────────────────
alias dots='cd ~/dotfiles'

# Stow helpers
stowit()   { cd ~/dotfiles && stow "$@" && cd - &>/dev/null; }
unstowit() { cd ~/dotfiles && stow -D "$@" && cd - &>/dev/null; }
restowit() { cd ~/dotfiles && stow -R "$@" && cd - &>/dev/null; }

# Tools (v8)
alias gather='uke-gather'
alias doctor='uke-doctor'
alias sticky='uke-sticky'
alias b='uke-bunch'

# Restored UKE aliases (v7)
alias ug='uke gen'
alias ur='uke reload'
alias us='uke status'
alias ud='uke doctor'
alias up='uke profile'
alias ua='uke apply'
alias uf='uke-fix'
alias uu='uke-update'
alias usv='uke-services'
alias uke-edit='uke edit'
alias uke-reload='uke gen && uke reload'

# ──────────────────────────────────────────────────────────────────────────────
# Aliases: Platform Specific
# ──────────────────────────────────────────────────────────────────────────────
if [[ "$OS" == "macos" ]]; then
    alias o='open'
    alias dl='cd ~/Downloads'
    alias desk='cd ~/Desktop'
    alias ports='lsof -i -P'
    alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

    # Yabai/Skhd (v8 style)
    alias yr='yabai --restart-service'
    alias sr='skhd --restart-service'
    alias wr='yr && sr'
    alias yl='tail -f /tmp/yabai_*.err.log'
    alias sl='tail -f /tmp/skhd_*.err.log'

elif [[ "$OS" == "linux" ]]; then
    alias o='xdg-open'
    alias open='xdg-open'
    alias pbcopy='wl-copy'
    alias pbpaste='wl-paste'
    alias sc='systemctl'
    alias scu='systemctl --user'

    # Arch
    if [[ -f /etc/arch-release ]]; then
        alias pac='sudo pacman'
        alias pacs='sudo pacman -S'
        alias pacr='sudo pacman -Rns'
        alias pacq='pacman -Qs'
        alias pacu='sudo pacman -Syu'
        alias yayu='yay -Syu'
        alias yays='yay -Ss'
    fi

    # Hyprland
    alias hr='hyprctl reload'
    alias hl='cat ~/.local/share/hyprland/hyprland.log'
fi

# ──────────────────────────────────────────────────────────────────────────────
# Functions
# ──────────────────────────────────────────────────────────────────────────────
mkcd() { mkdir -p "$1" && cd "$1"; }

# Git clone and enter
gcl() { git clone "$1" && cd "$(basename "$1" .git)"; }

# Archive extraction
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.rar)     unrar x "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find file by name
ff() { find . -type f -iname "*$1*"; }

# Show current workspace (yabai/hyprland)
workspace() {
    if [[ "$OS" == "macos" ]]; then
        yabai -m query --spaces --space 2>/dev/null | jq -r '.index'
    else
        hyprctl activeworkspace 2>/dev/null | grep "workspace ID" | awk '{print $3}'
    fi
}

# Environment info
envinfo() {
    echo "OS: $OS"
    echo "Shell: $SHELL"
    echo "Editor: $EDITOR"
    [[ -n "$TMUX" ]] && echo "Tmux: $(tmux display-message -p '#S')" || echo "Tmux: -"
    echo "Workspace: $(workspace 2>/dev/null || echo '-')"
}


# ──────────────────────────────────────────────────────────────────────────────
# Integrations (FZF, Zoxide, Starship, Plugins)
# ──────────────────────────────────────────────────────────────────────────────

# Zoxide (Smart cd)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# Starship Prompt
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
else
    # Fallback Custom Prompt (v7 style)
    autoload -Uz vcs_info
    precmd() { vcs_info }
    zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'
    zstyle ':vcs_info:git:*' actionformats ' %F{yellow}(%b|%a)%f'
    setopt PROMPT_SUBST
    PROMPT='%F{blue}%~%f${vcs_info_msg_0_}
%F{cyan}❯%f '
    RPROMPT='%F{8}%T%f'
fi

# FZF (Fuzzy Search)
if command -v fzf &>/dev/null; then
    # Source new style (fzf 0.48+)
    source <(fzf --zsh 2>/dev/null) || true

    # Restored Nord-inspired theme
    export FZF_DEFAULT_OPTS="
        --height 40% --layout=reverse --border
        --color=bg+:#3b4252,bg:#2e3440,spinner:#81a1c1,hl:#88c0d0
        --color=fg:#d8dee9,header:#88c0d0,info:#5e81ac,pointer:#81a1c1
        --color=marker:#88c0d0,fg+:#d8dee9,prompt:#81a1c1,hl+:#88c0d0
    "

    # Use fd for faster performance if available
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi

    # Fuzzy cd with preview
    fcd() {
        local dir
        dir=$(fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf --preview 'eza --tree --level=1 --icons {} 2>/dev/null || ls -la {}') && cd "$dir"
    }

    # Fuzzy kill
    fkill() {
        local pid
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
        [[ -n "$pid" ]] && echo "$pid" | xargs kill -${1:-9}
    }

    # Fuzzy history
    fh() {
        print -z $(fc -l 1 | fzf +s --tac | sed 's/ *[0-9]* *//')
    }
fi

# Window Title
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

# Plugins (Syntax Highlighting & Autosuggestions)
if [[ "$OS" == "macos" ]]; then
    PLUG_DIR="/opt/homebrew/share"
    [[ -f "$PLUG_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$PLUG_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [[ -f "$PLUG_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$PLUG_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ "$OS" == "linux" ]]; then
    PLUG_DIR="/usr/share/zsh/plugins"
    [[ -f "$PLUG_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$PLUG_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [[ -f "$PLUG_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$PLUG_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ──────────────────────────────────────────────────────────────────────────────
# Local Overrides
# ──────────────────────────────────────────────────────────────────────────────
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
