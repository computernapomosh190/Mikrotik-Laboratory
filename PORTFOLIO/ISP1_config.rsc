
# 2026-10-03 14:41:51 by RouterOS 7.21.5
# system id = 443FJsnTgTM
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/ip pool
add name=dhcp_pool0 ranges=10.10.100.2-10.10.100.254
add name=dhcp_pool_new ranges=10.10.100.2-10.10.100.254
/ip dhcp-server
add address-pool=dhcp_pool_new interface=ether2 name=dhcp1
/ip address
add address=10.10.100.1/24 interface=ether2 network=10.10.100.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server network
add address=10.10.100.0/24 dns-server=8.8.8.8 gateway=10.10.100.1
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat comment="Allow Internet for HQ" \
    out-interface=ether1
add action=dst-nat chain=dstnat comment="Forward WireGuard to HQ" dst-port=\
    13231 protocol=udp to-addresses=10.10.100.254 to-ports=13231
/ip route
add dst-address=192.168.2.0/24 gateway=192.168.1.1
/ip service
set ftp disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/system identity
set name=ISP1
/tool romon
set enabled=yes
