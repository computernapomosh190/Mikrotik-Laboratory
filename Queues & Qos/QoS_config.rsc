
# 2026-09-25 15:05:58 by RouterOS 7.21.5
# system id = U3CnLXeSgbF
#
/interface bridge
add name=LAN vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no
/interface vlan
add interface=LAN name=Vlan88-interface vlan-id=88
add interface=LAN name=Vlan89-interface vlan-id=89
/ip pool
add name=Guest ranges=192.168.89.2-192.168.89.30
add name=LAN ranges=192.168.88.2-192.168.88.30
/queue simple
add max-limit=5/10 name=Guest target=192.168.89.10/32
/queue type
add kind=pcq name=PCQ_Upload pcq-classifier=src-address
add kind=pcq name=PCQ_Download pcq-classifier=dst-address
/queue simple
add burst-limit=50M/50M burst-threshold=15M/15M burst-time=10s/10s max-limit=\
    20M/20M name=LAN queue=PCQ_Upload/PCQ_Download target=192.168.88.0/24
/queue tree
add max-limit=100 name=Total_Upload parent=global queue=PCQ_Upload
add max-limit=100 name=Total_Download parent=global queue=PCQ_Download
/routing table
add disabled=no fib name=to_Vlan88
add disabled=no fib name=to_Vlan89
/interface bridge port
add bridge=LAN interface=ether2 pvid=89
add bridge=LAN interface=ether6 pvid=88
add bridge=LAN interface=ether5 pvid=88
add bridge=LAN interface=ether4 pvid=88
add bridge=LAN interface=ether3 pvid=88
/interface bridge vlan
add bridge=LAN tagged=LAN untagged=ether2 vlan-ids=89
add bridge=LAN tagged=LAN untagged=ether3,ether4,ether5,ether6 vlan-ids=88
/ip address
add address=192.168.87.1/24 interface=ether1 network=192.168.87.0
add address=192.168.89.1/24 interface=Vlan89-interface network=192.168.89.0
add address=192.168.88.1/24 interface=Vlan88-interface network=192.168.88.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server
add address-pool=Guest interface=Vlan89-interface name=guest
add address-pool=LAN interface=Vlan88-interface name=LAN
/ip dhcp-server network
add address=192.168.88.0/24 dns-server=8.8.8.8 gateway=192.168.88.1
add address=192.168.89.0/24 dns-server=8.8.8.8 gateway=192.168.89.1
/ip route
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=ether1 \
    routing-table=to_Vlan88 scope=30 target-scope=10
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=ether1 \
    routing-table=to_Vlan89 scope=30 target-scope=10
