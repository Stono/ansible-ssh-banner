#!/bin/bash
set +e
echo "Please wait...."
sleep 3

echo "Validating expect script works!"
ssh-expect deployer@secret-server echo Hello from the remote server

sleep 3

echo "Running ansible playbook!"
cd /root
ANSIBLE_DEBUG=true ansible-playbook playbook.yml
