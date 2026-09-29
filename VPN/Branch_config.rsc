# 2026-09-27 00:06:54 by RouterOS 7.21.5
# system id = gd1oaT+1SyK
#
/interface bridge
add name=Lan
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/interface l2tp-client
add connect-to=192.168.1.10 disabled=no name=l2tp-out1 use-ipsec=yes user=user1
/interface wireguard
add disabled=yes listen-port=51820 mtu=1420 name=wg1
/ip pool
add name=dhcp_pool0 ranges=192.168.20.2-192.168.20.254
/ip dhcp-server
add address-pool=dhcp_pool0 interface=Lan name=dhcp1
/interface bridge port
add bridge=Lan interface=ether2
add bridge=Lan interface=ether3
add bridge=Lan interface=ether4
/interface wireguard peers
add allowed-address=10.20.20.0/24,192.168.10.0/24 client-allowed-address=::/0 endpoint-address=192.168.1.10 endpoint-port=51820 interface=wg1 name=peer1 \
    persistent-keepalive=25s public-key="KNUJFuDGaT4Sh8QzZMQXuVNQ4enymf8P186GAyg75wo="
/ip address
add address=192.168.20.1/24 interface=Lan network=192.168.20.0
add address=192.168.1.20/24 interface=ether1 network=192.168.1.0
add address=10.20.20.3/24 interface=wg1 network=10.20.20.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server network
add address=192.168.20.0/24 dns-server=8.8.8.8 gateway=192.168.20.1
/ip route
add dst-address=192.168.1.0/24 gateway=192.168.1.1
add comment=L2TP disabled=no distance=1 dst-address=192.168.10.0/24 gateway=l2tp-out1 routing-table=main scope=30 target-scope=10
add comment=WireGuard disabled=no distance=10 dst-address=192.168.10.0/24 gateway=wg1 routing-table=main scope=30 target-scope=10
/system identity
set name=MikroTik-Branch
