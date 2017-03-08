FROM centos:7
RUN yum -y -q install epel-release && \
		yum -y -q install ansible openssh-clients expect 

RUN mkdir -p /etc/ansible/group_vars

# Stored the password for the target server in here, but you shouldn't do that in the real world
COPY all /etc/ansible/group_vars/all
COPY ansible_hosts /etc/ansible/hosts
COPY ansible.cfg /etc/ansible/ansible.cfg
COPY playbook.yml /root/

# Disabled this for the purposes of the demo, you should do that in the real world either
ENV ANSIBLE_HOST_KEY_CHECKING false

# Disable host key checking (dont do this in prod)
RUN mkdir -p /root/.ssh
COPY config /root/.ssh/config
RUN chmod 0644 /root/.ssh/config

# Copy the ssh wrapper
COPY ssh-expect /bin/ssh-expect

COPY go.sh /usr/local/bin/
CMD ["/usr/local/bin/go.sh"]
