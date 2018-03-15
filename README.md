# crio chef cookbook

Chef cookbook for managing [CRI-O](http://cri-o.io) and related resources.

Recommended reading:
  - [crio man page](https://www.mankier.com/8/crio)
  - [podman man page](https://www.mankier.com/1/podman)
  - [CRI-O blog](https://medium.com/cri-o)

## Recipes

### crio::default

includes install, configure, manage recipes

### crio::install

sets up yum repository and install CRI-O related packages

### crio::configure

configures the CRI-O daemon via attributes

### crio::manage

manages crio.service

## Resources

### crio\_image

resource for managing CRI-O images

|property|type|
|--------|----|
|image_name|String|
|repo|String|
|tag|String|
|pull_opts|Array|

### crio\_container

resource for managing CRI-O containers as system services

|property|type|
|--------|----|
|container_name|String|
|image|String|
|tag|String|
|run_opts|Array|
|pull_opts|Array|
|command|String|

