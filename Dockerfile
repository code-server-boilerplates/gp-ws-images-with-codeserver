# While we publish images on GHCR, we also made them avaailable on RHQCR.
FROM ghcr.io/code-server-boilerplates/base AS csb-bootstrap

FROM gitpod/workspace-full AS final-image

RUN sudo mkdir /workspace \
  && chown -Rv gitpod:gitpod /workspace && chmod 777 /workspace \
  && ARCH="$(dpkg --print-architecture)" && \
    curl -fsSL "https://github.com/boxboat/fixuid/releases/download/v0.5/fixuid-0.5-linux-$ARCH.tar.gz" | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: gitpod\ngroup: gitpod\n" > /etc/fixuid/config.yml \
  && curl -fsSL https://code-server.dev/install.sh | sudo sh -s -- --prefix=/home/gitpod/.local

# Copy our bootstrap script to our custom image
COPY --from=csb-bootstrap /usr/local/bin/code-server-launchpad.sh /usr/local/bin/code-server-launchpad.sh

# Assumes that install-packages script exist in your workspace image.
# Otherwise, umcomment these lines below and comment out L13.
#RUN sudo apt-get update \
#  && sudo RUNLEVEL=1 DEBIAN_FRONTEND=noninteractive apt-get install dumb-init -y --no-install-recommends \
#  && sudo apt clean -y && rm -rfv /var/cache/debconf/* /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN sudo install-packages dumb-init

ENV PREFIX="@csb-dev/gitpod-ws-full"

EXPOSE 8080
VOLUME [ "/workspace" ]
ENTRYPOINT [ "/usr/local/bin/code-server-launchpad.sh" ]
CMD [ "start" ]