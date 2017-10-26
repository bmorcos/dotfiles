#!/bin/bash

ln -sf $PWD/alias $HOME/.alias
ln -sf $PWD/sshconfig $HOME/.ssh/config
ln -sf $PWD/gitconfig $HOME/.gitconfig
ln -sf $PWD/tmux.conf $HOME/.tmux.conf
ln -sf $PWD/ordering-override.keyfile /usr/share/indicator-application/ordering-override.keyfile
ln -sf $PWD/chrome-remote-desktop-session $HOME/.chrome-remote-desktop-session
ln -sf $PWD/chrome-remote-desktop /opt/google/chrome-remote-desktop/chrome-remote-desktop
ln -sf $PWD/st-settings $HOME/.config/sublime-text-3/Packages/User/Preferences.sublime-settings
ln -sf $PWD/st-packages "$HOME/.config/sublime-text-3/Packages/User/Package Control.sublime-settings"
ln -sf $PWD/C.sublime-settings "$HOME/.config/sublime-text-3/Packages/User/C.sublime-settings"
