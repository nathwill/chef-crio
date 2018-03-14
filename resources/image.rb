property :crio_image, String, name_property: true
property :repo, String
property :tag, String, default: 'latest'
property :opts, Array, default: []

default_action :pull

action :pull do
  execute "pull crio image: #{new_resource.crio_image}" do
    command "/bin/podman pull #{new_resource.opts.join(' ')} #{new_resource.repo}:#{new_resource.tag}"
  end
end
