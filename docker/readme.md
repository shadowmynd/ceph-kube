# Docker images
## Purpose
Stores all custom images being generated for cluster

### Scripts
#### create.zsh
Finds all docker images below current directory and builds them

##### Usage
```
create.zsh
```

#### publish.zsh
Finds all docker images below current directory and publishes them

##### Usage
```
publish.zsh DOCKER_HOST

E.g.
publish.zsh docker_hub_user
```