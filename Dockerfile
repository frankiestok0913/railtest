FROM ubuntu:latest

RUN apt update -y > /dev/null 2>&1 && \
    apt upgrade -y > /dev/null 2>&1 && \
    apt install -y locales openssh-server ssh wget unzip > /dev/null 2>&1 && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

ARG Password
ENV Password=${Password}

RUN mkdir /run/sshd

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

RUN echo root:${Password} | chpasswd

# script start
RUN echo "#!/bin/bash" > /start.sh
RUN echo "/usr/sbin/sshd" >> /start.sh
RUN echo "sleep 2" >> /start.sh
RUN echo "ssh -o StrictHostKeyChecking=no -p 443 -R0:127.0.0.1:5901 tcp@free.pinggy.io" >> /start.sh

RUN chmod +x /start.sh

EXPOSE 5901

CMD ["/start.sh"]
