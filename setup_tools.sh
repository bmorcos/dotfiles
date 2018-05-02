#!/usr/bin/env bash
# Adapted from tbekolay's scripts

package_installed() {
    INSTALLED="install ok installed"
    # shellcheck disable=SC2016
    #  We want to pass this string directly to dpkg-query
    [[ $(dpkg-query --show --showformat='${Status}\n' "$1" 2> /dev/null) == "$INSTALLED" ]]
}

install_packages() {
    for PACKAGE in "$@"; do
        if ! package_installed "$PACKAGE"; then
            sudo apt-get --no-install-recommends -y install "$PACKAGE"
        fi
    done
}

remove_packages() {
    for PACKAGE in "$@"; do
        if package_installed "$PACKAGE"; then
            sudo apt-get --purge remove "$PACKAGE"
        fi
    done
}
checkfile() {
    if [[ -f $1 ]]; then
        read -p "$1 exists. Overwrite? [y/n] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            return 0
        else
            return 1
        fi
    else
        return 0
    fi
}

sanitycheck() {
    read -p "Keep going? [y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
}

section () {
    CH='-'
    if [[ $# -eq 2 ]]; then
        CH=$2
    fi
    head -c ${#1} < /dev/zero | tr '\0' "$CH"
    echo
    echo "$1"
    head -c ${#1} < /dev/zero | tr '\0' "$CH"
    echo
}

checkandlink () {
    SRC=$1
    DST=$2
    DIR=$(dirname "$DST")

    if [ ! -d "$DIR" ]; then
        echo "--- Making directory '$DIR'"
        mkdir -p "$DIR"
    fi

    if [[ ! -h "$DST" || $(readlink "$DST") != "$SRC" ]]; then
        echo "--- Linking $DST to $SRC"
        rm -rf "$DST"
        if [[ $SRC == *".service" ]]; then
            # Special case due to systemd not allowing services to be symlinks
            ln "$SRC" "$DST"
        else
            ln -s "$SRC" "$DST"
        fi
    fi
}
