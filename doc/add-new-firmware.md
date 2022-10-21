# How to add a new Firmware

Since this repository is derived from [WAGO/pfc-firmware-sdk-G2](https://github.com/WAGO/pfc-firmware-sdk-G2/),
a new firmware is added after a new version is released in the upstream repository.

## Steps

1. [Create a preliminary Tag](#Create-a-preliminary-Tag)
2. [Create a preliminary Release](#Create-a-preliminary-Release)
3. [Import sources](#Import-Sources)
4. [Check Toochain and PTXdist version](#Check-Toochain-and-PTXdist-version)
5. [Create open source package](#Create-open-source-package)
6. [Create close source package](#Create-close-source-package)
7. [Testing and Bugfixing](#Testing-and-Bugfixing)
8. [Create SD-card Image and WUP file](#Create-SD-card-Image-and-WUP-file)
9. [Retintegrate, Tag and Release](#Retintegrate,-Tag-and-Release)

## Create a preliminary Tag

Switch to the `dummy` branch an create a preliminary tag.
The tag must have the same of the firmware to release, e.g. `v03.08.08`.

````bash
git checkout dummy
git tag -a v03.08.08 -m "v03.08.08 (FW20.1)"
````

The purpose of this tag is to create a preliminary release with a proper
URL that can be used for testing.

Update the `VERSION` variable in the `docker/build.sh` script.

## Create a preliminary Release

Create a preliminary release using the GitHub UI, e.g. `03.08.08`.
Specify the previously created tag, make shure that `pre-release` is checked
and publish the pre-release.

We will add files to the preliminary release later on. The release is already visbile to all GitHub users, but this is the only known way to
make files available under production-ready URLs.

## Import Sources

Clone the Upstream repository into a sepeate directory.

    git clone --depth 1 --branch FW20.1-03.08.08 https://github.com/WAGO/pfc-firmware-sdk-G2.git /path/to/upstream

Switch back to this repository and create a development branch for the new firmware.

    cd /path/to/pfd-sdk-g2
    git checkout -b FW20.1

Whipe out all contents of the ptxproj directory.

    rm -rf ptxproj
    mkdir ptxproj

Use rsync to import sources from the upstream directory.

    rsync -a --exclude .git /path/to/upstream/ ptxproj

Remove `.gitattributes` file.

    rm ptxproj/.gitattributes

Commit and publish the changes so far.

    git add ptxproj
    git commit -m "importet sources from upstream"
    git push -u origin FW20.1

## Check Toochain and PTXdist version

Check the required versions of toolchain and PTXdist. Update `Dockerfile`
if needed. Instructions can be found in the upstream readme.

## Create open source package

Make sure that all required packages are available.

    make get

Remove `/src/production*.tar`. This large binary is not needed to build
the firmware. It is necessary to change PTXdist configuration an platform
configuration to do this. But this can be done later.

All archives in `/src` directory must be put in the open souce package
archive.

````bash
mkdir -p /tmp/oss-packages/src
cd /tmp/oss-packages
mv /path/to/ptxproj/*.tar* src
mv /path/to/ptxproj/*.tgz src
mv /path/to/ptxproj/certdata-*.txt src
tar -cf open-source-packages.tar src --owner=root --group=root
xz -z9 open-source-packages.tar
````

Update ptxproj/packages/open-source-packages.tar.xz.md5

    mkdir /path/to/ptxproj/packages
    md5sum open-source-packages.tar.xz >  path/to/ptxproj/packages/open-source-packages.tar.xz.md5

Upload open-source-packages.tar.xz to the previously created
preliminary release.

## Create close source package

All `.ipk` files and `.tgz` archives of `ptxproj/configs/wago-pfcXXX/packages` directory
must be put into the closed source package archive.

````bash
mkdir -p /tmp/css-packages/src/configs/wago-pfcXXX/packages
cd /tmp/css-packages
mv /path/to/ptxproj/configs/wago-pfcXXX/packages/*.ipk configs/wago-pfcXXX/packages
mv /path/to/ptxproj/configs/wago-pfcXXX/packages/*.tgz configs/wago-pfcXXX/packages
tar -cf closed-source-packages.tar configs --owner=root --group=root
xz -z9 closed-source-packages.tar
````

Update ptxproj/packages/closed-source-packages.tar.xz.md5

    mkdir /path/to/ptxproj/packages
    md5sum closed-source-packages.tar.xz >  path/to/ptxproj/packages/closed-source-packages.tar.xz.md5

Upload closed-source-packages.tar.xz to the previously created
preliminary release.

## Testing and Bugfixing

There are several make targets to support testing and bugfixing stage.

| Target        | Description |
| ------------- | ----------- |
| init          | download and extract required packages from the prelimiary release |
| offline-get   | verify that no additional packages are required |
| offline-build | build all packages without network access |
| images        | build images |
| wup           | create WUP file |

## Create SD-card Image and WUP file

````bash
make images
make wup
````

Add SD-card image and WUP file to the preliminary release.

## Retintegrate, Tag and Release

Create a pull request and merge the branch into `main`.

Delete the preliminary tag and recreate a new one.

Publish the preliminary release as the latest release.