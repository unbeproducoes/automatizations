#!/bin/bash

output(){
    echo -e '\e[36m'$1'\e[0m';
}

# instalando a dependência necessária para baixar a lista de IP's.
sudo apt -y install curl
# Aplicando whitelist de IP's da CloudFlare a sua máquina.
sudo iptables -I DOCKER-USER -p tcp --dport 443 -j DROP
sudo iptables -I DOCKER-USER -p tcp -s $(curl -sSL https://www.cloudflare.com/ips-v4 | paste -d, -s) --dport 443 -j ACCEPT

# Tornando as regras aplicadas persistentes ( sempre ativa ).
sudo iptables-save > /etc/iptables/rules.v4
sudo apt -y install iptables=persistent

output "A lista de IPV4's foram aplicados a porta 443 com sucesso!"

# Créditos totais a tommytran732 pela criação da ferramenta.