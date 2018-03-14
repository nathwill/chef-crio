property :crio_container, String, name_property: true
property :image, String, required: true
property :tag, String, default: 'latest'
property :run_opts, Array, default: []
property :pull_opts, Array, default: []
property :command, String

default_action :run

action :create do
  systemd_unit "#{new_resource.crio_container}.service" do
    content <<~EOT
      [Unit]
      Description=crio container: %p

      [Service]
      ExecStartPre=-/bin/podman stop %p
      ExecStartPre=-/bin/podman rm %p
      ExecStartPre=/bin/podman pull \\
        #{new_resource.pull_opts.join(' ')} \\
        #{new_resource.image}:#{new_resource.tag}
      ExecStartPre=/bin/podman run \\
        #{new_resource.run_opts.join(' ')} \\
        --cgroup-parent=/machine.slice/%p.service \\
        --detach --name=%p --cidfile=/var/run/%p.crio \\
        #{new_resource.image}:#{new_resource.tag} #{new_resource.command}
      ExecStart=/bin/podman wait %p
      ExecStop=/bin/podman pull \\
        #{new_resource.pull_opts.join(' ')} \\
        #{new_resource.image}:#{new_resource.tag}
      ExecStop=-/bin/podman stop %p
      ExecStop=-/bin/podman rm %p
      Restart=always
      Slice=machine.slice

      [Install]
      WantedBy=multi-user.target
    EOT
    action :create
  end
end

%i(delete enable disable start stop restart).each do |actn|
  action actn do
    systemd_unit new_resource.crio_container do
      action actn
    end
  end
end
