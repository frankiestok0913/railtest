FROM ubuntu:22.04

RUN apt update && apt install -y openssh-server

RUN mkdir /run/sshd

RUN echo 'root:123456' | chpasswd
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
