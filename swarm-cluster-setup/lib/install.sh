#install docker on all nodes
curl -L get.docker.com | sh

#ip=$(ifconfig enp0s8 | grep mask | awk '{print $2}'| cut -f2 -d:)
sudo service docker start
sudo chkconfig docker on

#update this to just open needed ports
sudo firewall-cmd --zone=public --add-port=2377/tcp --permanent
sudo firewall-cmd --permanent --add-port=7946/tcp 
sudo firewall-cmd --permanent --add-port=4789/udp 
sudo firewall-cmd --permanent --add-port=7946/udp 
sudo firewall-cmd --permanent --add-port=2376/tcp 

sudo firewall-cmd --reload
sudo systemctl restart firewalld
sudo service docker restart

#install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#initialize swarm on master node
if [ $(hostname -s) == "swarmnode1" ]
then
    sudo docker swarm init --advertise-addr $(ifconfig enp0s8 | grep mask | awk '{print $2}'| cut -f2 -d:) | grep SWMTKN > /vagrant/joinswarm.sh
fi

#install workers
if [ $(hostname -s) != "swarmnode1" ]
then
    CMDLINE=$(</vagrant/joinswarm.sh)
    TOKEN="$(cut -d' ' -f5 <<<$CMDLINE)"
    MGR="$(cut -d' ' -f6 <<<$CMDLINE)"
    docker swarm join --token $TOKEN --advertise-addr $(ifconfig enp0s8 | grep mask | awk '{print $2}'| cut -f2 -d:) $MGR
fi
