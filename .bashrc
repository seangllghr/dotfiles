#
# ~/.bashrc
#

# A useful function for validating programs are installed
exists()
{
  command -v "$1" >/dev/null 2>&1
}

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set vim as my default editor. Note that, with the aliases below, this
# actually calls nvim.
export VISUAL=vim
export EDITOR="$VISUAL"

# Set some useful aliases

alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -la'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias xop='xdg-open'
alias nvg='nvim-gtk'
if exists nvim; then
  alias vim='nvim'
fi

PS1='[\u@\h \W]\$ '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/sean/.vimpkg/bin"
