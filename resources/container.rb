property :container_name, String, identity: true, name_property: true
property :image, String, default: lazy { container_name }
property :tag, String, default: 'latest'
property :run_opts, Array, default: []
property :pull_opts, Array, default: []
property :global_opts, Array, default: []
property :pull_image, [TrueClass, FalseClass], default: true
property :command, String

action_class do
  def img_ref
    new_resource.image + ':' + new_resource.tag
  end

  def fmt_opts(arr = [])
    arr.join(' ')
  end

  def podman_cmd
    "/bin/podman #{fmt_opts new_resource.global_opts}"
  end
end

default_action :create

%i(create delete).each do |actn|
  action actn do
    systemd_unit "#{new_resource.container_name}.service" do
      content <<~EOT
        [Unit]
        Description=CRI-O container: %p

        [Service]
        Type=forking
        ExecStartPre=-#{podman_cmd} stop %p
        ExecStartPre=-#{podman_cmd} rm %p
        ExecStart=#{podman_cmd} run --detach #{fmt_opts new_resource.run_opts} \\
            --cidfile=/var/run/%p.crio --cgroup-parent=/machine.slice/%p.service \\
            --name=%p #{img_ref} #{new_resource.command}
        ExecStop=#{podman_cmd} stop %p
        ExecStop=#{podman_cmd} rm %p
        Restart=always
        Slice=machine.slice

        [Install]
        WantedBy=multi-user.target
      EOT
      action actn
    end

    dir = directory "/etc/systemd/system/#{new_resource.container_name}.service.d" do
      only_if { new_resource.pull_image }
    end

    file ::File.join(dir.path, 'pull.conf') do
      content <<~EOT
        [Service]
        ExecStartPre=#{podman_cmd} pull #{fmt_opts new_resource.pull_opts} #{img_ref}
      EOT
      only_if { new_resource.pull_image }
    end
  end
end

%i(enable disable start stop restart try_restart).each do |actn|
  action actn do
    systemd_unit "#{new_resource.container_name}.service" do
      action actn
    end
  end
end
