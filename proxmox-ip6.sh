#!/bin/bash

INTERFACE="vmbr0" # network interface
STATIC_SUFFIX="::100"  # static IPv6 suffix, change to whatever you like
NETMASK="/64"  # netmask
CONFIG_FILE="/etc/network/interfaces"  # network config
LOG_FILE="/var/log/ipv6_update.log"

# storing last known prefix
LAST_PREFIX=""

while true; do
 
 # checking the current IPv6 prefix of the interface, change 12 with the linenumber where the current prefix is stated in command output of rdisk in shell, mine is in line 12 of the output
 NEW_PREFIX=$(rdisc6 $INTERFACE | sed -n '12s/^[^:]*: *\([^ ]*\)::.*/\1/p' | cut -d ' ' -f1)

 # check if there is a new prefix
 if [[ -n "$NEW_PREFIX" && "$NEW_PREFIX" != "$LAST_PREFIX" ]]; then
  echo "$(date): Neues Präfix gefunden: $NEW_PREFIX" | tee -a $LOG_FILE
  LAST_PREFIX="$NEW_PREFIX"

  # adjust IPv6 with new prefix
  NEW_IPV6="$NEW_PREFIX$STATIC_SUFFIX$NETMASK"
  echo "$(date): Setze neue IPv6-Adresse: $NEW_IPV6" | tee -a $LOG_FILE
  sed -i "/iface $INTERFACE inet6 static/,/gateway/ s#address .*#address $NEW_IPV6#" $CONFIG_FILE
  ifreload -a
  fi
 sleep 600  # wait for ten minutes, change if you need other interval
done