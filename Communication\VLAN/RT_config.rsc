
# 2026-09-25 14:53:41 by RouterOS 7.21.5
# system id = l60Q8F48RgJ
#
/interface bridge
add name=bridge1
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
/interface list
add name=WAN-links
/interface bridge port
add bridge=bridge1 interface=ether4
add bridge=bridge1 interface=ether5
add bridge=bridge1 interface=ether3
add bridge=bridge1 interface=ether2
/interface list member
add interface=ether2 list=WAN-links
add interface=ether3 list=WAN-links
/ip address
add address=20.6.5.1/30 interface=ether1 network=20.6.5.0
add address=10.1.2.2/30 interface=ether2 network=10.1.2.0
add address=10.1.3.1/30 interface=ether3 network=10.1.3.0
/ip dhcp-client
add interface=ether1
/ip firewall nat
add action=masquerade chain=srcnat out-interface-list=WAN-links
/ip route
add distance=1 dst-address=0.0.0.0/0 gateway=10.1.2.1
add distance=2 dst-address=0.0.0.0/0 gateway=10.1.3.2
/system identity
set name=RT
