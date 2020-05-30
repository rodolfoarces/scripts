#!/bin/bash

if [[ $(id -u) -ne 0 ]]
then 
	/usr/bin/echo "Please run as root or use sudo";
	exit 1;
fi

## Install tools
/usr/bin/apt-get update && /usr/bin/apt-get install curl wget elinks rsync git vim openssh-server openssh-client

## Check public key in place
SSH_DIR="/root/.ssh";
SSH_FILE="$SSH_DIR/authorized_keys"

if [[ -f "$SSH_FILE" ]]
then
	/usr/bin/echo "$SSH_FILE exists, checking content";
	CONTENT="rodolfo@laptop-hp";
	REMOTE_FILE="https://rodolfoarce.com/extra/llave.txt";
	TMP_FILE="/tmp/file.ssh.txt";
	if /usr/bin/grep -q $CONTENT $SSH_FILE
	then
		/usr/bin/echo "Content found, nothing to do";
	else
		/usr/bin/echo "Content not found, adding"
		/usr/bin/curl -q "$REMOTE_FILE" -o "$TMP_FILE";
		/usr/bin/tee $SSH_FILE < $TMP_FILE;
		/usr/bin/rm $TMP_FILE;
	fi
	/usr/bin/echo "Script finished"
fi

## Disable root password login
SSHD_CONFIG="/etc/ssh/sshd_config";
TMP_FILE="/tmp/sshd_config.tmp";
# Uncomment root login
/usr/bin/sed -i '/PermitRootLogin/s/^#//g' $SSHD_CONFIG;
# Change value for root login
/usr/bin/awk '!/#/ && /PermitRootLogin/{$NF="without-password"} 1' $SSHD_CONFIG > $TMP_FILE &&  /usr/bin/mv $TMP_FILE $SSHD_CONFIG


