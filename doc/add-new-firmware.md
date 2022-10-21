# How to add a new Firmware

Since this repository is derived from [WAGO/pfc-firmware-sdk-G2](https://github.com/WAGO/pfc-firmware-sdk-G2/),
a new firmware is added after a new version is released in the upstream repository.

## Steps

1. [Create a preliminary Tag](#Create-a-preliminary-Tag)
2. [Create a preliminary Release](#Create-a-preliminary-Release)
3. [Import sources](#Import-Sources)
4. [Create open source package](#Create open-source-package)
5. create close source package
6. create release tag
7. release

## Create a preliminary Tag

Switch to the `dummy` branch an create a preliminary tag.
The tag must have the same of the firmware to release, e.g. `v03.08.08`.

````bash
git checkout dummy
git tag -a v03.08.08 -m "v03.08.08 (FW20.1)"
````

The purpose of this tag is to create a preliminary release with a proper
URL that can be used for testing.

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
