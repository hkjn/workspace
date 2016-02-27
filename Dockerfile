# The workspace image is a minimal environment for technical work.
#
# It has mosh, making it easy to connect to it like other hosts. Bind
# the mosh port to the host and run mosh-server to connect remotely:
# $ docker run -p 2000:60001/udp hkjn/workspace
# user@31b82abde850:~$ mosh-server
#
# MOSH CONNECT 60004 abcd
#
# Connect from another host with MOSH_KEY=abcd mosh-client remoteHost 2000
#
# TODO(hkjn): Consider adding back emacs + configs, once it's been fixed to work with musl and Alpine has a package:
# http://forum.alpinelinux.org/forum/general-discussion/cant-find-emacs-package
#
FROM alpine

MAINTAINER Henrik Jonsson <me@hkjn.me>

ENV USER user
ENV HOME /home/$USER
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Install useful programs.
RUN apk --no-cache add python py-pip bash vim mosh tmux git go && \
    adduser -D $USER -s /bin/bash

# Add locale settings.
COPY locale.conf /etc/

# Add user's config files.
WORKDIR $HOME

COPY bashrc.sh .bashrc
COPY gitconfig .gitconfig
COPY tmux.conf .tmux.conf
RUN echo 'Happy haxxing!' > /etc/issue

USER $USER

ENTRYPOINT ["bash"]
