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
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
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

# Limitar pacotes RST

iptables -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT
iptables -A INPUT -p tcp --tcp-flags RST RST -j DROP

# Desativar log do pacote de tipo SYN

sysctl -w net/netfilter/nf_conntrack_tcp_loose=0

# Tornando as regras permanentes

sudo apt install -y iptables-persistent

output "Regras AntiDDOS aplicadas com êxito."
