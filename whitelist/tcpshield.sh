#!/bin/bash

output(){
    echo -e '\e[36m'$1'\e[0m';
}

get_ports(){
    read -a ports

    if [[ $ports = "" ]]; then
      output "Você não pode deixar a lista de portas vazias!"
      get_ports
    fi
}

output "Coloque a lista de portas que gostaria de abrir, separado por espaços"
output "Por exemplo, caso queira abrir as portas entre 25565-25570, digite: "
output "25565 25566 25567 25568 25569 25570"
output "caso contrário, coloque as portas que deseja!"

get_ports

if [ -r /etc/os-release ]; then
    lsb_dist="$(. /etc/os-release && echo "$ID")"
fi

if [ -r /etc/os-release ]; then
   lsb_dist="$(. /etc/os-release && echo "$ID")"
   dist_version="$(. /etc/os-release && echo "$VERSION_ID")"
else
   output "Distro não suportada! Apenas RHEL, CentOS, Fedora, Ubuntu, e Debian são suportadas!" 
   exit 1
fi

if [ "$lsb_dist" = "rhel" ]; then
   output "OS: Red Hat Enterprise Linux $dist_version detectado."
else
   output "OS: $lsb_dist $dist_version detectado."
fi

if [ "$lsb_dist" =  "ubuntu" ] || [ "$lsb_dist" =  "debian" ]; then
     apt -y install ufw wget
     # Abertura da porta 22 para evitar que a conexão seja interrompida durante a execução do script
     ufw allow 22
     wget https://tcpshield.com/v4
     
     for ips in `cat v4`;
     do
        for port in "${ports[@]}";
        do
          ufw allow from $ips to any proto tcp port $port
        done
     done    
     yes | ufw enable
elif [ "$lsb_dist" =  "fedora" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" =  "centos" ] || [ "$lsb_dist" =  "opensuse" ]; then
     if [ "$lsb_dist" =  "fedora" ] || [ "$lsb_dist" =  "rhel" ] || [ "$lsb_dist" =  "centos" ]; then
        yum -y install firewalld wget
     elif [ "$lsb_dist" =  "opensuse" ]; then
        zypper in firewalld wget -y
     fi
     wget https://tcpshield.com/v4
     for ips in `cat v4`;
     do
        for port in "${ports[@]}";
        do
          firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address='"$ips"' port port='"$port"' protocol="tcp" accept'
        done
     done
     firewall-cmd --reload
else 
     output "Distribuição sem suporte. Este script só suporta Fedora, RHEL, CentOS, Ubuntu, e Debian."
     exit 1
fi 

rm v4

output "IPs do TCPShield foram autorizados com êxito nas portas selecionadas"

# Créditos totais a tommytran732 pelo desenvolvimento do script