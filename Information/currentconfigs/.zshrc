# =============================================================================
# UKE v8 - Zsh Configuration
# Cross-platform shell setup with OS-specific adaptations
# =============================================================================

# -----------------------------------------------------------------------------
# OS Detection
# -----------------------------------------------------------------------------
case "$(uname -s)" in
    Darwin) export UKE_OS="macos" ;;
    Linux)  export UKE_OS="linux" ;;
    *)      export UKE_OS="unknown" ;;
esac

# -----------------------------------------------------------------------------
# Path
# -----------------------------------------------------------------------------
typeset -U path  # Unique entries only

path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    $path
)

# OS-specific paths
if [[ "$UKE_OS" == "macos" ]]; then
    path=(
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        "/opt/homebrew/opt/coreutils/libexec/gnubin"
        $path
    )
    export HOMEBREW_NO_AUTO_UPDATE=1
elif [[ "$UKE_OS" == "linux" ]]; then
    path=(
        "/usr/local/bin"
        $path
    )
fi

export PATH

# -----------------------------------------------------------------------------
# Environment Variables
# -----------------------------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Less options
export LESS="-R -F -X"
export LESSHISTFILE=-

# FZF
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=16"
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY       # Write timestamps
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first
setopt HIST_IGNORE_DUPS       # Ignore consecutive duplicates
setopt HIST_IGNORE_SPACE      # Ignore commands starting with space
setopt HIST_VERIFY            # Show before executing history expansion
setopt SHARE_HISTORY          # Share history between sessions
setopt APPEND_HISTORY         # Append instead of overwrite

# -----------------------------------------------------------------------------
# Options
# -----------------------------------------------------------------------------
setopt AUTO_CD                # cd without typing cd
setopt AUTO_PUSHD             # Push directories to stack
setopt PUSHD_IGNORE_DUPS      # No duplicates in stack
setopt PUSHD_SILENT           # Don't print stack
setopt CORRECT                # Command correction
setopt INTERACTIVE_COMMENTS   # Allow comments in interactive
setopt NO_BEEP                # No beeping

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------
autoload -Uz compinit
compinit -C

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{cyan}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'

# -----------------------------------------------------------------------------
# Key Bindings (Emacs style for line editing)
# -----------------------------------------------------------------------------
bindkey -e
bindkey '^[[A' history-search-backward  # Up arrow
bindkey '^[[B' history-search-forward   # Down arrow
bindkey '^[[H' beginning-of-line        # Home
bindkey '^[[F' end-of-line              # End
bindkey '^[[3~' delete-char             # Delete

# -----------------------------------------------------------------------------
# Aliases - Universal
# -----------------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias v='nvim'
alias vi='nvim'
alias vim='nvim'

alias g='git'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --oneline -20'
alias gp='git push'
alias gs='git status -sb'
alias gpl='git pull'

alias t='tmux'
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tn='tmux new -s'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias h='history'
alias j='jobs -l'
alias cls='clear'
alias path='echo -e ${PATH//:/\\n}'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# -----------------------------------------------------------------------------
# Aliases - OS Specific
# -----------------------------------------------------------------------------
if [[ "$UKE_OS" == "macos" ]]; then
    alias ls='ls -G'
    alias ll='ls -lhG'
    alias la='ls -lahG'
    alias o='open'
    alias oo='open .'
    alias br='brew'
    alias bru='brew update && brew upgrade'
    alias brc='brew cleanup'
    
    # Yabai/skhd
    alias yr='yabai --restart-service'
    alias sr='skhd --restart-service'
    alias yl='tail -f /tmp/yabai_*.err.log'
    alias sl='tail -f /tmp/skhd_*.err.log'
    
elif [[ "$UKE_OS" == "linux" ]]; then
    alias ls='ls --color=auto'
    alias ll='ls -lh --color=auto'
    alias la='ls -lah --color=auto'
    alias o='xdg-open'
    alias oo='xdg-open .'
    alias pac='sudo pacman'
    alias pacu='sudo pacman -Syu'
    alias pacs='pacman -Ss'
    alias yay='yay --noconfirm'
    
    # Hyprland
    alias hr='hyprctl reload'
    alias hl='cat ~/.local/share/hyprland/hyprland.log'
fi

# -----------------------------------------------------------------------------
# Prompt (simple, fast)
# -----------------------------------------------------------------------------
autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%F{cyan}(%b)%f '
setopt PROMPT_SUBST

PROMPT='%F{blue}%~%f ${vcs_info_msg_0_}%F{yellow}❯%f '

# -----------------------------------------------------------------------------
# UKE Commands
# -----------------------------------------------------------------------------
# Gather windows (calls the appropriate script)
alias gather='uke-gather'

# Bunch launcher
bunch() {
    if [[ -z "$1" ]]; then
        echo "Usage: bunch <name>"
        echo "Available: study, guitar, coding, email, reading"
        return 1
    fi
    uke-bunch "$1"
}

# Quick workspace switch (for shell context)
ws() {
    if [[ "$UKE_OS" == "macos" ]]; then
        yabai -m space --focus "$1"
    elif [[ "$UKE_OS" == "linux" ]]; then
        hyprctl dispatch workspace "$1"
    fi
}

# -----------------------------------------------------------------------------
# FZF Integration (if installed)
# -----------------------------------------------------------------------------
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
fi

# -----------------------------------------------------------------------------
# Local Overrides
# -----------------------------------------------------------------------------
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
