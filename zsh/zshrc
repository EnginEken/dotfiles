# --- Homebrew environment ---
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- Completion ---
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump-$ZSH_VERSION"

#autoload -U select-word-style
#select-word-style bash
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# --- Aliases ---
alias l="ls -alh"
alias cd="z"
alias act="source ~/.scripts/activate_venv.sh"
alias pyinit="~/.scripts/initenv.sh"
alias cat="bat -p"
alias books="~/.scripts/start_mkdocs.sh"
alias change_background="~/.scripts/change_background.sh"
alias cop="pbcopy"
alias pas="pbpaste"
alias macports="sudo lsof -PiTCP -sTCP:LISTEN"
alias routes="netstat -nr -f inet"
alias routes6="netstat -nr -f inet6"
alias dns="nslookup"
alias ga="git add"
alias gst="git status"
alias gb="git branch"
alias gbD="git branch --delete --force"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gcp="git cherry-pick"
alias gcmsg="git commit --message"
alias gd="git diff"
alias glo="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
alias glos="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"
alias gl="git pull"
alias grb="git rebase"
alias gsh="git show --pretty=short --show-signature"
alias gsta="git stash --all"
alias gstap="git stash apply"

[[ ! -f ~/.zsh_variables ]] || source ~/.zsh_variables
[[ ! -f ~/.zsh_functions ]] || source ~/.zsh_functions

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# --- Evals ---
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# --- Exports ---
if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi
export PATH="/Users/eeken/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby@3.2/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.2.0/bin:$PATH"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# --- Plugins ---
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/eeken/.scripts/git-auto-fetch.zsh
