# Shell Options.
shopt -s checkwinsize
# Append to the history file, don't overwrite it.
shopt -s histappend

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# Color definitions.
COL_YEL="\[\e[1;33m\]"
COL_GRA="\[\e[0;37m\]"
COL_WHI="\[\e[1;37m\]"
COL_GRE="\[\e[1;32m\]"
COL_RED="\[\e[1;31m\]"
COL_NOR='\[\033[00m\]'

color_prompt=yes
if ! [ -x /usr/bin/tput ] || ! tput setaf 1 >&/dev/null; then
   # We have no color support; not compliant with Ecma-48
   # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
   # a case would tend to support setf rather than setaf.)
   color_prompt=
fi

# Bash Prompt
if [[ "$UID" -eq 0 ]]; then
	_COL_USER=$COL_RED
	_p="#"
else
	_COL_USER=$COL_GRE
	_p="$"
fi
COLORIZED_PROMPT="${_COL_USER}\u${COL_WHI}@${COL_YEL}\h${COL_WHI}:\w\n${_p} $COL_NOR"
if [ "$color_prompt" = yes ]; then
	PS1="${COLORIZED_PROMPT}"
else
	PS1="\u@\h:\w${_p} "
fi

export PATH=$PATH:/home/user/bin
alias pp="git pull && git push"
alias gs="git status"
