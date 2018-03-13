property :crio_container, String, name_property: true
property :image, String, required: true
property :tag, String, default: 'latest'
property :run_opts, Array, default: []
property :pull_opts, Array, default: []
property :command, String
property :supervise, [TrueClass, FalseClass], default: false

default_action :run

def load_current_resource
  
end

action_class do

end

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
        --detach --name=%p \\
        #{new_resource.image}:#{new_resource.tag} #{new_resource.command}
      ExecStart=/bin/podman wait %p
      ExecStop=/bin/podman pull \\
        #{new_resource.pull_opts.join(' ')} \\
        #{new_resource.image}:#{new_resource.tag}
      ExecStop=-/bin/podman stop %p
      ExecStop=-/bin/podman rm %p
      Restart=always

      [Install]
      WantedBy=multi-user.target
    EOT
    only_if { new_resource.supervise }
    action :create
  end

  execute "create crio container: #{new_resource.crio_container}" do
    command [
      '/bin/podman create',
      new_resource.run_opts.join(' '),
      "--name=#{new_resource.crio_container}",
      new_resource.image + ':' + new_resource.tag,
      new_resource.command
    ].join(' ')
    not_if { new_resource.supervise }
#    only_if { !exists? }
  end
end

%i(delete enable disable).each do |actn|
  action actn do
    systemd_unit new_resource.crio_container do
      only_if { new_resource.supervise }
      action actn
    end
  end
end

action :start do
  systemd_unit new_resource.crio_container do
    action :start
    only_if { new_resource.supervise }
  end

  execute "start crio container: #{new_resource.crio_container}" do
    command "/bin/podman start #{new_resource.crio_container}"
    not_if { new_resource.supervise }
#    only_if { !running? }
  end
end

action :stop do
  systemd_unit new_resource.crio_container do
    action :stop
    only_if { new_resource.supervise }
  end

  execute "stop crio container: #{new_resource.crio_container}" do
    command "/bin/podman stop #{new_resource.crio_container}"
    not_if { new_resource.supervise }
#    only_if { running? }
  end
end

action :run do
  execute "run crio container: #{new_resource.crio_container}" do
    command [
      "/bin/podman run",
      new_resource.run_opts.join(' '),
      new_resource.image + ':' + new_resource.tag,
      new_resource.command
    ].join(' ')
#    only_if { !running? }
  end
end

action :rm do
  execute "rm crio container: #{new_resource.crio_container}" do
    command "/bin/podman rm #{new_resource.crio_container}"
#    only_if { exists? }
  end
end

action :exec do
  execute "exec in crio container: #{new_resource.crio_container}" do
    command [
      '/bin/podman exec',
      new_resource.run_opts.join(' '),
      new_resource.crio_container
    ].join(' ')
  end
end

action :pause do
  execute "pause crio container: #{new_resource.crio_container}" do
    command "/bin/podman pause #{new_resource.crio_container}"
#    only_if { !paused? }
  end
end

action :unpause do
  execute "unpause crio container: #{new_resource.crio_container}" do
    command "/bin/podman unpause #{new_resource.crio_container}"
#    only_if { paused? }
  end
end

action :wait do
  execute "wait on crio container: #{new_resource.crio_container}" do
    command "/bin/podman wait #{new_resource.crio_container}"
  end
end
