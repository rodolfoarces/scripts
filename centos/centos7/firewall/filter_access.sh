#!/bin/bash

IFACE="eth0"
IPT="echo /usr/sbin/iptables"

# PostgreSQL
PORT="5432"
PORT_COMMAND="-p tcp --destination-port ${PORT}"
FILE="${PORT}.acl"
{ while IFS=';' read  IP MAC FAKE
    do
        # Load IP if present
        if [[ -z ${IP} ]];
        then
            SRC_COMMAND=""
        else
            SRC_COMMAND="-s ${IP}"
        fi
        # Load MAC if present
        if [[ -z $MAC ]] 
        then
            MAC_COMMAND=""
        else
            MAC_COMMAND="-m mac --mac-source ${MAC}"
        fi
        # Aditional parameters
        if [[ -z ${FAKE} ]] 
        then
            EXTRA_COMMAND=""
        else
            EXTRA_COMMAND=${FAKE}
        fi
        ${IPT} -A INPUT ${PORT_COMMAND} ${SRC_COMMAND} ${MAC_COMMAND} ${EXTRA_COMMAND} -j ACCEPT
    done 
} < $FILE
# Rule after adding ACL
${IPT} -A INPUT ${PORT_COMMAND} -j REJECT

## Example
#IP;MAC;extra
