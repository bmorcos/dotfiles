#!/usr/bin/env bash
# Adapted from tbekolay's scripts
source setup_tools.sh

_PWD=$(pwd)
section "Welcome to the machine my dude!" "*"

section "Installing Packages"
sudo apt update
xargs -a packages.apt sudo apt install
sudo apt full-upgrade

if ! package_installed "google-chrome-stable"; then
    section "Installing Google Chrome"
    CHROME=google-chrome-stable_current_amd64.deb
    echo "--- Downloading $CHROME"
    wget -O /tmp/chrome.deb https://dl.google.com/linux/direct/$CHROME
    echo "--- Installing Chrome"
    sudo gdebi /tmp/chrome.deb
    if [[ $? == 0 ]]
    then
        "--- Chrome installed"
    else
        echo "--- Error installing Chrome"
    fi
    rm -f /tmp/chrome.deb
fi

section "Installing Sublime"
if ! package_installed "sublime-text"; then
    wget -g0 - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    sudo apt-get install sublime-text
fi
#
# if ! package_installed "slack-desktop"; then
#     section "Installing Slack"
#     curl -s https://packagecloud.io/install/repositories/slacktechnologies/slack/script.deb.sh | sudo bash
# fi
#
section "Installing Anaconda"
cd $HOME/Downloads
curl -O https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh | sudo bash
cd $_PWD

section "Linking dotfiles"
source link.sh

section "Setting up zsh"
install_packages zsh
if [[ $(grep "$USER" /etc/passwd) != */bin/zsh ]]; then
    echo "--- Setting zsh as $USER's shell"
    chsh -s $(which zsh)
fi

section "Setting up antigen"
if [[ ! -d $HOME/.zsh-antigen ]]; then
    git clone https://github.com/bmorcos/zsh-antigen.git "$HOME/.zsh-antigen"
    cd "$HOME/.zsh-antigen"
    git subup
    checkandlink "zshrc" "$HOME/.zshrc"
    cd $_PWD
fi


VERILATOR=$HOME/git/verilator
if [[ ! -d $VERILATOR ]]; then
    section "Installing Verilator"
    git clone http://git.veripool.org/git/verilator "$VERILATOR"
    unset VERILATOR_ROOT  # For bash
    cd $VERILATOR
    git pull
    autoconf        # Create ./configure script
    ./configure
    make
    sudo make install
    cd $_PWD
fi

IVERILOG=$HOME/git/iverilog
if [[ ! -d $IVERILOG ]]; then
    section "Installing iverilog"
    git clone https://github.com/steveicarus/iverilog.git "$IVERILOG"
    cd $IVERILOG
    git pull
    sh autoconf.sh
    ./configure
    make
    sudo make install
    cd $_PWD
fi