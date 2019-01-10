# Display unused docker images 
```
docker images -f dangling=true
```
# and just a list of their IDs:
```
docker images -q -f dangling=true
```
# In case you want to delete them:
```
docker rmi -f $(docker images -q -f dangling=true)
```
# Stop and remove all docker containers and images
## List all containers (only IDs) 
```
docker ps -aq.
```
## Stop all running containers 
```
docker stop $(docker ps -aq)
```
## Remove all containers 
```
docker rm $(docker ps -aq)
```
## Remove all images  
```
docker rmi $(docker images -q)
```
