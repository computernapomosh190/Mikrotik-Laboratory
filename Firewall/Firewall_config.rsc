
# 2026-09-25 16:14:42 by RouterOS 7.21.5
# system id = 5bEKKkKW47M
#
/interface bridge
add name=bridge1 vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/interface vlan
add interface=bridge1 name=vlan50 vlan-id=50
add interface=bridge1 name=vlan100 vlan-id=100
add interface=bridge1 name=vlan200 vlan-id=200
/interface list
add name=WAN
add name=LAN
/ip pool
add name=vlan_50 ranges=10.10.100.2-10.10.100.13
add name=vlan_100 ranges=10.10.100.18-10.10.100.29
add name=vlan_200 ranges=10.10.100.34-10.10.100.45
/routing table
add disabled=no fib name=to_VLAN50
add disabled=no fib name=to_VLAN100
add disabled=no fib name=to_VLAN200
/interface bridge port
add bridge=bridge1 interface=ether2 pvid=200
add bridge=bridge1 interface=ether3 pvid=100
add bridge=bridge1 interface=ether4 pvid=50
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface bridge vlan
add bridge=bridge1 tagged=bridge1 untagged=ether4 vlan-ids=50
add bridge=bridge1 tagged=bridge1 untagged=ether3 vlan-ids=100
add bridge=bridge1 tagged=bridge1 untagged=ether2 vlan-ids=200
/interface list member
add interface=ether1 list=WAN
add interface=ether2 list=LAN
add interface=ether3 list=LAN
add interface=ether4 list=LAN
/ip address
add address=10.10.100.17/28 interface=vlan100 network=10.10.100.16
add address=10.10.100.33/28 interface=vlan200 network=10.10.100.32
add address=10.10.100.1/28 interface=vlan50 network=10.10.100.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server
add address-pool=vlan_50 interface=vlan50 name=vlan50
add address-pool=vlan_100 interface=vlan100 name=vlan100
add address-pool=vlan_200 interface=vlan200 name=vlan200
/ip dhcp-server network
add address=10.10.100.0/28 dns-server=8.8.8.8 gateway=10.10.100.1 ntp-server=\
    192.168.1.6
add address=10.10.100.16/28 dns-server=8.8.8.8 gateway=10.10.100.17 \
    ntp-server=192.168.1.6
add address=10.10.100.32/28 dns-server=8.8.8.8 gateway=10.10.100.33 \
    ntp-server=192.168.1.6
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,8.8.4.4
/ip dns static
add address=127.0.0.1 name=mikrotik.com type=A
/ip firewall address-list
add address=10.10.100.1 list=GW
add address=10.10.100.17 list=GW
add address=10.10.100.33 list=GW
add address=10.10.100.17 list=VPCs
add address=10.10.100.33 list=VPCs
/ip firewall filter
add action=accept chain=input comment="Allow WinBox for Admin Only" dst-port=\
    8291 protocol=tcp src-address=10.10.100.18 src-address-list=""
add action=drop chain=input comment="Drop invalid connections" \
    connection-state=invalid
add action=reject chain=input comment="Denied access from vlan to Router" \
    connection-state=related,new dst-address=192.168.1.6 reject-with=\
    icmp-admin-prohibited
add action=accept chain=input comment="Allow related connections" \
    connection-state=related
add action=accept chain=input comment="Allow established connections" \
    connection-state=established
add action=accept chain=input comment="Allow icmp requests" protocol=icmp
add action=accept chain=input comment="Allow DNS" dst-port=53 protocol=udp
add action=accept chain=input comment="Allow Connect WinBox" dst-address=\
    192.168.1.6 dst-port=8291 protocol=tcp
add action=drop chain=input comment="Drop everything else"
add action=drop chain=forward comment="Drop invalid connections" \
    connection-state=invalid
add action=accept chain=forward comment="Allow Vlan to Internet" \
    connection-state="" out-interface=ether1
add action=accept chain=forward comment="Allow Vlan to SRV1" \
    connection-state="" dst-address=10.10.100.1 src-address-list=VPCs
add action=accept chain=forward comment=\
    "Allow already established connections" connection-state=established
add action=accept chain=forward comment="Allow related connections" \
    connection-state=related
add action=drop chain=forward comment="Drop everything else"
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1 src-address-list=""
add action=redirect chain=dstnat comment="Force intercept DNS requests" \
    dst-address-list=!GW dst-port=53 protocol=udp
/system clock
set time-zone-name=Europe/Kyiv
/system ntp client
set enabled=yes mode=multicast
/system ntp server
set enabled=yes
/system ntp client servers
add address=pool.ntp.org
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
