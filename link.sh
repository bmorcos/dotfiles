#!/usr/bin/env bash
# Adapted from tbekolay's scripts

source setup_tools.sh

declare -A TARGETS
TARGETS[alias]=.alias
TARGETS[sshconfig]=.ssh/config
TARGETS[gitconfig]=.gitconfig
TARGETS[tmux.conf]=.tmux.conf
TARGETS[ordering-override.keyfile]=/usr/share/indicator-application/ordering-override.keyfile
TARGETS[st-packages]=".config/sublime-text-3/Packages/User/Package Control.sublime-settings"
TARGETS[st-settings]=.config/sublime-text-3/Packages/User/Preferences.sublime-settings
TARGETS[C.sublime-settings]=.config/sublime-text-3/Packages/User/C.sublime-settings
TARGETS[C++.sublime-settings]=.config/sublime-text-3/Packages/User/C++.sublime-settings
TARGETS[reStructuredText.sublime-settings]=.config/sublime-text-3/Packages/User/reStructuredText.sublime-settings
TARGETS[RainbowBrackets.sublime-settings]=.config/sublime-text-3/Packages/User/RainbowBrackets.sublime-settings
TARGETS[vimrc]=.vimrc
TARGETS[remove_base_ps1.sh]=miniconda3/etc/conda/activate.d/remove_base_ps1.sh

for DOTFILE in "${!TARGETS[@]}"; do
    SRC="$PWD/$DOTFILE"
    if [[ ${TARGETS[$DOTFILE]:0:1} == '/' ]]; then
        DST=${TARGETS[$DOTFILE]}
    else
        DST="$HOME/${TARGETS[$DOTFILE]}"
    fi
    checkandlink "$SRC" "$DST"
done
