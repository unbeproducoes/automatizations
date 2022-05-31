#!/bin/bash

echo "Preparando sua máquina..."
wait
echo "25% concluidos.."
sudo apt -y update
echo "50% concluidos.."
wait
echo "75% concluidos.."
sudo apt -y upgrade
echo "100% concluidos.."
sleep 3

echo "                   _                          "
echo "  _ __   __ _  ___| | ____ _  __ _  ___  ___  "
echo " | '_ \ / _\` |/ __| |/ / _\` |/ _\` |/ _ \/| "
echo " | |_) | (_| | (__|   < (_| | (_| |  __/\__ \ "
echo " | .__/ \__,_|\___|_|\_\__,_|\__, |\___||___/ "
echo " |_|                         |___/            "
echo "                                              "

# Instalando aplicações importantes
download_list="curl git screen wget openjdk-8-jre-headless htop ufw"
node_js="curl dirmngr apt-transport-https lsb-release ca-certificates && curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - && sudo apt -y install nodejs && sudo apt -y install gcc g++ make"

sudo apt install -y ${download_list}
sleep 2
sudo apt install -y ${node_js}

output "Programas essenciais instalados com êxito."

echo "  _               _         __ _                        _ _  "
echo " | |__   __ _ ___(_) ___   / _(_)_ __ _____      ____ _| | | "
echo " | '_ \ / _` / __| |/ __| | |_| | '__/ _ \ \ /\ / / _` | | | "
echo " | |_) | (_| \__ \ | (__  |  _| | | |  __/\ V  V / (_| | | | "
echo " |_.__/ \__,_|___/_|\___| |_| |_|_|  \___| \_/\_/ \__,_|_|_| "
echo "                                                             "

sudo ufw allow 'OpenSSH'
sudo ufw allow 443
sudo ufw allow 25565/tcp
sudo ufw -y enable

echo "                  _           __       _     _                "
echo "  _ __ ___   __ _| | _____   / _| ___ | | __| | ___ _ __ ___  "
echo " | '_ \` _ \ / _\` | |/ / _ \ | |_ / _ \| |/ _\` |/ _ \ '__/  "
echo " | | | | | | (_| |   <  __/ |  _| (_) | | (_| |  __/ |  \__ \ "
echo " |_| |_| |_|\__,_|_|\_\___| |_|  \___/|_|\__,_|\___|_|  |___/ "
echo "                                                              "

echo "Fazendo a instalação do bungeecord"
wget 
echo "Instalação finalizada!"