# Define __git_files to prevent really slow autocompletion on large repos
__git_files () {
  _files
}

[[ -n "$SSH_CLIENT" ]] || export DEFAULT_USER=$(whoami)

source ~/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found
antigen bundle colored-man-pages
antigen bundle sudo

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# z plugin for navigation
antigen bundle rupa/z

# k command for colourful ls
antigen bundle supercrabtree/k

# 'sensible' defaults
antigen bundle willghatch/zsh-saneopt

# Set the theme - do not use a powerline one.
antigen theme robbyrussell

# Tell antigen that you're done.
antigen apply

# Needed for ctrl-x ctrl-e to work for some reason...
export EDITOR=vim

# Alias
alias tmux='TERM=xterm-256color tmux'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ll -h'
alias grep='grep --color -I'
alias ls=exa

# Path
export PATH=$PATH:~/path/

# FZF - needs installing so only source if installed.
if [ -f ~/.fzf.zsh ]
then
  source ~/.fzf.zsh
fi

# Don't share history
setopt no_share_history

# Terminal type
export TERM="xterm-256color"

# Colour scheme for tasknote
# Do `mdv -t all | less` to explore other options.
export AXC_THEME=884.0134

# Context-specifics
if [ -f ~/.zshrc_user ]
then
  source ~/.zshrc_user
fi

# Sometimes zsh autocomplete will break... Run this to fix.
fix_zsh()
{
  rm -f ~/.zcompdump*
  rm -f ~/.antigen/.zcompdump*
  exec zsh
}

alias ls='exa'

