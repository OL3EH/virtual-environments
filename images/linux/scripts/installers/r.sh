#!/bin/bash -e

# Source the helpers for use with the script
# shellcheck source=/images/linux/scripts/helpers/os.sh
source "$HELPER_SCRIPTS"/os.sh

# install R
osLabel=$(getOSVersionLabel)

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $osLabel-cran40/"

sudo apt update
sudo apt install r-base

invoke_tests "Tools" "R"
