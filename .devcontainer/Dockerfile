FROM mcr.microsoft.com/devcontainers/ruby:3.3
# Remove stale Yarn apt config baked into older base images — uses deprecated apt-key method
# that Ubuntu 24.04 rejects, causing devcontainer feature installs (docker-in-docker) to fail.
RUN rm -f /etc/apt/sources.list.d/yarn.list && \
    apt-key del 62D54FD4003F6525 2>/dev/null || true
