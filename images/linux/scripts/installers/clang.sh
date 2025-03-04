#!/bin/bash -e
################################################################################
##  File:  clang.sh
##  Desc:  Installs Clang compiler
################################################################################

# Source the helpers for use with the script
# shellcheck source=/images/linux/scripts/helpers/os.sh
source "$HELPER_SCRIPTS"/os.sh
# shellcheck source=/images/linux/scripts/helpers/install.sh
source "$HELPER_SCRIPTS"/install.sh

function InstallClang {
    local version=$1

    echo "Installing clang-$version..."
    if [[ $version =~ 9 ]] && isUbuntu16 || [[ $version =~ 12 ]]; then
        ./llvm.sh "$version"
        apt-get install -y "clang-format-$version"
	llvm_repo=$(grep '^deb.*apt.llvm.org\/' /etc/apt/sources.list)
	echo "llvm $llvm_repo" >> "$HELPER_SCRIPTS"/apt-sources.txt
    else
        apt-get install -y "clang-$version" "lldb-$version" "lld-$version" "clang-format-$version"
    fi    
}

function SetDefaultClang {
    local version=$1

    echo "Make Clang ${version} default"
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-"${version}" 100
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-"${version}" 100
    update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-"${version}" 100
}

# Download script for automatic installation
download_with_retries https://apt.llvm.org/llvm.sh
chmod +x llvm.sh

versions=$(get_toolset_value '.clang.versions[]')
default_clang_version=$(get_toolset_value '.clang.default_version')

for version in ${versions[*]}; do
    if [[ $version != "$default_clang_version" ]]; then
        InstallClang "$version"
    fi
done
InstallClang $default_clang_version

SetDefaultClang $default_clang_version
rm llvm.sh

invoke_tests "Tools" "clang"
