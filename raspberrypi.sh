#!/bin/bash

if [[ $(id -u) -ne 0 ]]
then
	echo "Please run as root or use sudo";
	exit 1;
fi

## Install tools
echo "Installing tools";
apt-get --yes --allow-unauthenticated update && apt-get --yes --allow-unauthenticated install curl wget elinks rsync git vim openssh-server openssh-client

## Start service and enabled it
systemctl start ssh;
systemctl enable ssh;

## Check public key in place
SSH_DIR="/root/.ssh";
SSH_FILE="$SSH_DIR/authorized_keys"
REMOTE_FILE="https://rodolfoarce.com/extra/llave.txt";
TMP_FILE="/tmp/file.ssh.txt";
CONTENT="rodolfo@laptop-hp";

echo "Installing ssh public key";
if [[ -f "$SSH_FILE" ]]
then
	echo "$SSH_FILE exists, checking content";
	if grep -q $CONTENT $SSH_FILE
	then
		echo "Content found, nothing to do";
	else
		echo "Content not found, adding"
		curl -q ${REMOTE_FILE} -o $TMP_FILE;
		tee $SSH_FILE < $TMP_FILE;

		echo "Cleaning up";
		rm $TMP_FILE;
	fi
else
	echo "No file, creating";
	mkdir $SSH_DIR && chmod 700 $SSH_DIR;
	curl -q "$REMOTE_FILE" -o "$SSH_FILE" && chmod 600 $SSH_FILE;

fi

## Disable root password login
echo "Changing root login policy in SSH";
SSHD_CONFIG="/etc/ssh/sshd_config";
TMP_FILE="/tmp/sshd_config.tmp";
# Change value for root login
## Remove commented and empty lines
sed -i '/^[[:blank:]]*#/d;s/#.*//' $SSHD_CONFIG;
sed -i '/^$/d' $SSHD_CONFIG;

## Change parameters
CONTENT="PermitRootLogin";
if ! grep -q "$CONTENT without-password" $SSHD_CONFIG
then 
	if grep -q "$CONTENT no" $SSHD_CONFIG ||  grep -q "$CONTENT yes" $SSHD_CONFIG 
	then 
		sed -i 's/.*PermitRootLogin.*/PermitRootLogin without-password/' $SSHD_CONFIG;
	else
		echo "PermitRootLogin without-password" >> $SSHD_CONFIG;
	fi
fi
echo "Script finished";


