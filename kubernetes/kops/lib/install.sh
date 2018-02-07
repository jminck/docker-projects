
#get kops
wget https://github.com/kubernetes/kops/releases/download/1.8.0/kops-linux-amd64
chmod +x kops-linux-amd64
mv kops-linux-amd64 /usr/local/bin/kops

#get python pip
sudo apt-get install python-pip 
sudo pip install awscli

#update this to just open needed ports
sudo firewall-cmd --zone=public --add-port=2377/tcp --permanent
sudo firewall-cmd --permanent --add-port=7946/tcp 
sudo firewall-cmd --permanent --add-port=4789/udp 
sudo firewall-cmd --permanent --add-port=7946/udp 
sudo firewall-cmd --permanent --add-port=2376/tcp 

sudo firewall-cmd --reload
sudo systemctl restart firewalld
sudo service docker restart

