# 1.3.0 / 2018-04-12

* update to latest podman
* use conmon-pidfile instead of cgroup placement
* add alternative package repo

# 1.2.2 / 2018-03-29

* set image pull timeout

# 1.2.1 / 2018-03-22

* coerce opts to string

# 1.2.0 / 2018-03-22

* consolidate common resource methods
* pull_image defaults to false on container resource

# 1.1.1 / 2018-03-21

* make pull action on image resource idempotent

# 1.1.0 / 2018-03-20

* add global_opts property for image/container resources
* detach podman run, use forking service type
* fix up tests

# 1.0.1 / 2018-03-15

* add travis config
* add identity to image_name
* clarify test functionality
* update documentation
* add travis config

# 1.0.0 / 2018-03-15

* add pull_if_missing action to image resource
* allow opt out of image pull in container resource using pull_image property

# 0.7.0 / 2018-03-15

* fix default container resource action

# 0.6.0 / 2018-03-15

* set default image/container repo properties rather than required

# 0.5.0 / 2018-03-15

* update documentation
* fix cops
* simplify service unit for podman-0.3.3
