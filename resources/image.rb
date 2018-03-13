property :crio_image, String, name_property: true
property :repo, String
property :tag, String, default: 'latest'
property :source, String
property :destination, String
property :opts, Array, default: []

default_action :pull

#load_current_value do
#
#end

#action_class do
#
#end

#action :import do
#  execute "import crio image: #{new_resource.crio_image}" do
#    command "/bin/podman import ##{new_resource.source} #{new_resource.crio_image}"
#  end
#end

#action :load do
#  execute "load crio image: #{new_resource.crio_image}" do
#    command "/bin/podman load -i #{new_resource.source}"
#  end
#end

action :pull do
  execute "pull crio image: #{new_resource.crio_image}" do
    command "/bin/podman pull #{new_resource.opts.join(' ')} #{new_resource.repo}:#{new_resource.tag}"
  end
end

#action :push do
#  execute "push crio image: #{new_resource.crio_image}" do
#    command "/bin/podman push #{new_resource.opts.join(' ')} #{new_resource.source} #{new_resource.destination}"
#  end
#end

#action :rmi do
#  execute "rm crio image: #{new_resource.crio_image}" do
#    command "/bin/podman rmi #{new_resource.crio_image}"
#  end
#end

#action :save do
#  execute "save crio image: #{new_resource.crio_image}" do
#    command "/bin/podman save #{new_resource.opts.join(' ')} -o #{new_resource.destination} #{new_resource.crio_image}"
#  end
#end

#action :tag do
#  execute "tag crio image: #{new_resource.crio_image}" do
#    command "/bin/podman tag #{new_resource.crio_image} #{new_resource.destination}:#{new_resource.tag}"
#  end
#end
