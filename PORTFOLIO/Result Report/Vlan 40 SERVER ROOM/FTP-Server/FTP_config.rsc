# 2026-10-03 15:22:25 by RouterOS 7.21.5
# system id = IXORxlDJObD
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/ip dhcp-client
add interface=ether1
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.40.200 name=ftp.techspace.lab type=A
/ip firewall filter
add action=accept chain=input comment=\
    "Allow FTP access for internal networks" dst-port=21 protocol=tcp
/system identity
set name=ftp
