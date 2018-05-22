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
#        AUTHOR: ShadowStar, <orphen.leiliu@gmail.com>
#  ORGANIZATION: Gmail
#       CREATED: 05/22/2018 19:32:35
#   LAST CHANGE:05/22/2018 20:17:28
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

DIR="$(dirname "$(realpath $0)")"

if [ "${HOME}" == "$(dirname "${DIR}")" ]; then
	DIR="$(basename ${DIR})"
fi

ln -sv ${DIR}/bash_profile ${HOME}/.bash_profile
ln -sv ${DIR}/bashrc ${HOME}/.bashrc
ln -sv ${DIR}/zshrc ${HOME}/.zshrc
ln -sv ${DIR}/ctags_global ${HOME}/.ctags
ln -sv ${DIR}/gitconfig_global ${HOME}/.gitconfig
ln -sv ${DIR}/gitignore_global ${HOME}/.gitignore_global
ln -sv ${DIR}/gitattributes_global ${HOME}/.gitattributes_global
ln -sv ${DIR}/gitcommit_template ${HOME}/.gitcommit_template

