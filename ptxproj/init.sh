#!/bin/bash

echo "Setup Project"

PROJECT_DIR=/home/user/ptxproj

if [ ! -L ${PROJECT_DIR}/base ] ; then
    rm -f ${PROJECT_DIR}/base
    ln -s /home/user/pfc-sdk-g2 ${PROJECT_DIR}/base
fi

if [ ! -d ${PROJECT_DIR}/src ] ; then
    rm -rf ${PROJECT_DIR}/src
    mkdir -p ${PROJECT_DIR}/src
    cp /home/user/packages/src/* ${PROJECT_DIR}/src
    cp /home/user/pfc-sdk-g2/src/*.md5 ${PROJECT_DIR}/src
fi

if [ ! -L ${PROJECT_DIR}/configs/wago-pfcXXX/packages ] ; then
    rm -f ${PROJECT_DIR}/configs/wago-pfcXXX/packages
    ln -s /home/user/packages/configs/wago-pfcXXX/packages ${PROJECT_DIR}/configs/wago-pfcXXX/packages
fi

ptxdist select ${PROJECT_DIR}/configs/wago-pfcXXX/ptxconfig_pfc_g2
