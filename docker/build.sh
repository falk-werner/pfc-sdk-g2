#!/bin/bash

set -e

VERSION=v03.07.14
OSS_PACKAGES_URL=https://github.com/falk-werner/pfc-sdk-g2/releases/download/${VERSION}/open-source-packages.tar.xz
CSS_PACKAGES_URL=https://github.com/falk-werner/pfc-sdk-g2/releases/download/${VERSION}/closed-source-packages.tar.xz

print_usage() {
    cat << EOF
build, (c) 2022 Falk Werner

Usage:
    build init | build | images | help

Commands:
    init    initialize project
    build   full build
    images
EOF
}

case "$1" in
    -h | --help | help)
        print_usage
        ;;
    init)
        echo "Setup PTXdist project"
        ptxdist select configs/wago-pfcXXX/ptxconfig_pfc_g2
        ptxdist platform configs/wago-pfcXXX/platformconfig        
        ptxdist toolchain /opt/gcc-Toolchain-2019.12/arm-linux-gnueabihf/bin/
        ptxdist clean -q

        if ! md5sum packages/closed-source-packages.tar.xz.md5 ; then
            echo "Add Closed Source packages"
            curl -fSL -s -o packages/closed-source-packages.tar.xz ${CSS_PACKAGES_URL}
            md5sum packages/closed-source-packages.tar.xz.md5
            tar -xf packages/closed-source-packages.tar.xz
        fi

        if ! md5sum packages/open-source-packages.tar.xz.md5 ; then
            echo "Add OSS Packages"
            curl -fSL -s -o packages/open-source-packages.tar.xz ${OSS_PACKAGES_URL}
            md5sum packages/open-source-packages.tar.xz.md5
            tar -xf packages/open-source-packages.tar.xz
        fi
        ;;
    build | "")
        ptxdist go -q
        ;;
    images)
        ptxdist images -q
        ;;
    *)
        echo "error: unknown command" 1>&2
        exit 1
        ;;
esac