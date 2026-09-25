
# 2026-09-25 14:52:51 by RouterOS 7.21.5
# system id = hdBCIsH6snN
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/ip pool
add name=LAN-pool ranges=10.10.20.2-10.10.20.20
/ip address
add address=10.10.20.1/24 interface=ether1 network=10.10.20.0
add address=10.1.2.1/30 interface=ether1 network=10.1.2.0
add address=10.1.3.2/30 interface=ether2 network=10.1.3.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server
add address-pool=LAN-pool interface=ether1 name=dhcp-LAN
/ip dhcp-server network
add address=10.10.20.0/24 dns-server=10.10.20.1 gateway=10.10.20.1
/ip route
add dst-address=10.1.2.0/30 gateway=10.1.2.2
add dst-address=10.1.3.0/30 gateway=10.1.3.1
add dst-address=10.1.3.0/30 gateway=10.1.3.1
add dst-address=20.6.5.0/30 gateway=10.1.3.1 routing-table=main
/system identity
set name=ISP2
