docker rm -f $(docker ps -aq --no-trunc --filter name=^/dev*)
docker images -a | grep "dev-" | awk '{print $3}' | xargs docker rmi