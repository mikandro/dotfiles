# ~/.bashrc - Bash configuration

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ---------- Path Configuration ----------
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

# Node Version Manager (nvm) - uncomment if using nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# fnm (Fast Node Manager) - uncomment if using fnm
# eval "$(fnm env --use-on-cd)"

# ---------- History Configuration ----------
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize

# ---------- Editor ----------
export EDITOR='nvim'
export VISUAL='nvim'

# ---------- Aliases ----------

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# List files
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch -a'
alias gcb='git checkout -b'
alias gm='git merge'
alias gr='git remote -v'
alias gf='git fetch'
alias grh='git reset --hard'
alias grs='git reset --soft'

# Node/NPM/Yarn aliases
alias ni='npm install'
alias nid='npm install --save-dev'
alias nis='npm install --save'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nrd='npm run dev'
alias nci='npm ci'
alias ncu='npm-check-updates'
alias npkill='npx npkill'

# Yarn
alias y='yarn'
alias yi='yarn install'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn remove'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'
alias yd='yarn dev'

# pnpm
alias pn='pnpm'
alias pni='pnpm install'
alias pna='pnpm add'
alias pnad='pnpm add -D'
alias pnr='pnpm run'
alias pns='pnpm start'
alias pnt='pnpm test'
alias pnb='pnpm build'

# Development
alias dev='npm run dev'
alias serve='npm run serve'
alias build='npm run build'

# File operations
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

# Editor
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# System
alias update='sudo apt update && sudo apt upgrade -y'  # For Debian/Ubuntu
alias c='clear'
alias h='history'
alias j='jobs -l'

# Find and grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Network
alias ping='ping -c 5'
alias ports='netstat -tulanp'

# Docker (if used)
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dstop='docker stop $(docker ps -aq)'
alias dclean='docker system prune -af'

# Dotfiles
alias dots='cd ~/dotfiles'
alias reload='source ~/.bashrc'

# ---------- Functions ----------

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quick npm package search
npms() {
  npm search "$1"
}

# Kill process on port
killport() {
  lsof -ti:$1 | xargs kill -9
}

# Git commit with conventional commit message
gcom() {
  local type=$1
  shift
  git commit -m "$type: $*"
}

# ---------- Prompt ----------
# Simple two-line prompt with git branch
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]\n\[\033[01;36m\]❯\[\033[00m\] '

# ---------- Starship Prompt (Optional) ----------
# Uncomment the line below if you have starship installed
# eval "$(starship init bash)"

# ---------- Load local configuration ----------
# This allows you to have machine-specific config
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
