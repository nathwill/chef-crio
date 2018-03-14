# crio

Chef cookbook for managing [cri-o](http://cri-o.io) and related resources.

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

see resource definitions for details

### crio\_image

resource for managing crio images

### crio\_container

resource for managing crio containers as system services
