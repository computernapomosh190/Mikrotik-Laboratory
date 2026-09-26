
# 2026-09-26 14:30:22 by RouterOS 7.21.5
# system id = Il9j2PkbEoF
#
/interface bridge
add name=bridge-ap-guest
add name=bridge-main
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/interface vlan
add interface=ether2 name=vlan10-in vlan-id=10
/ip pool
add name=dhcp_pool0 ranges=192.168.88.2-192.168.88.254
add name=dhcp_pool1 ranges=192.168.10.2-192.168.10.254
/interface bridge port
add bridge=bridge-main interface=ether2
add bridge=bridge-ap-guest interface=vlan10-in
/ip address
add address=192.168.88.1/24 interface=bridge-main network=192.168.88.0
add address=192.168.10.1/24 interface=bridge-ap-guest network=192.168.10.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server
add address-pool=dhcp_pool0 interface=bridge-main name=dhcp1
add address-pool=dhcp_pool1 interface=bridge-ap-guest name=dhcp2
/ip dhcp-server network
add address=192.168.10.0/24 gateway=192.168.10.1
add address=192.168.88.0/24 gateway=192.168.88.1
/ip firewall filter
add action=drop chain=forward in-interface=bridge-ap-guest out-interface=\
    bridge-main
/system identity
set name=MikroTik-AP
