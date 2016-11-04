# Define __git_files to prevent really slow autocompletion on large repos
__git_files () {
  _files
}

source ~/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle go
antigen bundle command-not-found
# antigen bundle tmuxinator
antigen bundle taskwarrior
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

# Load the theme.
export BULLETTRAIN_PROMPT_SEPARATE_LINE=false
export BULLETTRAIN_PROMPT_ADD_NEWLINE=false
export BULLETTRAIN_EXEC_TIME_SHOW=true
export BULLETTRAIN_TIME_BG=magenta
export BULLETTRAIN_TIME_FG=yellow
export BULLETTRAIN_GIT_EXTENDED=false # Simple 'is workspace dirty' only to save time on large codebases
antigen theme https://github.com/caiogondim/bullet-train-oh-my-zsh-theme bullet-train

# Tell antigen that you're done.
antigen apply

# Needed for ctrl-x ctrl-e to work for some reason...
export EDITOR=vim

# Alias
alias gotest='go test -v . | sed ''/PASS/s//$(printf "\033[32;1mPASS\033[0m")/'' | sed ''/FAIL/s//$(printf "\033[31;1mFAIL\033[0m")/'' | sed ''/RUN/s//$(printf "\033[0;1mRUN\033[0m")/'''
## For tmux to work in 256 colour mode
alias tmux='TERM=xterm-256color tmux'
## Alias for next task
alias tn='tasknote'
alias ts='task summary'

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
