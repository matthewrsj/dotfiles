#
# ~/.bashrc
#

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac


cd() {
    builtin cd "$@" && ls --color;
}
export -f cd


  # ANSI color codes
RS="\033[0m"    # reset
HC="\033[1m"    # hicolor
UL="\033[4m"    # underline
INV="\033[7m"   # inverse background and foreground
FBLK="\033[30m" # foreground black
FRED="\033[31m" # foreground red
FGRN="\033[32m" # foreground green
FYEL="\033[33m" # foreground yellow
FBLE="\033[34m" # foreground blue
FMAG="\033[35m" # foreground magenta
FCYN="\033[36m" # foreground cyan
FWHT="\033[37m" # foreground white
BBLK="\033[40m" # background black
BRED="\033[41m" # background red
BGRN="\033[42m" # background green
BYEL="\033[43m" # background yellow
BBLE="\033[44m" # background blue
BMAG="\033[45m" # background magenta
BCYN="\033[46m" # background cyan
BWHT="\033[47m" # background white



# Every machine
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.keychain/$HOSTNAME-sh ]; then # Fix gpg issue regardless of host
	. ~/.keychain/$HOSTNAME-sh
fi

if which vim &>/dev/null; then
	export EDITOR=vim
	export VISUAL=vim
else
	export EDITOR=vi
	export VISUAL=vi
fi

auto_ssh_key() {
	for key in $(command ls -1 ~/.ssh | grep -E 'rsa[^\.]*$'); do
		keychain -q --nogui ~/.ssh/$key
	done
}

# Use pyprompt from https://github.com/rettigs/pyprompt
PROMPT_COMMAND=set_prompt
set_prompt () {
    export PS1="$(~/pyprompt/prompt.py)"
}

alias pelstart="make clean && make html && make devserver"
alias pelrestart="make stopserver && pelstart"
alias ll="ls -lashp --color"
alias ls="ls --color"
alias shell="ssh johnsma8@shell.onid.oregonstate.edu"
alias flip="ssh johnsma8@flip.engr.oregonstate.edu"
alias pink="ssh mrsj@pink.workstation.osuosl.bak"
alias diamond="ssh mrsj@diamond.workstation.osuosl.bak"
alias indigo="ssh mrsj@indigo.workstation.osuosl.bak"
alias silver="ssh mrsj@silver.workstation.osuosl.bak"

test -f ~/.git-completion.bash && . $_

export EXECS=/home/mrsj/executables

export PATH=$PATH:$EXECS/ascr:$EXECS/cool-retro-term:/$EXECS/telegram/Telegram
export PATH=$PATH:.


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

alias be="bundle exec"

