property :image_name, String, name_property: true
property :repo, String
property :tag, String, default: 'latest'
property :opts, Array, default: []

default_action :pull

action_class do
  def img_desc
    "#{new_resource.repo}:#{new_resource.tag}"
  end
end

action :pull do
  execute "pull crio image: #{new_resource.image_name}" do
    command "/bin/podman pull #{new_resource.opts.join(' ')} #{img_desc}"
  end
end
