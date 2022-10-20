ARG REGISTRY_PREFIX=''
ARG CODENAME=xenial

FROM ${REGISTRY_PREFIX}ubuntu:${CODENAME} as builder
RUN apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends \
        build-essential \
        curl \
        libncurses5-dev \
        wget \
        gawk \
        flex \
        bison \
        texinfo \
        python-dev \
        python3-setuptools \
        g++ \
        dialog \
        lzop \
        libc6-dev \
        autoconf \
        libtool \
        xmlstarlet \
        xsltproc \
        doxygen \
        autopoint \
        gettext \
        rsync \
        vim \
        software-properties-common \
        bc \
        groff \
        zip \
        unzip \
        pkg-config \
    && apt autoremove -y

FROM builder as dumb_init
ARG BUILD_DIR=/tmp/build
ARG DUMB_INIT_VERSION=1.2.5
RUN mkdir -p "${BUILD_DIR}" \
  && cd "${BUILD_DIR}" \
  && curl -fSL -s -o dumb-init-${DUMB_INIT_VERSION}.tar.gz https://github.com/Yelp/dumb-init/archive/v${DUMB_INIT_VERSION}.tar.gz \
  && tar -xf dumb-init-${DUMB_INIT_VERSION}.tar.gz \
  && cd "dumb-init-${DUMB_INIT_VERSION}" \
  && make \
  && chmod +x dumb-init \
  && mv dumb-init /usr/local/bin/dumb-init \
  && dumb-init --version

FROM builder as toolchain
ARG TOOLCHAIN_DIR=/opt/gcc-Toolchain-2019.12
ARG TOOLCHAIN_URL=https://github.com/falk-werner/pfc-toolchains/releases/download/gcc-toolchain-2019.12/gcc-toolchain-2019.12.tar.xz
RUN mkdir -p "${TOOLCHAIN_DIR}" \
  && curl -fSL -s -o toolchain.tar.xz "${TOOLCHAIN_URL}" \
  && tar -xf toolchain.tar.xz -C "${TOOLCHAIN_DIR}" \
  && rm -rf "${TOOLCHAIN_DIR}/.git" \
    "${TOOLCHAIN_DIR}/arm-linux-gnueabihf/share/doc" \
    "${TOOLCHAIN_DIR}/arm-linux-gnueabihf/libexec/gcc/arm-linux-gnueabihf/9.2.1/f951" \
    "${TOOLCHAIN_DIR}/arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gfortran" \
    toolchain.tar.xz

FROM builder as ptxdist
ARG PTXDIST_URL=https://github.com/WAGO/ptxdist/archive/refs/tags/Ptxdist-2017.11.1.tar.gz
RUN cd /tmp \
  && curl -fSL -s -o toolchain.tar.xz "${PTXDIST_URL}" \
  && tar -xf toolchain.tar.xz \
  && cd ptxdist-Ptxdist-2017.11.1 \
  && ./configure \
  && make

FROM builder as image

ARG TOOLCHAIN_DIR=/opt/gcc-Toolchain-2019.12

COPY --from=dumb_init /usr/local/bin/dumb-init /usr/local/bin/dumb-init
COPY --from=toolchain "${TOOLCHAIN_DIR}" "${TOOLCHAIN_DIR}"

COPY --from=ptxdist /tmp/ptxdist-Ptxdist-2017.11.1 /tmp/ptxdist-Ptxdist-2017.11.1
RUN cd /tmp/ptxdist-Ptxdist-2017.11.1 \
  && make install \
  && cd - \
  && rm -rf /tmp/ptxdist-Ptxdist-2017.11.1

COPY build.sh /usr/local/bin/build

RUN mkdir -p /home/user/ptxproj

ARG USERID=1000
RUN useradd -u "$USERID" -ms /bin/bash user
RUN chown -R user:user /home/user 


FROM scratch

LABEL maintainer="Falk Werner"
LABEL version="22.0.0"
LABEL description="PFC Builder"

COPY --from=image / /

WORKDIR "/home/user/ptxproj"

ENTRYPOINT ["dumb-init", "--"]