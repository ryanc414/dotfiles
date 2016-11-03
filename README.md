# dotfiles

## Install

```sh
cd
git clone https://github.com/CJTozer/dotfiles.git .dotfiles
# or add `-b server_mode` to add a 'user@host' section to the prompt
cd .dotfiles
./install
# restart shell for changes to take effect
```

## Content

Mainly aimed at my new zsh set-up.  Includes:

* Submodules for setting up:
    * antigen
    * dotbot (required for this set-up only)
    * Vundle (for vim plugin management)
* Config for:
    * git
    * zsh
    * taskwarrior
    * tmux
    * vim (`:PluginInstall` required to install plugins on first use)
* Utilities for:
    * Pretty printing of git branches (`git note` to annotate branch, `git br` to list branches with annotations)
    * Patched version of tasknote for adding notes to taskwarrior tasks

