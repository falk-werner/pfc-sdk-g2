#!/bin/bash

set -e

print_usage() {
    cat << EOF
build, (c) 2022 Falk Werner

Usage:
    build init | build | images | help

Commands:
    init    initialize project
    get     download OSS packages
    build   build all packages
    images  build images
    wup     create WUP file
EOF
}

case "$1" in
    -h | --help | help)
        print_usage
        ;;
    init)
        echo "Setup PTXdist project"

        rm -rf /home/user/ptxproj/*
        
        ln -s /home/user/pfc-sdk-g2 base

        mkdir src
        cp /home/user/packages/src/* src
        cp /home/user/pfc-sdk-g2/src/*.md5 src

        mkdir -p configs/wago-pfcXXX
        ln -s /home/user/packages/configs/wago-pfcXXX/packages configs/wago-pfcXXX/packages

        ptxdist clean -q
        ;;
    build | "")
        ptxdist go -q
        ;;
    get)
        ptxdist get -q
        ;;
    images)
        ptxdist images -q
        ;;
    wup)
        make wup
        ;;
    *)
        echo "error: unknown command" 1>&2
        exit 1
        ;;
esac