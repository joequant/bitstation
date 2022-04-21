#!/bin/bash
# adjust this to set the password

echo 'cubswin:)' | passwd user --stdin
echo 'cubswin:)' | passwd root --stdin

# configuration
# https://wiki.archlinux.org/title/JupyterHub
groupadd shadow
chgrp shadow /etc/shadow
chmod g+r /etc/shadow
usermod -aG shadow rhea

