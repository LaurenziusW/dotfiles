# ==============================================================================
# UKE ZSH Configuration v7.2
# ==============================================================================

# ==============================================================================
# Path
# ==============================================================================
export PATH="$HOME/.local/bin:$PATH"
export UKE_ROOT="${UKE_ROOT:-$HOME/dotfiles/uke}"

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
setopt INC_APPEND_HISTORY

# ==============================================================================
# Completion
# ==============================================================================
autoload -Uz compinit
compinit -C

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ==============================================================================
# Key Bindings
# ==============================================================================
bindkey -e  # Emacs mode
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# ==============================================================================
# FZF Integration (if installed)
# ==============================================================================
if command -v fzf &>/dev/null; then
    # Source fzf keybindings and completion
    [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
    [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
    
    # FZF theme (Nord-inspired)
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
        dir=$(fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf --preview 'eza --tree --level=1 --icons {}' ) && cd "$dir"
    }
    
    # Fuzzy history
    fh() {
        print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
    }
    
    # Fuzzy kill process
    fkill() {
        local pid
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
        if [ "x$pid" != "x" ]; then
            echo $pid | xargs kill -${1:-9}
        fi
    }
fi

# ==============================================================================
# Aliases
# ==============================================================================
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# List files (prefer eza)
if command -v eza &>/dev/null; then
    alias ls='eza --icons'
    alias ll='eza -la --icons --git'
    alias la='eza -a --icons'
    alias lt='eza --tree --level=2 --icons'
    alias l='eza -l --icons'
else
    alias ls='ls --color=auto'
    alias ll='ls -la'
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
alias free='free -h'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -20'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

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

# Editor
export EDITOR="${EDITOR:-nvim}"
alias v='$EDITOR'
alias vim='$EDITOR'

# Arch-specific
alias pac='sudo pacman'
alias pacs='sudo pacman -S'
alias pacr='sudo pacman -Rns'
alias pacq='pacman -Qs'
alias pacu='uke-update --all'

# ==============================================================================
# Prompt
# ==============================================================================
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

# ==============================================================================
# Window Title
# ==============================================================================
case $TERM in
    xterm*|rxvt*|alacritty|wezterm|foot)
        precmd() {
            vcs_info
            print -Pn "\e]0;%~\a"
        }
        preexec() {
            print -Pn "\e]0;$1\a"
        }
        ;;
esac

# ==============================================================================
# Plugins (load if present)
# ==============================================================================
# zsh-autosuggestions
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting (must be last)
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ==============================================================================
# Local overrides
# ==============================================================================
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
