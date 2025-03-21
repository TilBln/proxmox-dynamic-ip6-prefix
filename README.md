# proxmox-dynamic-ip6-prefix
### A simple script for ProxmoxVE checking the network interface for currently working global-scope ip6 prefix and automatically adjusting network config.

Every 10 minutes, the script reads the current ip6-prefix using rdisc6, then checks if it's a new one and in case it is, changes static ip6 in your 
```/etc/network/interfaces```

**How to use:**

- install ifupdown2 ```apt install ifupdown2```
- install ndisc6 ```apt install ndisc6```
- initialize static ip6 connection via Proxmox-GUI, or adjust your interfaces-file like this (for example if you are using network interface vmbr0):
```
auto vmbr0
iface vmbr0 inet6 static
  address xxxx:
  gateway xxxx::
```
a fitting address and the gateway address are stated in the output of rdisc6 vmbr0:
- add a suffix like 100 between :: and /64 of your prefix stated in the command output, that's your address
- in the last line of the command output, use the link-local address behind "from" (e.g. fe80::xxx) as your gateway

then do ```ifreload -a```


- wget the script
- adjust script with your used interface, suffix, etc.
- run script e.g. in a screen terminal
