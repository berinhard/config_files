# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
#[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]\[\033[01;34m\]:\w\[\033[00m\]$(__git_ps1 "(%s)")\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

source $HOME/.coderc

export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache

#http_proxy=""
#ftp_proxy=""
#https_proxy=""

alias clear_pyc='find ./ -name "*.pyc" | xargs rm -v'
alias cdsamples="cd /home/bernardo/.local/share/SuperCollider/custom_samples"


# Rails RVM confs
#if [[ -s $HOME/.rvm/scripts/rvm ]] ; then
#    source $HOME/.rvm/scripts/rvm
#fi
#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
alias load_rvm="source /home/bernardo/.rvm/scripts/rvm"

cd $HOME
alias gvim="gvim 2> /dev/null"
alias pipgrep="pip3 freeze | grep"
alias open="xdg-open"
alias load_rvm="source /home/bernardo/.rvm/scripts/rvm"
alias xcopy="xclip -sel clip"

### Added by the Heroku Toolbelt
#export PATH="/usr/local/heroku/bin:$PATH"

# ffmpeg -framerate 30 -pattern_type glob -i '*.png' -c:v libx264 -r 30 -pix_fmt yuv420p out.mp4
# ffmpeg -ss 00:00:00 -t 00:00:20 -i out_youtube.mp4 out.mp4

alias processing-py="/home/bernardo/src/processing.py-3056-linux64/processing-py.sh"
alias cdberin="cd /home/bernardo/sketchbook/libraries/site-packages/berin/"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

enter_directory() {
  if [[ $PWD == $PREV_PWD ]]; then
    return
  fi

  PREV_PWD=$PWD
  [[ -f ".nvmrc" ]] && nvm use
}

export PROMPT_COMMAND=enter_directory


alias sketches="/home/bernardo/envs/sketches/sketches.py"
alias pvim="vim -g -u /home/bernardo/.vimrc-processing"
alias python="python3"

eval "$(direnv hook bash)"

# ref de instação: https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"


# helper commands:
# find DIR_PATH -type f -exec chmod 644 {} +
# find DIR_PATH -type d -exec chmod 755 {} +

SKETCHBOOK_DIR="/home/bernardo/envs/pyp5js/docs/examples/"
PYTHONBREAKPOINT='ipdb.set_trace'

git config --global alias.pr '!f() { git fetch -fu ${2:-origin} refs/pull/$1/head:pr/$1 && git checkout pr/$1; }; f'

alias pycharm="pycharm &> /dev/null"

pr-branch() {
  if [ -z "$1" ]; then echo "Missing PR Id"; else git fetch origin pull/$1/head:pr$1; fi
}
