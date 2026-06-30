#!/usr/bin/env zsh

ZDOTDIR=$HOME/.cache/
ZSHZ_DATA=$HOME/.cache/z
HISTFILE=$HOME/.cache/zsh_history
SHELL_SESSION_DIR=$HOME/.cache/zsh_sessions

if [ -f /etc/zshrc ]; then
	. /etc/zshrc
fi

## History file configuration
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

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

export CTPATH=$(echo /opt/*-tools/bin 2>/dev/null | tr ' ' ':')
export LPATH=/usr/local

if $(locale -a 2>/dev/null | grep -q zh_CN.UTF-8); then
	export LANG="zh_CN.UTF-8"
	export LC_ALL="zh_CN.UTF-8"
elif $(locale -a 2>/dev/null | grep -q en_US.UTF-8); then
	export LANG="en_US.UTF-8"
	export LC_ALL="en_US.UTF-8"
else
	export LANG="POSIX"
	export LC_ALL="POSIX"
fi

if [[ $OSTYPE =~ "darwin" ]]; then
	DIST="macOS"
	PATH=$PATH:/opt/bin:/opt/my_scripts
	if command -v brew >/dev/null
	then
		LPATH=$(brew --prefix)
		GNUPATH=$(echo ${LPATH}/opt/*/libexec/gnubin | tr ' ' ':')
		local bpath
		bpath=$(brew --prefix gnu-getopt)
		if [[ -d "${bpath}" ]]; then
			GNUPATH=$GNUPATH:"${bpath}"/bin
		fi
		bpath=$(brew --prefix gettext)
		if [[ -d "${bpath}" ]]; then
			GNUPATH=$GNUPATH:"${bpath}"/bin
		fi
		bpath=$(brew --prefix bison)
		if [[ -d "${bpath}" ]]; then
			GNUPATH=$GNUPATH:"${bpath}"/bin
		fi
		bpath=$(brew --prefix powerlevel10k)
		if [[ -d "${bpath}" && $ZSH_THEME == "powerlevel10k/powerlevel10k" ]]; then
			. "${bpath}"/powerlevel10k.zsh-theme
		fi
		export GNUPATH
	fi
	alias pkginfo="pkgutil -v --pkg-info"
	alias pkgf="pkgutil -v --files"
	alias pkgfinfo="pkgutil -v --file-info"
	alias pkgs="pkgutil --pkgs"
	alias pkgl="pkgutil --pkgs | grep -v \"^com\.apple\""
	alias ls='ls -G'
	alias GetBTMMAddr="echo show Setup:/Network/BackToMyMac | scutil | sed -n 's/.* : *\(.*\).$/\1/p'"
	if $(netstat -adnW -f inet|grep -q 8001); then
		export http_proxy="http://127.0.0.1:8001"; export HTTP_PROXY="http://127.0.0.1:8001"; export https_proxy="http://127.0.0.1:8001"; export HTTPS_PROXY="http://127.0.0.1:8001";
	elif $(netstat -adnW -f inet|grep -q 1087); then
		export http_proxy=http://127.0.0.1:1087;export https_proxy=http://127.0.0.1:1087;
	fi
elif [[ $OSTYPE =~ "linux" ]]; then
	DIST="Linux"
	alias ls='ls --color=auto'
	if [ -e /etc/system-release ]; then
		DIST="%{$fg_bold[magenta]%}`cat /etc/system-release | cut -d' ' -f1` "
	fi
fi

if [[ -n ${CTPATH} ]]; then
	PATH=$PATH:$CTPATH
fi
export PATH

if [[ -d ${LPATH}/share/zsh/site-functions ]]; then
	FPATH="${LPATH}/share/zsh/site-functions:${FPATH}"
fi

autoload -Uz compinit && compinit -i
autoload -U colors && colors

if [ -f ${LPATH}/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
	. ${LPATH}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f ${LPATH}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	. ${LPATH}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if command -v fzf >/dev/null; then
	eval "$(fzf --zsh)"
fi

if [[ -d $HOME/.oh-my-zsh ]]; then
	. $HOME/.oh-my-zsh/zshrc
else
	export PS1="%D{%H:%M} %{$fg_bold[yellow]%}|$(user_remote_info)${DIST} %{$fg_bold[blue]%}%c %{$fg_bold[cyan]%}%#%{$reset_color%} "
fi

#
# Override setting for oh-my-zsh
#

setopt ALWAYS_TO_END
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_PARAM_SLASH
setopt BASH_AUTO_LIST
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
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

alias cp='cp -i'
alias grep="grep --exclude 'tags' --exclude 'cscope.*' --binary-files=without-match --color=auto"
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias lh='ls -lh'
alias ls="$aliases[ls] -F"
alias mv='mv -i'
alias rm='rm -i'

if command -v vim >/dev/null; then
	alias vi='vim -O'
fi

if command -v vimpager >/dev/null; then
	export PAGER='vimpager'
fi

ulimit -n 524288

alias wakepc="wakeonlan e0:d5:5e:0e:44:14"
alias wakenas="wakeonlan 00:11:32:7b:cd:b9"
alias wakelenove="wakeonlan e8:80:88:20:9c:f1"

