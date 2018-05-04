property :container_name, String, identity: true, name_property: true
property :image, String, default: lazy { container_name }
property :tag, String, default: 'latest'
property :run_opts, [String, Array], default: [], coerce: CrioCookbook::FMT_OPT_PROC
property :pull_opts, [String, Array], default: [], coerce: CrioCookbook::FMT_OPT_PROC
property :global_opts, [String, Array], default: [], coerce: CrioCookbook::FMT_OPT_PROC
property :pull_image, [TrueClass, FalseClass], default: false
property :command, String

alias_method :repo, :image

action_class do
  include CrioCookbook::Mixins::ResourceMethods
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
        PIDFile=/run/%p.pid
        ExecStart=#{podman_cmd} run -d #{new_resource.run_opts} --name=%p \\
            --conmon-pidfile=/run/%p.pid #{img_ref} #{new_resource.command}
        ExecStop=#{podman_cmd} stop %p
        ExecStopPost=#{podman_cmd} rm %p
        Restart=always

        [Install]
        WantedBy=multi-user.target
      EOT
      action actn
    end

    dir = directory "/etc/systemd/system/#{new_resource.container_name}.service.d" do
      only_if { new_resource.pull_image && actn == :create }
    end

    reload = execute 'systemctl daemon-reload' do
      action :nothing
    end

    file ::File.join(dir.path, 'pull.conf') do
      content <<~EOT
        [Service]
        ExecStartPre=#{podman_cmd} pull #{new_resource.pull_opts} #{img_ref}
      EOT
      notifies :run, reload.to_s, :immediately
      # Delete if action is create, but pull_image is false
      if actn == :create && new_resource.pull_image
        action :create
      else
        action :delete
      end
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
