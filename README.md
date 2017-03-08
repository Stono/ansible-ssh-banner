# ansible-ssh-banner
This repo is to test different ways of handling servers which run a promt when you log in.

There are two containers:

## sshd
This container runs an sshd server, set up with a `deployer` user.
In the `sshd_config` we use ForceCommand to trigger a script when they log in.  This is a relatively common way of overriding the incoming shell, but it is certainly not the only way.

It looks like this, you can see I've answered the question with `because its lovely`:

```
[root@ansible /]# ssh deployer@secret-server
deployer@secret-server's password: 
Welcome to our super secure server!
Why are you logging on to this lovely server? because its lovely
[deployer@secret-server ~]$ 

```

## ansible
This container has ansible in it, and also a couple of methods I've been trying to get past this prompt in an automated fashion.

### Ansible expect module
I've been playing around with a playbook:
```
---
- hosts: all

  tasks:
  - expect:
      command: "echo hello" 
      responses:
        (?i)Why are you logging on to this lovely server: "Because I am deploying."

```

It doesn't work.

### Using expect
Using the `expect` script, I can spawn the ssh session and then answer the prompt automatically:

```
[root@ansible /]# ssh-expect deployer@secret-server echo Hello from the remote server
Warning: Permanently added 'secret-server,172.28.0.2' (RSA) to the list of known hosts.
deployer@secret-server's password: 
Welcome to our super secure server!
Why are you logging on to this lovely server? because I am deploying ansible
Hello from the remote server
Connection to secret-server closed.

```
My original thought was that I could rename `ssh` to `ssh-original`, name this script `ssh`, and have it call `ssh-original`, then ansible would execute through this script, which would wrap every command that happens.  Alas, it did not work.

In the `ssh-exec` script; ssh is executed with `spawn ssh -t -t {*}$arguments`.  Ansible calls ssh-exec with something like `-C /bin/sh -c 'some ansible command'`.  The problem is the `'` get stripped out when calling the shell script, thus breaking it.  For example, see: http://serverfault.com/questions/269592/bash-quotes-getting-stripped-when-a-command-is-passed-as-argument-to-a-function.  They need escaping, which ansible doesn't.

## What else?
Right now I don't have a working solution to use ansible, I can't see any way short of forking it and implementing the wrapping to do this.
