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

machine="sudo apt update -y && sudo apt upgrade -y"
sudo apt install -y ${machine}

echo "██████╗  █████╗  ██████╗██╗  ██╗ █████╗  ██████╗ ███████╗███████╗"
echo "██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██╔════╝ ██╔════╝██╔════╝"
echo "██████╔╝███████║██║     █████╔╝ ███████║██║  ███╗█████╗  ███████╗"
echo "██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══██║██║   ██║██╔══╝  ╚════██║"
echo "██║     ██║  ██║╚██████╗██║  ██╗██║  ██║╚██████╔╝███████╗███████║"
echo "╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝"

# Instalando aplicações importantes
download_list="curl git screen wget iptables-persistent openjdk-8-jre-headless htop ufw"
node_js="curl dirmngr apt-transport-https lsb-release ca-certificates && curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - && sudo apt -y install nodejs && sudo apt -y install gcc g++ make"

sudo apt install -y ${download_list}
sleep 2
sudo apt install -y ${node_js}

output "Programas essenciais instalados com êxito."