# Platform
case "$(uname -s)" in Darwin*) export UKE_OS="macos";; Linux*) export UKE_OS="linux";; esac

# Path
export PATH="$HOME/.local/bin:$PATH"
[[ "$UKE_OS" == "macos" && -d "/opt/homebrew/bin" ]] && export PATH="/opt/homebrew/bin:$PATH"
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"

# Environment
export EDITOR="nvim"
export VISUAL="nvim"
export LANG="en_US.UTF-8"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# Options
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS NO_BEEP INTERACTIVE_COMMENTS

# Completion
autoload -Uz compinit && compinit -C
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Keys
bindkey -e
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey '^R' history-incremental-search-backward

# Aliases
alias ..="cd .."
alias ...="cd ../.."
alias v="nvim"
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias glog="git log --oneline --graph"

if command -v eza &>/dev/null; then
    alias ls="eza --icons"
    alias ll="eza -la --icons --git"
    alias lt="eza --tree --icons -L2"
else
    alias ls="ls --color=auto"
    alias ll="ls -lah"
fi

# UKE
alias uke-edit="$EDITOR ~/dotfiles/config/registry.yaml"
alias b="uke-bunch"

# Platform
if [[ "$UKE_OS" == "macos" ]]; then
    alias wm-restart="yabai --restart-service && skhd --restart-service"
else
    alias wm-restart="hyprctl reload"
fi

# Functions
mkcd() { mkdir -p "$1" && cd "$1"; }

# Prompt
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
else
    autoload -Uz vcs_info
    precmd() { vcs_info }
    zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'
    setopt PROMPT_SUBST
    PROMPT='%F{blue}%~%f${vcs_info_msg_0_} %F{green}❯%f '
fi

# FZF
if command -v fzf &>/dev/null; then
    [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
fi

# Zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# Local
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
