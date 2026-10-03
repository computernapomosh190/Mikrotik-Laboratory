# 2026-10-03 14:37:52 by RouterOS 7.21.5
# system id = 5+okAMoe4YC
#
/interface bridge
add name=sw vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no name=ether2
set [ find default-name=ether2 ] disable-running-check=no name=ether3
set [ find default-name=ether3 ] disable-running-check=no name=ether4
set [ find default-name=ether4 ] disable-running-check=no name=ether5
set [ find default-name=ether5 ] disable-running-check=no name=ether6
set [ find default-name=ether6 ] disable-running-check=no name=ether7
set [ find default-name=ether7 ] disable-running-check=no name=ether8
set [ find default-name=ether8 ] disable-running-check=no name=ether9
set [ find default-name=ether9 ] disable-running-check=no name=ether10
set [ find default-name=ether10 ] disable-running-check=no name=ether11
set [ find default-name=ether11 ] disable-running-check=no name=ether12
set [ find default-name=ether12 ] disable-running-check=no name=ether13
set [ find default-name=ether13 ] disable-running-check=no name=ether14
set [ find default-name=ether14 ] disable-running-check=no name=ether15
set [ find default-name=ether15 ] disable-running-check=no name=ether16
set [ find default-name=ether16 ] disable-running-check=no name=ether17
set [ find default-name=ether17 ] disable-running-check=no name=ether18
set [ find default-name=ether18 ] disable-running-check=no name=ether19
set [ find default-name=ether19 ] disable-running-check=no name=ether20
set [ find default-name=ether20 ] disable-running-check=no name=ether21
set [ find default-name=ether21 ] disable-running-check=no name=ether22
set [ find default-name=ether22 ] disable-running-check=no name=ether23
set [ find default-name=ether23 ] disable-running-check=no name=ether24
set [ find default-name=ether24 ] disable-running-check=no name=ether25
/interface vlan
add interface=sw name=vlan10 vlan-id=10
add interface=sw name=vlan30 vlan-id=30
add interface=sw name=vlan40 vlan-id=40
/interface list
add name=LAN
/queue type
add kind=pcq name=download_corp pcq-classifier=dst-address
add kind=pcq name=upload_corp pcq-classifier=src-address
/queue simple
add name=VLAN10-Corporate-PCQ queue=download_corp/upload_corp target=vlan10
/interface bridge port
add bridge=sw interface=ether3 pvid=30
add bridge=sw interface=ether4 pvid=30
add bridge=sw interface=ether5 pvid=30
add bridge=sw interface=ether6 pvid=30
add bridge=sw interface=ether7 pvid=10
add bridge=sw interface=ether8 pvid=10
add bridge=sw interface=ether9 pvid=10
add bridge=sw interface=ether10 pvid=10
add bridge=sw interface=ether11 pvid=40
add bridge=sw interface=ether12 pvid=40
add bridge=sw interface=ether13 pvid=40
add bridge=sw interface=ether14 pvid=40
add bridge=sw interface=ether15
add bridge=sw interface=ether2
/interface bridge vlan
add bridge=sw tagged=sw,ether2 untagged=ether9,ether8,ether7,ether10 \
    vlan-ids=10
add bridge=sw tagged=sw,ether2 untagged=ether3,ether4,ether5,ether6 vlan-ids=\
    30
add bridge=sw tagged=sw,ether2 untagged=ether12,ether13,ether14,ether15 \
    vlan-ids=40
/interface list member
add interface=sw list=LAN
/ip address
add address=192.168.30.2/24 interface=vlan30 network=192.168.30.0
/ip dhcp-server network
add address=192.168.10.0/24 dns-server=31.43.43.143,8.8.8.8 gateway=\
    192.168.10.1
add address=192.168.30.0/24 dns-server=31.43.43.143,8.8.8.8 gateway=\
    192.168.30.1
add address=192.168.40.0/24 dns-server=31.43.43.143,8.8.8.8 gateway=\
    192.168.40.1
/ip dns
set allow-remote-requests=yes servers=192.168.30.1
/ip firewall address-list
add address=192.168.30.0/24 list=to_SRV
add address=192.168.10.0/24 list=to_SRV
add address=192.168.30.0/24 list=Deny_to_WinBox
add address=192.168.40.0/24 list=Deny_to_WinBox
/ip route
add comment="Gateway to HQ Router" dst-address=0.0.0.0/0 gateway=192.168.30.1
/system identity
set name=SW-HQ
/tool romon
set enabled=yes
