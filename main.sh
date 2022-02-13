#!/bin/bash
#variables and stuff
docker-response="Hello from Docker!"
docker-compose="docker-compose version"
#ANSI escape codes for colors
R='\033[0;31m' # errors
G='\033[0;32m'
Y='\033[1;33m' # normal output
NC='\033[0m' # No color


#gpg key stuff
echo "${Y}gathering GPG keys...${NC}"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
sudo apt-key fingerprint 0EBFCD88
wget -O - https://repo.jellyfin.org/jellyfin_team.gpg.key |  apt-key add - 
clear


#add repos
echo "${Y}Adding repos...${NC}"
echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/ubuntu focal main" |  tee /etc/apt/sources.list.d/jellyfin.list  > /dev/null
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"  > /dev/null


#update
echo "${Y}Updating repos...${NC}"
apt-get update -y > /dev/null
clear

#install samba
echo "${Y}Installing Samba...${NC}"
apt-get install -y samba-common samba smbclient > /dev/null
# Configure samba
smbpasswd -a $USER
clear


#jellyfin install
echo "${Y}Installing Jellyfin...${NC}"
apt-get install -y jellyfin > /dev/null
systemctl start jellyfin
echo "${G}Jellyfin Installed.${NC}"
sleep 2
clear


#install Docker 
echo "${Y}Installing Docker"
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common  > /dev/null
apt-get install -y docker-ce docker-ce-cli containerd.io > /dev/null
usermod -aG docker $USER
echo "adding user to docker group...${NC}"
#check if docker installed correctly
check=$(docker run hello-world)
if [ "$check" = "$docker-response" ]; then
   echo "${G}Docker successfully installed.${NC}"
else
   echo "${R}Docker had an error installing.${NC}"
fi
#install docker compose
curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose  > /dev/null
echo "${Y}Making /usr/local/bin/docker-compose executable..."
chmod +x /usr/local/bin/docker-compose
echo "Adding soft link for /usr/local/bin/docker-compose /usr/bin/docker-compose..."
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
check=$(docker-compose --version | awk '{print $1 $2}')
if [ "$check" = "$docker-compose" ]; then
   echo "${G}Docker-compose successfully installed.${NC}"
else
   echo "${R}Docker-compose had an error installing.${NC}"


# install portainer
echo "${Y}Installing portainer...${NC}"
cd ~/
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer



#firewall stuff
echo "${Y}Adding firewall rules...${NC}"
ufw allow samba
ufw allow ssh 
ufw allow 9000



