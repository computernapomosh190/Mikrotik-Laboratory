# 2026-09-25 14:34:25 by RouterOS 7.21.5
# system id = u6ObE+nq5KB
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/routing id
add disabled=no id=1.1.1.1 name=ospf-id
/routing ospf instance
add disabled=no name=ospf-instance-1 redistribute=connected router-id=ospf-id
/routing ospf area
add disabled=no instance=ospf-instance-1 name=ospf-area-backbone
/ip address
add address=10.1.3.1/30 comment="Route to R3" interface=ether1 network=\
    10.1.3.0
add address=10.4.1.2/30 comment="Route to R4" interface=ether2 network=\
    10.4.1.0
add address=10.10.20.1/24 comment="Route to Terminal-A" interface=ether3 \
    network=10.10.20.0
add address=1.1.1.1 comment=" OSPF Router ID" interface=lo network=1.1.1.1
/ip dhcp-client
add interface=ether1
/routing ospf interface-template
add area=ospf-area-backbone interfaces=ether1
add area=ospf-area-backbone interfaces=ether2
add area=ospf-area-backbone interfaces=ether3 passive
/system identity
set name=R1
