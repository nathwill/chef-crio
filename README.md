# crio chef cookbook [![Build Status](https://travis-ci.org/nathwill/chef-crio.svg?branch=master)](https://travis-ci.org/nathwill/chef-crio)

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

#### properties

|property|type|example|description|
|--------|----|-------|-----------|
|image_name|String|`redis`|resource name|
|repo|String|`docker.io/library/redis`|image repository path|
|tag|String|`latest`|image tag to pull|
|global_opts|Array|`['--storage-driver=vfs']`|podman global options|
|pull_opts|Array|`--authfile=/etc/containers/auth.json`|podman pull options|

#### actions

 - `:pull`: default, pulls image
 - `:pull_if_missing`: pull image if not already present
 - `:nothing`: do nothing

### crio\_container

resource for managing CRI-O containers as systemd service units

#### properties

|property|type|example|description|
|--------|----|-------|-----------|
|container_name|String|`redis`|resource name|
|image|String|`redis`|image to run|
|tag|String|`3.2`|image tag to run|
|global_opts|Array|`['--storage-driver=vfs']`|podman global options|
|run_opts|Array|`['--net=host']`|podman run options|
|pull_opts|Array|`['--authfile=/etc/containers/auth.json']`|podman pull options|
|command|String|`/usr/bin/my-app`|command to run in container|
|pull_image|[TrueClass, FalseClass]|`true`|whether to pull image before container start|

#### actions

 - `:create`: default, create systemd unit to run container as a systemd service unit
 - `:delete`: delete container service unit
 - `:enable`: enable container service unit
 - `:disable`: disable container service unit
 - `:start`: start service unit
 - `:stop`: stop service unit
 - `:restart`: restart service unit, start if stopped
 - `:try_restart`: restart service unit if running, does nothing if stopped
 - `:nothing`: do... nothing!
