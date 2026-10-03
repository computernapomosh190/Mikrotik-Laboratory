# 2026-10-03 14:44:44 by RouterOS 7.21.5
# system id = IWDpeZah14B
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
/interface wireguard
add listen-port=13231 mtu=1360 name=wg1
/interface vlan
add interface=ether3 name=VLAN10-Corp vlan-id=10
add interface=ether3 name=VLAN30-Admin vlan-id=30
add interface=ether3 name=VLAN40-Servers vlan-id=40
/interface list
add name=LAN
/ip pool
add name=dhcp_pool0 ranges=192.168.3.2-192.168.3.254
add name=pool_vlan10 ranges=192.168.10.100-192.168.10.200
add name=pool_vlan30 ranges=192.168.30.100-192.168.30.200
add name=pool_vlan40 ranges=192.168.40.100-192.168.40.200
/ip dhcp-server
add address-pool=dhcp_pool0 interface=ether3 name=dhcp1
add address-pool=pool_vlan10 interface=VLAN10-Corp name=dhcp_vlan10
add address-pool=pool_vlan30 interface=VLAN30-Admin name=dhcp_vlan30
add address-pool=pool_vlan40 interface=VLAN40-Servers name=dhcp_vlan40
/queue type
add kind=pcq name=download_corp pcq-classifier=dst-address
add kind=pcq name=upload_corp pcq-classifier=src-address
/queue simple
add name=VLAN10-Corporate-PCQ queue=download_corp/upload_corp target=\
    192.168.10.0/24
/routing id
add disabled=no id=1.1.1.1 name=ospf-id
/routing ospf instance
add disabled=no name=ospf-instance-1 redistribute="" router-id=1.1.1.1
/routing ospf area
add disabled=no instance=ospf-instance-1 name=ospf-area-1
/routing table
add disabled=no fib name=to_ISP1
add disabled=no fib name=to_ISP2
add disabled=no fib name=to_VLAN10
add disabled=no fib name=to_VLAN30
add disabled=no fib name=to_VLAN40
/interface list member
add interface=VLAN10-Corp list=LAN
/interface wireguard peers
add allowed-address=0.0.0.0/0 client-allowed-address=::/0 endpoint-address=\
    192.168.1.4 endpoint-port=13231 interface=wg1 name=peer1 public-key=\
    "1tYBhhP2gJVRF+PWUW1q+odVjia14kxtAzjCQvAQFxY="
/ip address
add address=192.168.3.1/24 interface=ether3 network=192.168.3.0
add address=10.10.10.1/30 interface=wg1 network=10.10.10.0
add address=192.168.10.1/24 interface=VLAN10-Corp network=192.168.10.0
add address=192.168.30.1/24 interface=VLAN30-Admin network=192.168.30.0
add address=192.168.40.1/24 interface=VLAN40-Servers network=192.168.40.0
/ip dhcp-client
add interface=ether1
add interface=ether2
/ip dhcp-server lease
add address=192.168.40.200 client-id=1:50:26:ec:0:53:0 mac-address=\
    50:26:EC:00:53:00 server=dhcp_vlan40
/ip dhcp-server network
add address=192.168.3.0/24 gateway=192.168.3.1
add address=192.168.10.0/24 dns-server=8.8.8.8,192.168.10.1 gateway=\
    192.168.10.1
add address=192.168.30.0/24 dns-server=8.8.8.8,192.168.30.1 gateway=\
    192.168.30.1
add address=192.168.40.0/24 dns-server=8.8.8.8,192.168.40.1 gateway=\
    192.168.40.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8
/ip dns static
add address=192.168.40.200 comment="Real FTP Server IP" name=\
    ftp.techspace.lab type=A
/ip firewall address-list
add address=192.168.0.0/16 list=LOCAL_NETWORKS
add address=192.168.30.0/24 list=Drop_WinBox
add address=192.168.40.0/24 list=Drop_WinBox
add address=192.168.10.0/24 list=Local_Networks
add address=192.168.30.0/24 list=Local_Networks
add address=192.168.40.0/24 list=Local_Networks
add address=10.10.10.0/30 list=Local_Networks
add address=192.168.10.0/24 list=SRV
add address=192.168.30.0/24 list=SRV
add address=192.168.10.1 list=from_Vlan10
add address=192.168.30.1 list=from_Vlan30
add address=192.168.40.1 list=from_Vlan40
add address=192.168.10.1 list=from_Vlan
add address=192.168.30.1 list=from_Vlan
add address=192.168.40.1 list=from_Vlan
/ip firewall filter
add action=accept chain=input comment="Allow DNS requests from LAN" dst-port=\
    53 protocol=udp
add action=accept chain=input comment="Allow DNS requests from LAN" dst-port=\
    53 protocol=tcp
add action=accept chain=input comment=\
    "Failsafe: Allow DNS for ALL internal VLANs" dst-port=53 protocol=udp
add action=accept chain=input comment=\
    "Failsafe: Allow DNS for ALL internal VLANs" dst-port=53 protocol=tcp
add action=reject chain=forward comment="Deny access from Vlan 30 to Vlan 10" \
    connection-state=new dst-address=192.168.10.0/24 reject-with=\
    icmp-host-unreachable src-address=192.168.30.0/24
add action=accept chain=forward dst-port=13231 protocol=udp
add action=accept chain=forward comment="Allow to SRV from Vlan 10,30" \
    dst-address=192.168.40.0/24 src-address-list=SRV
add action=accept chain=input comment="Allow WireGuard UDP Input" disabled=\
    yes dst-port=43035 protocol=udp
