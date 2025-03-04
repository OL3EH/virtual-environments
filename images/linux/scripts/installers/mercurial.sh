#!/bin/bash -e
################################################################################
##  File:  mercurial.sh
##  Desc:  Installs Mercurial
################################################################################

# Source the helpers for use with the script
# shellcheck source=/images/linux/scripts/helpers/os.sh
source "$HELPER_SCRIPTS"/os.sh

if isUbuntu16 ; then
    # Install Mercurial from the mercurial-ppa/releases repository for the latest version for Ubuntu16.
    # https://www.mercurial-scm.org/wiki/Download
    add-apt-repository ppa:mercurial-ppa/releases -y
    apt-get update
fi

apt-get install -y --no-install-recommends mercurial

invoke_tests "Tools" "Mercurial"
