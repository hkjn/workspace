# The workspace image is a minimal environment for technical work.
#
# TODO(hkjn): Consider adding back emacs + configs, once it's been fixed to work with musl and Alpine has a package:
# http://forum.alpinelinux.org/forum/general-discussion/cant-find-emacs-package
#
FROM hkjn/alpine

MAINTAINER Henrik Jonsson <me@hkjn.me>

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Install useful programs.
RUN apk add --no-cache bash git go python py2-pip openssh sudo tmux vim && \
    ssh-keygen -b 4096 -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
    /usr/sbin/sshd && \
    adduser -D user -u 500 -s /bin/bash && \
    echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user_sudo && \
    mkdir /home/user/.ssh && \
    ssh-keygen -b 4096 -t rsa -f /home/user/.ssh/id_rsa -N '' && \
    chmod 700 /home/user/.ssh && \
    chmod 400 /home/user/.ssh/authorized_keys && \
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

ENTRYPOINT ["bash"]
