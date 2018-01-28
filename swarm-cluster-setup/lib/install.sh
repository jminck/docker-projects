#install docker on all nodes
curl -L get.docker.com | sh

#ip=$(ifconfig enp0s8 | grep mask | awk '{print $2}'| cut -f2 -d:)
sudo service docker start
sudo chkconfig docker on

#update this to just open needed ports
echo running firewall-cmd --zone=public --add-port=2377/tcp --permanent
sudo firewall-cmd --zone=public --add-port=2377/tcp --permanent
echo running sudo firewall-cmd --reload
sudo firewall-cmd --reload

#initialize swarm on master node
if [ $(hostname -s) == "swarmnode1" ]
then
    sudo docker swarm init --advertise-addr $ip > ~/joinswarm.txt
fi

