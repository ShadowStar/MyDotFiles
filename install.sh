#!/bin/bash - 
#===============================================================================
#
#          FILE: install.sh
# 
#         USAGE: ./install.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: 
#  ORGANIZATION: Gmail
#       CREATED: 05/22/2018 19:32:35
#   LAST CHANGE:05/22/2018 21:26:32
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

DIR="$(dirname "$(realpath $0)")"

if [ "${HOME}" == "$(dirname "${DIR}")" ]; then
	DIR="$(basename ${DIR})"
fi

function linkfile ()
{
	[ ! -e ${2} ] && ln -sfv ${1} ${2} || echo "${2} existed"
}

linkfile ${DIR}/bash_profile ${HOME}/.bash_profile
linkfile ${DIR}/bashrc ${HOME}/.bashrc
linkfile ${DIR}/zshrc ${HOME}/.zshrc
linkfile ${DIR}/ctags_global ${HOME}/.ctags
linkfile ${DIR}/gitconfig_global ${HOME}/.gitconfig
linkfile ${DIR}/gitignore_global ${HOME}/.gitignore_global
linkfile ${DIR}/gitattributes_global ${HOME}/.gitattributes_global
linkfile ${DIR}/gitcommit_template ${HOME}/.gitcommit_template

