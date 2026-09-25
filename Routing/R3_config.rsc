
# 2026-09-25 14:37:36 by RouterOS 7.21.5
# system id = k/5eAgjHXtE
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/routing id
add disabled=no id=3.3.3.3 name=ospf-id
/routing ospf instance
add disabled=no name=ospf-instance-1 redistribute=connected router-id=ospf-id
/routing ospf area
add disabled=no instance=ospf-instance-1 name=ospf-area-backbone
/ip address
add address=10.1.3.2/30 comment="Route to R1" interface=ether2 network=\
    10.1.3.0
add address=10.3.5.1/30 comment="Route to R5" interface=ether1 network=\
    10.3.5.0
add address=3.3.3.3 comment=" OSPF Router ID" interface=lo network=3.3.3.3
/ip dhcp-client
add interface=ether1
/routing ospf interface-template
add area=ospf-area-backbone interfaces=ether1
add area=ospf-area-backbone interfaces=ether2
/system identity
set name=R3
