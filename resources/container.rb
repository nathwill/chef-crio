property :container_name, String, identity: true, name_property: true
property :image, String, default: lazy { container_name }
property :tag, String, default: 'latest'
property :run_opts, Array, default: []
property :pull_opts, Array, default: []
property :pull_image, [TrueClass, FalseClass], default: true
property :command, String

action_class do
  def img_desc
    new_resource.image + ':' + new_resource.tag
  end

  def fmt_opts(arr = [])
    arr.join(' ')
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
        ExecStartPre=-/bin/podman stop %p
        ExecStartPre=-/bin/podman rm %p
        ExecStart=/bin/podman run #{fmt_opts new_resource.run_opts} \\
            --cidfile=/var/run/%p.crio --cgroup-parent=/machine.slice/%p.service \\
            --name=%p #{img_desc} #{new_resource.command}
        ExecStop=/bin/podman stop %p
        ExecStop=/bin/podman rm %p
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

    file ::File.join(dir.path, 'default.conf') do
      content <<~EOT
        [Service]
        ExecStartPre=/bin/podman pull #{fmt_opts new_resource.pull_opts} #{img_desc}
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
