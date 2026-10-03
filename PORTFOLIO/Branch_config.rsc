
# 2026-10-03 14:46:31 by RouterOS 7.21.5
# system id = KanayMZb38G
#
/interface bridge
add name=Wi-Fi vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
/interface wireguard
add listen-port=13231 mtu=1360 name=wg1
/interface vlan
add interface=Wi-Fi name=WLAN vlan-id=20
/ip pool
add name=dhcp_pool0 ranges=192.168.20.2-192.168.20.254
/routing id
add disabled=no id=2.2.2.2 name=ospf-id
/routing ospf instance
add disabled=no name=ospf-instance-1 redistribute="" router-id=2.2.2.2
/routing ospf area
add disabled=no instance=ospf-instance-1 name=ospf-area-1
/interface bridge port
add bridge=Wi-Fi interface=ether2 pvid=20
add bridge=Wi-Fi interface=ether3 pvid=20
add bridge=Wi-Fi interface=ether4 pvid=20
add bridge=Wi-Fi interface=ether5 pvid=20
/interface bridge vlan
add bridge=Wi-Fi tagged=Wi-Fi untagged=ether2,ether3,ether4,ether5 vlan-ids=\
    20
/interface wireguard peers
add allowed-address=0.0.0.0/0 client-allowed-address=::/0 endpoint-address=\
    192.168.1.6 endpoint-port=13231 interface=wg1 name=peer2 public-key=\
    "pibtdP2JdBHhtz/7ugGLVmOSYakwDGjkmeeikCNsl04="
/ip address
add address=192.168.20.1/24 interface=WLAN network=192.168.20.0
add address=2.2.2.2/30 interface=lo network=2.2.2.0
add address=10.10.10.2/30 interface=wg1 network=10.10.10.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server
add address-pool=dhcp_pool0 interface=WLAN name=dhcp1
/ip dhcp-server network
add address=192.168.20.0/24 dns-server=8.8.8.8 gateway=192.168.20.1
/ip firewall filter
add action=accept chain=input dst-port=13231 protocol=udp
add action=accept chain=input comment="Allow Winbox only IT" dst-address=\
    192.168.1.8 dst-port=8291 protocol=tcp src-address=192.168.10.0/24
add action=accept chain=input comment="Allow SSH only IT" dst-address=\
    192.168.1.8 dst-port=22 protocol=tcp src-address=192.168.10.0/24
add action=drop chain=forward comment="Drop Invalid packets" \
    connection-state=invalid protocol=tcp
add action=reject chain=forward comment="Deny access to other networks" \
    connection-state=new dst-address-list="Other Network" reject-with=\
    icmp-network-unreachable src-address=192.168.20.0/24
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip route
add comment="Route to HQ VLAN 10" disabled=no dst-address=192.168.10.0/24 \
    gateway=wg1 routing-table=main
add comment="Route to HQ VLAN 30" disabled=no distance=1 dst-address=\
    192.168.30.0/24 gateway=wg1 routing-table=main scope=30 target-scope=10
add comment="Route to HQ VLAN 40" disabled=no distance=1 dst-address=\
    192.168.40.0/24 gateway=wg1 routing-table=main scope=30 target-scope=10
/ip service
set ftp disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/routing ospf interface-template
add area=ospf-area-1 disabled=no interfaces=wg1 type=ptp
add area=ospf-area-1 disabled=no interfaces=WLAN passive
/system identity
set name=MikroTik-Branch
/tool romon
set enabled=yes
