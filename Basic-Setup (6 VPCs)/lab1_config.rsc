# 2026-09-25 14:24:48 by RouterOS 7.21.5
# system id = pHH+vb/CmMD
#
/interface bridge
add name=lan
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
/ip pool
add name=lan ranges=192.168.10.2-192.168.10.254
/ip dhcp-server
add address-pool=lan interface=lan name=dhcp-lan
/interface bridge port
add bridge=lan interface=ether2
add bridge=lan interface=ether3
add bridge=lan interface=ether4
add bridge=lan interface=ether5
/ip address
add address=192.168.10.1/24 interface=lan network=192.168.10.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server network
add address=192.168.10.0/24 dns-server=8.8.8.8 gateway=192.168.10.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,8.8.4.4
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
