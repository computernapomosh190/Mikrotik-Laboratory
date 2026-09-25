# 2026-09-25 14:41:53 by RouterOS 7.21.5
# system id = cGkzN/+7deG
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/routing id
add disabled=no id=5.5.5.5 name=ospf-id
/routing ospf instance
add disabled=no name=ospf-instance-1 redistribute=connected router-id=ospf-id
/routing ospf area
add disabled=no instance=ospf-instance-1 name=ospf-area-backbone
/ip address
add address=10.3.5.2/30 comment="Route to R3" interface=ether2 network=\
    10.3.5.0
add address=10.5.2.1/30 comment="Route to R2" interface=ether1 network=\
    10.5.2.0
add address=5.5.5.5 comment=" OSPF Router ID" interface=lo network=5.5.5.5
/ip dhcp-client
add interface=ether1
/routing ospf interface-template
add area=ospf-area-backbone interfaces=ether1
add area=ospf-area-backbone interfaces=ether2
/system identity
set name=R5
