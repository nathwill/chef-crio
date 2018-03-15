# crio

Chef cookbook for managing [cri-o](http://cri-o.io) and related resources.

Recommended reading:
  - [cri-o man page](https://www.mankier.com/8/crio)
  - [podman man page](https://www.mankier.com/1/podman)
  - [cri-o blog](https://medium.com/cri-o)

## Recipes

### crio::default

Runs install, configure manage tasks

### crio::install

sets up yum repository and install crio packages

### crio::configure

configures the crio daemon through the env-files using attributes

### crio::manage

manages the crio daemon service

## Resources

### crio\_image

resource for managing crio images

|property|type|
|--------|----|
|image_name|String|
|repo|String|
|tag|String|
|pull_opts|Array|

### crio\_container

resource for managing crio containers as system services

|property|type|
|--------|----|
|container_name|String|
|image|String|
|tag|String|
|run_opts|Array|
|pull_opts|Array|
|command|String|

