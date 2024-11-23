# File and Text Operations
alias cat="bat"
alias copy='pbcopy'  # pbcopy: macOS equivalent to xclip
alias ll="ls -lah"
alias vim="nvim"

# Git and Version Control
alias g="git"
alias lg="lazygit"

# Kubernetes
alias k="kubectl"

# Nix
alias nix="nix --extra-experimental-features nix-command --extra-experimental-features flakes"
alias hnix='vim ~/.config/home-manager/home.nix'

# Shell Configuration
alias aliases="bat ~/.config/dotfiles/aliases.zsh"

# Tmux
alias tm='tmux'
alias tma='tmux attach'
alias tmd='tmux detach'

# Notes
OBSIDIAN_NOTES='/Users/manuel/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Notes'
alias note="cd $OBSIDIAN_NOTES && vim $OBSIDIAN_NOTES"
