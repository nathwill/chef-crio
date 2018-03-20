property :image_name, String, identity: true, name_property: true
property :repo, String, default: lazy { image_name }
property :tag, String, default: 'latest'
property :global_opts, Array, default: []
property :pull_opts, Array, default: []

default_action :pull

action_class do
  def img_desc
    "#{new_resource.repo}:#{new_resource.tag}"
  end

  def fmt_opts(arr = [])
    arr.join(' ')
  end

  def podman_cmd
    "/bin/podman #{fmt_opts new_resource.global_opts}"
  end
end

action :pull do
  execute "pull crio image: #{new_resource.image_name}" do
    command "#{podman_cmd} pull #{fmt_opts new_resource.pull_opts} #{img_desc}"
  end
end

action :pull_if_missing do
  execute "pull crio image: #{new_resource.image_name}" do
    command "#{podman_cmd} pull #{new_resource.pull_opts.join(' ')} #{img_desc}"
    not_if "#{podman_cmd} images --format '{{.Repository}}:{{.Tag}}' | grep -q '#{img_desc}'"
  end
end
