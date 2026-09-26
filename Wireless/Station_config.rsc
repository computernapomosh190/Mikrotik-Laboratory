# 2026-09-26 14:32:18 by RouterOS 7.21.5
# system id = F67z/aGbKBA
#
/interface bridge
add name=bridge-guest
add name=bridge-local
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
/interface vlan
add interface=ether2 name=vlan10-guest vlan-id=10
/interface bridge port
add bridge=bridge-local interface=ether2
add bridge=bridge-local interface=ether3
add bridge=bridge-guest interface=ether4
add bridge=bridge-local interface=ether5
add bridge=bridge-guest interface=ether6
add bridge=bridge-guest interface=vlan10-guest
/ip address
add address=192.168.88.2/24 interface=bridge-local network=192.168.88.0
/ip dhcp-client
add interface=ether1
/system identity
set name=MikroTik-Station
