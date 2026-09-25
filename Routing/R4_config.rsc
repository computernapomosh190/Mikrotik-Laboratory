# 2026-09-25 14:39:23 by RouterOS 7.21.5
# system id = t9ydJeZGLBC
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/routing id
add disabled=no id=4.4.4.4 name=ospf-id
/routing ospf instance
add disabled=no name=ospf-instance-1 redistribute=connected router-id=ospf-id
/routing ospf area
add disabled=no instance=ospf-instance-1 name=ospf-area-backbone
/ip address
add address=10.4.1.1/30 comment="Route to R1" interface=ether1 network=\
    10.4.1.0
add address=10.2.4.2/30 comment="Route to R2" interface=ether2 network=\
    10.2.4.0
add address=4.4.4.4 comment=" OSPF Router ID" interface=lo network=4.4.4.4
/ip dhcp-client
add interface=ether1
/routing ospf interface-template
add area=ospf-area-backbone interfaces=ether1
add area=ospf-area-backbone interfaces=ether2
/system identity
set name=R4
