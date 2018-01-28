#install docker on all nodes
curl -L get.docker.com | sh

#ip=$(ifconfig enp0s8 | grep mask | awk '{print $2}'| cut -f2 -d:)
sudo service docker start
sudo chkconfig docker on

#update this to just open needed ports
firewall-cmd --zone=public --add-port=2377/tcp --permanent
firewall-cmd --reload

#initialize swarm on master node
[ $(hostname -s) == "swarmnode1" ] && docker swarm init --advertise-addr $ip > ~/joinswarm.txt
