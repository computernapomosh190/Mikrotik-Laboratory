
# 2026-09-25 14:50:23 by RouterOS 7.21.5
# system id = 81YVY91uxYL
#
/interface bridge
add name=local-lan vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no
set [ find default-name=ether9 ] disable-running-check=no
set [ find default-name=ether10 ] disable-running-check=no
set [ find default-name=ether11 ] disable-running-check=no
set [ find default-name=ether12 ] disable-running-check=no
set [ find default-name=ether13 ] disable-running-check=no
set [ find default-name=ether14 ] disable-running-check=no
set [ find default-name=ether15 ] disable-running-check=no
/interface vlan
add interface=local-lan name=vlan10-interface vlan-id=10
add interface=local-lan name=vlan20-interface vlan-id=20
add interface=local-lan name=vlan30-interface vlan-id=30
/interface list
add name=WANs
/routing table
add fib name=to_VLAN10
add fib name=to_VLAN20
add fib name=to_VLAN30
/interface bridge port
add bridge=local-lan interface=ether3 pvid=10
add bridge=local-lan interface=ether4 pvid=10
add bridge=local-lan interface=ether5 pvid=20
add bridge=local-lan interface=ether6 pvid=20
add bridge=local-lan interface=ether7 pvid=30
add bridge=local-lan interface=ether8 pvid=30
/interface bridge vlan
add bridge=local-lan tagged=local-lan untagged=ether3,ether4 vlan-ids=10
add bridge=local-lan tagged=local-lan untagged=ether5,ether6 vlan-ids=20
add bridge=local-lan tagged=local-lan untagged=ether7,ether8 vlan-ids=30
/interface list member
add interface=ether1 list=WANs
add interface=ether2 list=WANs
/ip address
add address=10.10.10.1/24 interface=ether1 network=10.10.10.0
add address=10.10.20.2/24 interface=ether2 network=10.10.20.0
add address=192.168.10.1/24 interface=vlan10-interface network=192.168.10.0
add address=192.168.20.1/24 interface=vlan20-interface network=192.168.20.0
add address=192.168.30.1/24 interface=vlan30-interface network=192.168.30.0
/ip dhcp-client
add interface=ether1
add default-route-distance=2 interface=ether2
/ip dns static
add address=20.6.5.2 name=cisco.com type=A
/ip firewall address-list
add address=192.168.10.0/24 list=Local_Networks
add address=192.168.20.0/24 list=Local_Networks
add address=192.168.30.0/24 list=Local_Networks
/ip firewall filter
add action=accept chain=forward connection-state=established,related \
    dst-address=192.168.30.0/24 src-address=192.168.10.0/24
add action=drop chain=forward connection-state=new dst-address=\
    192.168.30.0/24 src-address=192.168.10.0/24
/ip firewall mangle
add action=mark-routing chain=prerouting dst-address-list=!Local_Networks \
    new-routing-mark=to_VLAN10 src-address=192.168.10.0/24
add action=mark-routing chain=prerouting dst-address-list=!Local_Networks \
    new-routing-mark=to_VLAN20 src-address=192.168.20.0/24
add action=mark-routing chain=prerouting dst-address-list=!Local_Networks \
    new-routing-mark=to_VLAN30 src-address=192.168.30.0/24
/ip firewall nat
add action=masquerade chain=srcnat comment="     Interface List" \
    out-interface-list=WANs
/ip route
add gateway=10.10.10.2 routing-table=to_VLAN10
add gateway=10.10.10.2 routing-table=to_VLAN20
add dst-address=0.0.0.0/0 gateway=10.10.10.2 routing-table=to_VLAN30
/system identity
set name=Gateway
