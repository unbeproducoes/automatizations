#!/bin/bash

echo "Preparando sua máquina..."
wait
echo "25% concluidos.."
wait
echo "50% concluidos.."
wait
echo "75% concluidos.."
wait
echo "100% concluidos.."
sleep 3

sudo apt update -y && sudo apt upgrade -y

echo "██████╗  █████╗  ██████╗██╗  ██╗ █████╗  ██████╗ ███████╗███████╗"
echo "██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██╔════╝ ██╔════╝██╔════╝"
echo "██████╔╝███████║██║     █████╔╝ ███████║██║  ███╗█████╗  ███████╗"
echo "██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══██║██║   ██║██╔══╝  ╚════██║"
echo "██║     ██║  ██║╚██████╗██║  ██╗██║  ██║╚██████╔╝███████╗███████║"
echo "╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝"

# Instalando aplicações importantes
download_list="curl git screen wget iptables-persistent openjdk-8-jre-headless htop ufw"

sudo apt install -y ${download_list}

# Instalando NodeJS
sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates && curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - && sudo apt -y install nodejs && sudo apt -y install gcc g++ make

echo " █████╗ ███╗   ██╗████████╗██╗██████╗ ██████╗  ██████╗ ███████╗"
echo "██╔══██╗████╗  ██║╚══██╔══╝██║██╔══██╗██╔══██╗██╔═══██╗██╔════╝"
echo "███████║██╔██╗ ██║   ██║   ██║██║  ██║██║  ██║██║   ██║███████╗"
echo "██╔══██║██║╚██╗██║   ██║   ██║██║  ██║██║  ██║██║   ██║╚════██║"
echo "██║  ██║██║ ╚████║   ██║   ██║██████╔╝██████╔╝╚██████╔╝███████║"
echo "╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝"

# Bloquear escaneamento de portas na rede

iptables -N SCANS
iptables -A SCANS -p tcp --tcp-flags FIN,URG,PSH FIN,URG,PSH -j DROP
iptables -A SCANS -p tcp --tcp-flags ALL ALL -j DROP
iptables -A SCANS -p tcp --tcp-flags ALL NONE -j DROP
iptables -A SCANS -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -f -j DROP
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p icmp -j DROP
 
# Bloquear conexões TCP inválidas

iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP  

# Bloquear pacotes inválidos

iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP 
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
 

# Proteger contra ataques SSH

iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP

# Limitar conexões ICMP

iptables -A INPUT -p icmp --icmp-type address-mask-request -j DROP
iptables -A INPUT -p icmp --icmp-type timestamp-request -j DROP
iptables -A INPUT -p icmp --icmp-type router-solicitation -j DROP
iptables -A INPUT -p icmp -m limit --limit 2/second -j ACCEPT

sudo /etc/init.d/iptables-persistent save
sleep 5

echo "██╗    ██╗██╗  ██╗██╗████████╗███████╗██╗     ██╗███████╗████████╗"
echo "██║    ██║██║  ██║██║╚══██╔══╝██╔════╝██║     ██║██╔════╝╚══██╔══╝"
echo "██║ █╗ ██║███████║██║   ██║   █████╗  ██║     ██║███████╗   ██║   "
echo "██║███╗██║██╔══██║██║   ██║   ██╔══╝  ██║     ██║╚════██║   ██║   "
echo "╚███╔███╔╝██║  ██║██║   ██║   ███████╗███████╗██║███████║   ██║   "
echo " ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝╚══════╝╚═╝╚══════╝   ╚═╝   "

# Colocar na lista branca os ips da cloudflare

# Coloque abaixo o endereço IP da sua máquina!
SERVER_IP=168.0.0.1

for i in $(curl "https://www.cloudflare.com/ips-v4"); do sudo iptables --permanent --zone=public --add-rich-rule 'rule family="ipv4" source address="'$i'" port port=80 protocol=tcp accept'; done
for i in $(curl "https://www.cloudflare.com/ips-v4"); do sudo iptables --permanent --zone=public --add-rich-rule 'rule family="ipv4" source address="'$i'" port port=443 protocol=tcp accept'; done

for i in $(curl "https://www.cloudflare.com/ips-v6"); do sudo iptables --permanent --zone=public --add-rich-rule 'rule family="ipv6" source address="'$i'" port port=80 protocol=tcp accept'; done
for i in $(curl "https://www.cloudflare.com/ips-v6"); do sudo iptables --permanent --zone=public --add-rich-rule 'rule family="ipv6" source address="'$i'" port port=443 protocol=tcp accept'; done

iptables --permanent --zone=public --add-rich-rule 'rule family="ipv4" source address="'${SERVER_IP}'" port port=22 protocol=tcp accept'
iptables --permanent --change-zone=eth0 --zone=public