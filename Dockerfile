ARG REGISTRY_PREFIX=''
ARG VERSION="23.0.0pre"

FROM ${REGISTRY_PREFIX}me8i/pfc-builder:${VERSION} as image

ARG USERID=1000
RUN usermod -u "$USERID" user 
RUN groupmod -g "$USERID" user
RUN chown -R user:user /home/user

FROM scratch

LABEL maintainer="Falk Werner"
LABEL version="23.0.0"
LABEL description="PFC Project Builder"

COPY --from=image / /

WORKDIR "/home/user/ptxproj"

ENTRYPOINT ["dumb-init", "--"]