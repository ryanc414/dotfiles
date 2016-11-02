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

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# z plugin for navigation
antigen bundle rupa/z

# 'sensible' defaults
antigen bundle willghatch/zsh-saneopt

# Load the theme.
export BULLETTRAIN_PROMPT_SEPARATE_LINE=false
export BULLETTRAIN_PROMPT_ADD_NEWLINE=false
export BULLETTRAIN_EXEC_TIME_SHOW=true
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

# FZF
source ~/.fzf.zsh

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
