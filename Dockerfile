FROM ubuntu:latest

RUN apt update -y > /dev/null 2>&1 && \
    apt upgrade -y > /dev/null 2>&1 && \
    apt install -y locales openssh-server ssh wget unzip > /dev/null 2>&1 && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.UTF-8

# password
ARG Password=Lshckhh1!
ENV Password=${Password}

RUN mkdir /run/sshd

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

RUN echo "root:${Password}" | chpasswd

# start script
RUN echo '#!/bin/bash' > /start.sh && \
    echo '/usr/sbin/sshd' >> /start.sh && \
    echo 'sleep 2' >> /start.sh && \
    echo 'while true; do ssh -o StrictHostKeyChecking=no -p 443 -R0:127.0.0.1:5901 tcp@free.pinggy.io; sleep 5; done' >> /start.sh

RUN chmod +x /start.sh

EXPOSE 5901

CMD ["/start.sh"]
