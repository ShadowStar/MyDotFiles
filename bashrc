#!/usr/bin/env bash

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -z $OSTYPE ]; then
	export OSTYPE=$(uname | tr [[:upper:]] [[:lower:]])
fi

function user_remote_info {
	local host user
	if [ -n "$SSH_CONNECTION" ]; then
		host="@`echo ${SSH_CONNECTION} | cut -d' ' -f 3` "
		user="${USER} "
	fi
	if [ -n "$SUDO_USER" ]; then
		user="${SUDO_USER} "
	fi
	echo "\[\e[36;1m\]${user}\[\e[32;1m\]${host}"
}

shopt -s histappend
export HISTCONTROL=${HISTCONTROL:-ignorespace:erasedups}
export HISTSIZE=${HISTSIZE:-5000}
export AUTOFEATURE=${AUTOFEATURE:-true autotest}

if [[ $- =~ i ]]; then
	bind 'set show-all-if-ambiguous on'
	bind 'TAB:menu-complete'
	bind '"[A":history-search-backward'
	bind '"[B":history-search-forward'
fi

export PS1="\A \[\e[33;1m\]|$(user_remote_info)\[\e[34;1m\]\W \[\e[36;1m\]\\$\[\e[0m\] "

if [[ $OSTYPE =~ "darwin" ]]; then
	alias ls='ls -G -F'
elif [[ $OSTYPE =~ "linux" ]]; then
	alias ls='ls --color=auto -F'
fi

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias lh='ls -lh'
alias grep="grep --exclude 'tags' --exclude 'cscope.*' --binary-files=without-match --color=auto"

if command -v vim >/dev/null; then
	alias vi='vim'
fi

if command -v vimpager >/dev/null; then
	export PAGER='vimpager'
fi

