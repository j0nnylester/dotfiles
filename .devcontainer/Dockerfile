FROM debian:sid-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN useradd -mN -r -s /usr/sbin/nologin -u 1000 test \
    && apt-get update \
    && apt-get -y install --no-install-recommends curl ca-certificates \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
USER test
COPY . /home/test/.dotfiles
RUN  cd $HOME \
    && ./.dotfiles/setup.sh \
    && ls -la $HOME