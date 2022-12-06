ARG REGISTRY_PREFIX=''

FROM ${REGISTRY_PREFIX}pfc-builder as image

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