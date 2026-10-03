
# 2026-10-03 14:43:23 by RouterOS 7.21.5
# system id = WY7ufW/qegK
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/ip pool
add name=dhcp_pool0 ranges=10.20.200.2-10.20.200.254
/ip dhcp-server
add address-pool=dhcp_pool0 interface=ether2 name=dhcp1
/ip address
add address=10.20.200.1/24 interface=ether2 network=10.20.200.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server network
add address=10.10.100.0/24 dns-server=8.8.8.8 gateway=10.10.100.1
add address=10.20.200.0/24 dns-server=8.8.8.8 gateway=10.20.200.1
/ip firewall nat
add action=masquerade chain=srcnat comment="Allow Internet for HQ" \
    out-interface=ether1
/ip route
add dst-address=192.168.1.0/24 gateway=192.168.1.1
/ip service
set ftp disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/system identity
set name=ISP2
/tool romon
set enabled=yes
