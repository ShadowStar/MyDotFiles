#!/usr/bin/env zsh

if [ -f /etc/zshrc ]; then
	. /etc/zshrc
fi

if [ -z $OSTYPE ]; then
	export OSTYPE=$(uname | tr [[:upper:]] [[:lower:]])
fi

function user_remote_info() {
	local host user
	if [ -n "$SSH_CONNECTION" ]; then
		host="@`echo ${SSH_CONNECTION} | cut -d' ' -f 3` "
		user="${USER} "
	fi
	if [ -n "$SUDO_USER" ]; then
		user="${SUDO_USER} "
	fi
	echo "%{$fg_bold[cyan]%}${user}%{$fg_bold[green]%}${host}"
}

autoload -Uz compinit && compinit -i

setopt ALWAYS_TO_END
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_PARAM_SLASH
setopt BASH_AUTO_LIST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt LIST_AMBIGUOUS
setopt MENU_COMPLETE
setopt NO_NOMATCH
setopt PATH_DIRS

unsetopt AUTO_CD
unsetopt COMPLETE_IN_WORD
unsetopt CORRECT_ALL
unsetopt FLOWCONTROL
unsetopt SHARE_HISTORY

zstyle ':completion:*:*:*:*:*' menu select

bindkey "[A" history-beginning-search-backward
bindkey "[B" history-beginning-search-forward

autoload -U colors && colors

if [[ $OSTYPE =~ "darwin" ]]; then
	alias ls='ls -G -F'
elif [[ $OSTYPE =~ "linux" ]]; then
	alias ls='ls --color=auto -F'
	if [ -e /etc/system-release ]; then
		export dist="%{$fg_bold[magenta]%}`cat /etc/system-release | cut -d' ' -f1` "
	fi
fi

export PS1="%D{%H:%M} %{$fg_bold[yellow]%}|$(user_remote_info)${dist}%{$fg_bold[blue]%}%c %{$fg_bold[cyan]%}%#%{$reset_color%} "

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

