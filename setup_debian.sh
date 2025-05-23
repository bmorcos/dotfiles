#!/usr/bin/env bash
# Adapted from tbekolay's scripts
source setup_tools.sh

install_packages curl

_PWD=$(pwd)
section "Welcome to the machine my dude!" "*"

if ! package_installed "sublime-text"; then
    section "Getting Sublime"
    curl -sS https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"

fi

# if ! package_installed "simplescreenrecorder"; then
#     section "Getting Simple Screen recorder"
#     sudo add-apt-repository ppa:maarten-baert/simplescreenrecorder
# fi

section "Installing Packages"
echo "--- Update package lists"
sudo apt update
echo "--- Installing..."
while read p; do
  install_packages $p
done <packages.apt

section "Detect sensors"
sudo sensors-detect --auto

MONOKAI="$HOME/git/vim-monokai"
if [[ ! -d "$MONOKAI" ]]; then
    section "Getting vim colour scheme"
    git clone https://github.com/sickill/vim-monokai.git "$MONOKAI"
    checkandlink "$MONOKAI/colors/monokai.vim" "$HOME/.vim/colors/monokai.vim"
fi
mkdir -p "$HOME/.vim/undofiles"

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

# section "Installing Slack"
# sudo snap install slack --classic

section "Installing Discord"
sudo snap install discord

section "Installing VLC"
sudo snap install vlc

section "Installing Miniconda"
wget -O /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sudo bash /tmp/miniconda.sh

section "Linking dotfiles"
source ./link.sh

section "Setting up zsh"
install_packages zsh
if [[ $(grep "$USER" /etc/passwd) != */bin/zsh ]]; then
    echo "--- Setting zsh as $USER's shell"
    chsh -s $(which zsh)
fi

section "Setting up antigen"
if [[ ! -d "$HOME/.zsh-antigen" ]]; then
    git clone https://github.com/bmorcos/zsh-antigen.git "$HOME/.zsh-antigen"
    cd "$HOME/.zsh-antigen"
    git subup
    echo "--- Linking zshrc"
    checkandlink "zshrc" "$HOME/.zshrc"
    cd $_PWD
fi

if [ "$1" = "-dev" ]; then
    section "Installing Development Packages"
    echo "--- Installing..."
    while read p; do
      install_packages $p
    done <dev_packages.apt

    VERILATOR="$HOME/git/verilator"
    if [[ ! -d "$VERILATOR" ]]; then
        section "Installing Verilator"
        git clone http://git.veripool.org/git/verilator "$VERILATOR"
        unset VERILATOR_ROOT  # For bash
        cd "$VERILATOR"
        git pull
        autoconf        # Create ./configure script
        ./configure
        make
        sudo make install
        cd $_PWD
    fi

    IVERILOG="$HOME/git/iverilog"
    if [[ ! -d "$IVERILOG" ]]; then
        section "Installing iverilog"
        git clone https://github.com/steveicarus/iverilog.git "$IVERILOG"
        cd "$IVERILOG"
        git pull
        sh autoconf.sh
        ./configure
        make
        sudo make install
        cd $_PWD
    fi
fi

section "unity"
sudo apt install ubuntu-unity-desktop

section "Upgrade Packages"
sudo apt full-upgrade
