#!/bin/bash


echo "===================================================================="
echo "				Instando Dependências"
echo "===================================================================="

sleep 1 

apt -y install dmidecode hwdata ucf hdparm
apt -y install perl libuniversal-require-perl libwww-perl libparse-edid-perl
apt -y install libproc-daemon-perl libfile-which-perl libhttp-daemon-perl
apt -y install libxml-treepp-perl libyaml-perl libnet-cups-perl libnet-ip-perl
apt -y install libdigest-sha-perl libsocket-getaddrinfo-perl libtext-template-perl
apt -y install libxml-xpath-perl libyaml-tiny-perl
apt -y install libnet-snmp-perl libcrypt-des-perl libnet-nbname-perl
apt -y install libdigest-hmac-perl
apt -y install libfile-copy-recursive-perl libparallel-forkmanager-perl
apt -y install libwrite-net-perl

echo "====================================================================="
echo " 				Baixando o Agente"
echo "====================================================================="

wget https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/fusioninventory-agent_2.5.2-1_all.deb
wget https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/fusioninventory-agent-task-collect_2.5.2-1_all.deb
wget https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/fusioninventory-agent-task-network_2.5.2-1_all.deb
wget https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/fusioninventory-agent-task-deploy_2.5.2-1_all.deb
wget https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.5.2/fusioninventory-agent-task-esx_2.5.2-1_all.deb

echo "======================================================================"
echo "				Instalando o Agente"
echo "======================================================================"
dpkg -i fusioninventory-agent_2.5.2-1_all.deb &&
dpkg -i fusioninventory-agent-task-collect_2.5.2-1_all.deb &&
dpkg -i fusioninventory-agent-task-network_2.5.2-1_all.deb &&
dpkg -i fusioninventory-agent-task-deploy_2.5.2-1_all.deb &&
dpkg -i fusioninventory-agent-task-esx_2.5.2-1_all.deb

echo "======================================================================"
echo "				Configurando Agente"
echo "======================================================================"
echo "Configurando..."
echo "server = http://$1/glpi/plugins/fusioninventory/" >> /etc/fusioninventory/agent.cfg
sleep 3
echo "Configuração concluida... Reiniciando serviço..."
sleep 1
systemctl restart fusioninventory-agent.service
echo "Realizando Reload das configurações..."
sleep 1
systemctl reload fusioninventory-agent.service
sleep 1
systemctl restart fusioninventory-agent.service
if [ $? == "0" ]; then 
    echo "Agente Instalado e Configurado com sucesso!!!!"
else
    echo "Houve algum problema ao tentar Instalar e Configurar o Agente"
fi
sleep 1
echo "Limpando arquivos de Instalação..."
rm -rf $(ls | grep fusioninventory-agent )
if [ $? == "0" ]; then
    sleep 1
    echo -e "\033[92m Arquivos limpos com sucesso e agente configurado e instalado! \033[0m"
else
    echo "Ocorreu um erro durante a execução do programa!"
fi
