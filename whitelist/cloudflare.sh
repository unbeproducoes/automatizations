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