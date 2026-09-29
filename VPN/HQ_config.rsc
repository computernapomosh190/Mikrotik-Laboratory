# 2026-09-27 00:05:23 by RouterOS 7.21.5
# system id = W2pAo/mTgDB
#
/interface bridge
add name=Lan
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/interface l2tp-server
add name=l2tp-in1 user=user1
/interface wireguard
add listen-port=51820 mtu=1420 name=wg1
/ip pool
add name=pool-l2tp ranges=10.10.10.10-10.10.10.50
add name=dhcp_pool1 ranges=192.168.10.2-192.168.10.254
/ip dhcp-server
add address-pool=dhcp_pool1 interface=Lan name=dhcp1
/ppp profile
add change-tcp-mss=yes local-address=10.10.10.1 name=l2tp-srv remote-address=\
    pool-l2tp use-compression=no use-encryption=no use-mpls=no use-upnp=no
/interface bridge port
add bridge=Lan interface=ether2
add bridge=Lan interface=ether3
add bridge=Lan interface=ether4
/interface l2tp-server server
set authentication=chap,mschap2 default-profile=l2tp-srv enabled=yes \
    use-ipsec=yes
/interface wireguard peers
add allowed-address=10.20.20.2/32 client-allowed-address=::/0 interface=wg1 \
    name=Host public-key="dIJLqd7VZGqGnGYh96gFt+E102+hl23IuWloR1px6xM="
add allowed-address=10.20.20.3/32,192.168.20.0/24 client-allowed-address=::/0 \
    endpoint-address=192.168.1.7 endpoint-port=51820 interface=wg1 name=Office \
    public-key="P12AXB2X6t7hIrymj6zzcyDpx5Rd7tTHlmjKXB/OhF0="
/ip address
add address=192.168.10.1/24 interface=Lan network=192.168.10.0
add address=192.168.1.10/24 interface=ether1 network=192.168.1.0
add address=10.20.20.1/24 interface=wg1 network=10.20.20.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server network
add address=192.168.10.0/24 dns-server=8.8.8.8 gateway=192.168.10.1
/ip firewall filter
add action=accept chain=input comment="Allow L2TP" dst-port=1701 protocol=udp
add action=accept chain=input comment="Allow L2TP Subnet to Router" \
    src-address=10.10.10.0/24
add action=accept chain=input comment="Allow WireGuard" dst-port=51820 \
    protocol=udp
add action=accept chain=forward comment="Allow LAN-A to LAN-B" dst-address=\
    192.168.20.0/24 src-address=192.168.10.0/24
add action=accept chain=forward comment="Allow LAN-B to LAN-A" dst-address=\
    192.168.10.0/24 src-address=192.168.20.0/24
add action=accept chain=forward comment="Allow WG to LAN" in-interface=wg1 \
    out-interface=Lan
add action=accept chain=forward comment="Allow WG to LAN" in-interface=wg1 \
    out-interface=Lan
add action=accept chain=forward comment="Allow LAN to WG" in-interface=Lan \
    out-interface=wg1
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip route
add comment=L2TP disabled=no distance=1 dst-address=192.168.20.0/24 gateway=\
    <l2tp-user1> routing-table=main scope=30 target-scope=10
add comment=WireGuard disabled=no distance=10 dst-address=192.168.20.0/24 \
    gateway=wg1 routing-table=main scope=30 target-scope=10
/ppp secret
add local-address=10.10.10.1 name=user1 profile=l2tp-srv remote-address=\
    10.10.10.2 service=l2tp
/system identity
set name=MikroTik-HQ
