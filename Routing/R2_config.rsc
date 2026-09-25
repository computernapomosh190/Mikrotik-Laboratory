
# 2026-09-25 14:35:46 by RouterOS 7.21.5
# system id = 5r00yVen15C
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no disabled=yes
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/routing id
add disabled=no id=2.2.2.2 name=ospf-id
/routing ospf instance
add disabled=no name=ospf-instance-1 redistribute=connected router-id=ospf-id
/routing ospf area
add disabled=no instance=ospf-instance-1 name=ospf-area-backbone
/routing table
add fib name=to_ISP1
add fib name=to_ISP2
/ip address
add address=10.5.2.2/30 comment="Route to R5" interface=ether2 network=\
    10.5.2.0
add address=192.168.10.1/24 comment="Route to Terminal-A" interface=ether3 \
    network=192.168.10.0
add address=2.2.2.2 comment=" OSPF Router ID" interface=lo network=2.2.2.2
add address=10.2.4.1/30 interface=ether1 network=10.2.4.0
/ip dhcp-client
# Interface not active
add interface=ether1
/ip firewall mangle
add action=mark-routing chain=prerouting comment="PBR: Terminal-A to ISP1" \
    new-routing-mark=to_ISP1 passthrough=no src-address=10.10.20.0/24
add action=mark-routing chain=output comment="PBR: System services to ISP2" \
    new-routing-mark=to_ISP2 passthrough=no
/ip route
add check-gateway=ping comment="Terminal-A: Main via R4" distance=1 \
    dst-address=0.0.0.0/0 gateway=10.2.4.2@main routing-table=to_ISP1
add check-gateway=ping comment="Terminal-A: Backup via R5" distance=2 \
    dst-address=0.0.0.0/0 gateway=10.5.2.1@main routing-table=to_ISP1
add check-gateway=ping comment="System: Main via R5" distance=1 dst-address=\
    0.0.0.0/0 gateway=10.5.2.1@main routing-table=to_ISP2
add check-gateway=ping comment="System: Backup via R4" distance=2 \
    dst-address=0.0.0.0/0 gateway=10.2.4.2@main routing-table=to_ISP2
/routing ospf interface-template
add area=ospf-area-backbone interfaces=ether1
add area=ospf-area-backbone interfaces=ether2
add area=ospf-area-backbone interfaces=ether3 passive
/system identity
set name=R2
