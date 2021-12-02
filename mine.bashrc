# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\]\$ ' | lolcat
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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi




./fm6000 -f wolf.txt  -m 8 -g 8 -l 20 | lolcat





lololps1() {
    # Make a RAINBOW COLORED bash prompt
    # Requires lolcat and python

    # Implement my version of \w because I can't just outright expand a PS1 string
    # Actually, bash 4.4 can do it.... I'm not running 4.4
    # Bash argument modification is crazy
    # Replace $HOME with ~
    mypwd=${PWD/#$HOME/"~"}
    # Greedy delete everything before the last forward slash
    #mypwd=${mypwd##*/}

    # Get the current python virtualenv
    myvenv=$(python -c 'import sys;sys.stdout.write(sys.prefix.split("/")[-1] if hasattr(sys, "real_prefix") or hasattr(sys, "base_prefix") and sys.prefix != sys.base_prefix else "")')
    # surround with square braces if non-empty
    myvenv="${myvenv:+[$myvenv]}"

    # Make a persistent, incrementing seed to make a smooth rainbow effect from line to line
    if [ -z ${LOLCAT_SEED+x} ]; then LOLCAT_SEED=1; else let "LOLCAT_SEED += 1"; fi

    PS1="$myvenv$(whoami)@$HOSTNAME:$mypwd"
    PS1="${PS1/duck/🦆}"
    PS1="${PS1/duck-kudu/🦌}"

    # Colorize it
    # lolcat -f forces escape sequences even when lolcat doesn't think they'd matter
    # lolcat -F changes the frequency of the rainbow
    PS1=$(echo "$PS1" | lolcat -f -F 0.7 -S $LOLCAT_SEED 2>/dev/null)
    # Strip the "reset colors to normal" commands
    PS1=$(echo "$PS1" | sed $'s/\033\[0m//g')
    # Replace escape sequences with [escaped escape sequences]
    # e.g.: \[\033[38;5;39m\]
    PS1=$(echo "$PS1" | sed -r $'s/\033''(\[[0-9]+;[0-9]+;[0-9]+m)/\\\[\\033\1\\\]/g')

    # change the color back to white and add the $/# PS1 character
    PS1="${PS1}\[\033[0m\]\$ "
}
PROMPT_COMMAND=lololps1

