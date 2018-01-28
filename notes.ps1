#########################################################
# initial powershell setup from
# https://docs.docker.com/docker-for-windows/#general

Set-ExecutionPolicy RemoteSigned
Install-Module posh-docker
Import-Module posh-docker

if (-Not (Test-Path $PROFILE)) {
    New-Item $PROFILE –Type File –Force
}

Add-Content $PROFILE "`nImport-Module posh-docker"

#install docker machine with windows git bash
if [[ ! -d "$HOME/bin" ]]; then mkdir -p "$HOME/bin"; fi && \
curl -L https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" && \
chmod +x "$HOME/bin/docker-machine.exe"


#########################################################
# linux install notes

#avoid needing to sudo every command
#doesn't work on RHEL based distros like CentOS
sudo usermod -aG docker <user>

#install docker machine 
curl -L https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && \
chmod +x /tmp/docker-machine && \
sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

#install docker compose
curl -L https://github.com/docker/compose/releases/download/1.18.0-rc2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


######################################################
# getting started command lines
docker version

docker container run -d --publish 81:80 --name webserver nginx
docker container ls
docker container logs webserver
docker container top webserver
docker container stop (ID or unique subset, can be multple)
docker container rm (ID or unique subset, can be multple)


docker container run -d --publish 81:80 --name nginx nginx
docker container run -d --publish 8080:80 --name httpd httpd
docker container run -d --publish 3306:3306 --name mysql -e MYSQL_RANDOM_ROOT_PASSWORD=yes mysql
#get password
docker container logs mysql

#list containers
docker container ps -a

#stop all containers:
docker kill $(docker ps -q) 
#remove all containers
docker rm $(docker ps -a -q)

################################################################
# what's going on in containers

#snapshot
docker container top
#json dump of container details
docker container inspect
docker container inspect --format '{{ .NetworkSettings.IPAddress}}' nginx
#like top in linux
docker container stats

# launch container interactively -i interactrive -t pseudo tty (last arg is override command line to launch)
docker container run -it --publish 81:80 --name nginx nginx bash 

#execute something inside the container (in this case interactive bash shell)
docker container exec -it nginx bash

#tiny distro ~5 megs alpine 
#apk is package manager
docker container exec -it nginx sh
apk add bash curl wget

#network commands
#show networks
docker network ls

#inspect a network
docker network inspect

#create a network
docker network create my_net

#connect new container to specific network
docker container run -it --publish 81:80 --network my_net --name nginx nginx bash 

#connect existing container to specific network
docker network connect my_net dazzling_hamilton
docker network inspect my_net

# search docker hub
docker search --format "{{.Name}}: {{.StarCount}}" ubuntu
docker search --format "table {{.Name}}\t{{.IsAutomated}}\t{{.IsOfficial}}" nginx

# create multiple containers responding to same name
docker run -d --network my_net --net-alias es elasticsearch:2
docker run -d --network my_net --net-alias es elasticsearch:2
docker run -it --network my_net centos bash
    #repeat this looking for name to change
    yum update
    yum install bind-utils
    nslookup es
    curl -s es:9200

#show image creation history
docker image history nginx:latest
docker image inspect nginx:latest

#tag and upload an image to docker hub
docker login #after login, creds are stored in  ~/.docker/config.json
docker image tag nginx jminck/nginx
docker image push jminck/nginx
#add another tag and push it
docker image push jminck/nginx:latestandgreatest 
docker image tag nginx jminck/nginx:latestandgreatest

####################################################################
# specify a persistant data volume name
# mount to ./data subfolder on host
docker run -it -v data:/mnt/data centos bash
#full path on host
docker run -it -v /mnt/docker/data:/mnt/data centos bash
#syntax for Windows host
docker run -it -v //d/docker/data:/mnt/data centos bash
#
docker run -it -v //d/docker/data:/mnt/data centos bash

docker volume ls
docker volume inspect data


########################################################################
# minor version upgrade of db container while retaining data
docker run -d -v postgresdata:/var/lib/postgresql/data --publish 5432 --net-alias postgres postgres:9.6.1
#stop container, then run
docker run -d -v postgresdata:/var/lib/postgresql/data --publish 5432 --net-alias postgres postgres:9.6.2
#check version, launch another container and conect to postgres
docker run -it --net my_net centos bash
    yum update -y
    yum install postgresql -y
    psql -h postgres -p 5432

# ELK stack with x-pack https://github.com/deviantony/docker-elk/tree/x-pack
git pull -b x-pack https://github.com/deviantony/docker-elk.git