add action=drop chain=input comment="DROP Invalid packets" connection-state=\
    invalid protocol=tcp
add action=reject chain=input comment="Allow WinBox ONLY for IT" \
    connection-nat-state="" connection-state=new dst-port=8291 protocol=tcp \
    reject-with=tcp-reset src-address=!192.168.10.0/24
add action=reject chain=input comment="Allow SSH ONLY for IT" \
    connection-nat-state="" connection-state=new dst-port=22 protocol=tcp \
    reject-with=tcp-reset src-address=!192.168.10.0/24
add action=drop chain=forward comment=\
    "Block VLAN 20 access to Web-Server HTTP" dst-address=192.168.40.10 \
    dst-port=80 protocol=tcp src-address=192.168.20.0/24
add chain=forward
add chain=forward comment="Allow IT to SSH Web-Srv" dst-address=192.168.40.10 \
    dst-port=22 protocol=tcp src-address=192.168.10.0/24
/ip firewall mangle
add action=accept chain=prerouting comment=\
    "Failsafe: Accept local DNS requests" dst-address=192.168.30.2
add action=accept chain=prerouting comment=\
    "Failsafe: Direct route to Server VLAN" dst-address=192.168.40.0/24
add action=accept chain=prerouting dst-address=10.10.10.0/30
add action=mark-routing chain=prerouting comment="PBR: IT VLAN to ISP1" \
    dst-address-list=!LOCAL_NETWORKS new-routing-mark=to_ISP2 passthrough=no \
    src-address=192.168.10.0/24
add action=mark-routing chain=prerouting comment="PBR: Servers VLAN to ISP2" \
    dst-address-list=!LOCAL_NETWORKS new-routing-mark=to_ISP2 passthrough=no \
    src-address=192.168.40.0/24
add action=mark-routing chain=prerouting comment="PBR: Guest VLAN to ISP2" \
    dst-address-list=!LOCAL_NETWORKS new-routing-mark=to_ISP1 passthrough=no \
    src-address=192.168.20.0/24
add action=mark-routing chain=prerouting comment="PBR: Admin VLAN to ISP1" \
    dst-address-list=!LOCAL_NETWORKS new-routing-mark=to_ISP1 passthrough=no \
    src-address=192.168.30.0/24
add action=mark-routing chain=prerouting comment="Mark to PBR_Vlan10" \
    dst-address-list=!Local_Networks new-routing-mark=to_VLAN10 src-address=\
    192.168.10.0/24
add action=mark-routing chain=prerouting comment="Mark to PBR_Vlan40" \
    dst-address-list=!Local_Networks new-routing-mark=to_VLAN40 src-address=\
    192.168.40.0/24
add action=mark-routing chain=prerouting comment="Mark to PBR_Vlan30" \
    dst-address-list=!Local_Networks new-routing-mark=to_VLAN30 src-address=\
    192.168.30.0/24
/ip firewall nat
add action=masquerade chain=srcnat comment="NAT for ISP1" out-interface=\
    ether1
add action=masquerade chain=srcnat comment="NAT for ISP2" out-interface=\
    ether2
add action=redirect chain=dstnat comment="Force intercept DNS requests" \
    dst-address-list=!from_Vlan dst-port=53 protocol=udp
add action=dst-nat chain=dstnat comment="HTTP from Internet VPS to OpenWrt" \
    dst-port=8080 protocol=tcp to-addresses=192.168.40.10 to-ports=80
/ip firewall raw
add action=drop chain=prerouting dst-port=53 protocol=tcp src-address-list=\
    !LOCAL_NETWORKS
add action=drop chain=prerouting dst-port=53 protocol=udp src-address-list=\
    !LOCAL_NETWORKS
/ip route
add check-gateway=ping comment=Main_Via_ISP1 disabled=no distance=1 \
    dst-address=0.0.0.0/0 gateway=10.10.100.1 routing-table=to_ISP1 scope=30 \
    target-scope=10
add check-gateway=ping comment="Backup via ISP2" disabled=no distance=2 \
    dst-address=0.0.0.0/0 gateway=10.20.200.1 routing-table=to_ISP1 scope=30 \
    target-scope=10
add check-gateway=ping comment=System:Main_Via_ISP1 disabled=no distance=1 \
    dst-address=0.0.0.0/0 gateway=10.10.100.1 routing-table=to_ISP2 scope=30 \
    target-scope=10
add check-gateway=ping comment=System:Backup_Via_ISP2 disabled=no distance=2 \
    dst-address=0.0.0.0/0 gateway=10.20.200.1 routing-table=to_ISP2 scope=30 \
    target-scope=10
add disabled=no dst-address=0.0.0.0/0 gateway=192.168.1.3 routing-table=\
    to_VLAN10
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=192.168.1.3 \
    routing-table=to_VLAN30 scope=30 target-scope=10
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=192.168.1.3 \
    routing-table=to_VLAN40 scope=30 target-scope=10
add disabled=no dst-address=10.10.10.2/32 gateway=wg1
add comment="Forced Route to Branch" disabled=no dst-address=192.168.20.0/24 \
    gateway=wg1
/ip service
set ftp disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/routing ospf interface-template
add area=ospf-area-1 disabled=no interfaces=wg1 type=ptp
add area=ospf-area-1 disabled=no interfaces=VLAN10-Corp passive
add area=ospf-area-1 disabled=no interfaces=VLAN40-Servers passive
add area=ospf-area-1 disabled=no interfaces=VLAN30-Admin passive
/system identity
set name=Mikrotik-HQ
/tool mac-server mac-winbox
set allowed-interface-list=LAN
/tool romon
set enabled=yes
