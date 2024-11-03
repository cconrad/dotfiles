#!/usr/bin/env zsh

alias gs='git status'
alias gcane='git commit --amend --no-edit'
alias gc="git checkout"
alias gcm="git commit -m"
alias gd="git diff"
alias unstage="git restore --staged"
alias gu='unstage'

alias ggl="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all"

alias gcb="git checkout -b"
alias gp="git push"
alias gpf="git push --force-with-lease"