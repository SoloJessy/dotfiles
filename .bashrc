#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### ALIASES ###
alias ls='exa -lhaF --git --group-directories-first --colour-scale'
alias cat='bat'
alias .1='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'

if test -d ~/.cargo; then . "$HOME/.cargo/env"; fi

export RPD=~/projects/rust
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

source ~/.bash_scripts/sources

# xrdb ./Xresources

eval "$(starship init bash)"


# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION
