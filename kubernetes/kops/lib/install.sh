
#get kops
wget https://github.com/kubernetes/kops/releases/download/1.8.0/kops-linux-amd64
chmod +x kops-linux-amd64
mv kops-linux-amd64 /usr/local/bin/kops

#get python pip
sudo apt-get install python-pip -y -q
sudo pip install awscli



