# The workspace image is a minimal environment for technical work.
#
# TODO(hkjn): Consider adding back emacs + configs, once it's been fixed to work with musl and Alpine has a package:
# http://forum.alpinelinux.org/forum/general-discussion/cant-find-emacs-package
#
FROM hkjn/alpine

MAINTAINER Henrik Jonsson <me@hkjn.me>

ENV UNPRIVILEGED_UID=500 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    GOSU_VERSION=1.10 \
    GOSU_KEY=B42F6819007F00F88E364FD4036A9C25BF357DD4

RUN set -x && \
    apk add --no-cache --virtual .gosu-deps dpkg gnupg openssl && \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys $GOSU_KEY && \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    apk del --no-cache .gosu-deps && \
    apk add --no-cache bash git go python py2-pip openssh sudo tmux vim && \
    adduser -D user -u $UNPRIVILEGED_UID -s /bin/bash && \
    echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user_sudo && \
    mkdir /home/user/.ssh && \
    chmod 700 /home/user/.ssh && \
    chown -R user:user /home/user && \
    passwd -u user

RUN echo 'Happy haxxing!' > /etc/motd

USER user

WORKDIR /home/user

RUN mkdir -p src/hkjn.me &&
    git clone https://github.com/hkjn/scripts && \
    git clone https://github.com/hkjn/dotfiles && \
    cd src/hkjn.me/dotfiles && \
    cp .bash* ~/

ENTRYPOINT ["gosu", "start", "&&", "bash"]
