property :crio_container, String, name_property: true
property :image, String, required: true
property :tag, String, default: 'latest'
property :run_opts, Array, default: []
property :pull_opts, Array, default: []
property :command, String

action_class do
  def img_desc
    new_resource.image + ':' + new_resource.tag
  end

  def fmt_opts(arr = [])
    arr.join(' ')
  end
end

default_action :run

%i(create delete enable disable start stop restart try_restart).each do |actn|
  action actn do
    systemd_unit "#{new_resource.crio_container}.service" do
      content <<~EOT
        [Unit]
        Description=crio container: %p

        [Service]
        ExecStartPre=-/bin/podman stop %p
        ExecStartPre=-/bin/podman rm %p
        ExecStartPre=/bin/podman pull #{fmt_opts new_resource.pull_opts} #{img_desc}
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
  end
end
