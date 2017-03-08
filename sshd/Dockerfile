FROM centos:7
RUN yum -y -q install openssh-server

RUN groupadd deployer && \
    useradd -g deployer deployer
RUN echo 'deployer:password' | chpasswd

ENV SSHKEYGEN /usr/bin/ssh-keygen
RUN $SSHKEYGEN -q -t rsa  -f /etc/ssh/ssh_host_rsa_key -N "" -C "" < /dev/null > /dev/null 2> /dev/null
RUN $SSHKEYGEN -q -t dsa  -f /etc/ssh/ssh_host_dsa_key -N "" -C "" < /dev/null > /dev/null 2> /dev/null

COPY sshd_config /etc/ssh/ 
COPY user_prompt.sh /usr/local/bin/

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-d"]
