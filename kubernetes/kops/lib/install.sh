
#get kops
curl -s https://api.github.com/repos/kubernetes/kops/releases/latest \
  | grep browser_download_url \
  | grep linux-amd64 \
  | cut -d '"' -f 4 \
  | wget -qi -
chmod +x kops-linux-amd64
mv kops-linux-amd64 /usr/local/bin/kops

#set autocompletion
sudo kops completion bash > kops
sudo mv kops /etc/bash_completion.d/

#get kubectl
sudo snap install kubectl --classic

#set autocompletion
kubectl completion bash > kubectl
sudo mv kubectl /etc/bash_completion.d/

#get python pip
sudo apt-get install python-pip -y -q
sudo pip install awscli

curl -s https://api.github.com/repos/kubernetes/minikube/releases/latest \
  | grep browser_download_url \
  | grep linux-amd64 \
  | cut -d '"' -f 4 \
  | wget -qi -
sudo chmod +x minikube-linux-amd64
sudo mv minikube-linux-amd64 /usr/local/bin/minikube

#get kube-apiserver
wget https://storage.googleapis.com/kubernetes-release/release/v1.0.3/bin/linux/amd64/kube-apiserver
chmod +x kube-apiserver
sudo mv kube-apiserver /usr/local/bin

#install dashboard 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
# start dashboard with 
# kubectl proxy --address=<local ip> --accept-hosts="^192\.168\.1\.([0-9]|[1-9][0-9]|1([0-9][0-9])|2([0-4][0-9]|5[0-5]))$"


#generate ssh key
ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''


#install docker on all nodes
curl -L get.docker.com | sh

#ip=$(ifconfig enp0s8 | grep mask | awk '{print $2}'| cut -f2 -d:)
sudo service docker start
sudo update-rc.d docker enable

#install docker command completion
sudo apt-get install bash-completion -y
sudo curl -L https://raw.githubusercontent.com/docker/machine/v0.13.0/contrib/completion/bash/docker-machine.bash -o /etc/bash_completion.d/docker-machine

#install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#install docker compose autocompletion
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.18.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
