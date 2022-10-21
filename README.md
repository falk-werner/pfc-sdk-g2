[![build](https://github.com/falk-werner/pfc-sdk-g2/actions/workflows/build.yml/badge.svg)](https://github.com/falk-werner/pfc-sdk-g2/actions/workflows/build.yml)

# pfc-sdk-g2

Provides a docker file to create PFC firmware images.  
Please refer to [https://github.com/WAGO/pfc-firmware-sdk-G2](https://github.com/WAGO/pfc-firmware-sdk-G2) for more information.

## Prerequisites

Make sure that docker and make are installed on the host system.  
To install docker, please refer to the instructions depending on your host system, e.g for Ubuntu use [https://docs.docker.com/install/linux/docker-ce/ubuntu/](https://docs.docker.com/install/linux/docker-ce/ubuntu/).

To install make, you can use apt:

    > sudo apt install make

## Using make wrapper

The make wrapper is used for convenience, to simplify the interaction with docker. There are some main goals defined:

| Command       | Description |
| ------------- | ----------- |
| builder       | create docker image *pfc-builder* |
| init          | initialize PTXdist project in *ptxproj* directory |
| get           | download all OSS packages |
| offline-get   | verify that all OSS packages are downloaded |
| build         | build all packages |
| offline-build | build all packages without network access |
| images        | create SD card image and WUP file |
| wup           | create WUP file |
| run           | runs *pfc-builder* in bash mode |
