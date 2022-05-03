#!/bin/bash
# adjust this to set the password

echo 'password' | passwd user --stdin
echo 'password' | passwd root --stdin

# configuration
# https://wiki.archlinux.org/title/JupyterHub
groupadd shadow
chgrp shadow /etc/shadow
chmod g+r /etc/shadow
usermod -aG shadow rhea

