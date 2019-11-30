docker rm -f $(docker ps -aq)
docker images -a | grep "dev-" | awk '{print $3}' | xargs docker rmi
docker network prune
docker volume prune

sudo rm -rf crypto-config
sudo rm -rf scripts
rm -rf channel-artifacts/*
rm -rf connection/profiles/*