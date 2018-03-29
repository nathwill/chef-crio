property :image_name, String, identity: true, name_property: true
property :repo, String, default: lazy { image_name }
property :tag, String, default: 'latest'
property :global_opts, [String, Array], default: [], coerce: CrioCookbook::FMT_OPT_PROC
property :pull_opts, [String, Array], default: [], coerce: CrioCookbook::FMT_OPT_PROC

default_action :pull

alias_method :image, :repo

action_class do
  require 'chef/mixin/shell_out'

  include Chef::Mixin::ShellOut
  include CrioCookbook::Mixins::ResourceMethods

  def img_refs
    cmd = shell_out_with_systems_locale!("#{podman_cmd} images --format '{{.Repository}}:{{.Tag}}'")
    cmd.stdout.split("\n")
  end

  def img_shas
    cmd = shell_out_with_systems_locale!("#{podman_cmd} images -q --no-trunc")
    cmd.stdout.split("\n")
  end

  def pull_img
    extant = img_shas
    cmd = shell_out_with_systems_locale!("#{podman_cmd} pull -q #{new_resource.pull_opts} #{img_ref}", timeout: 3_600)
    !extant.any? { |img_sha| img_sha.end_with?(cmd.stdout.chomp) }
  end
end

action :pull do
  # We always pull, this reports a change
  converge_by "Pulling image: #{img_ref}" do
  end if pull_img
end

action :pull_if_missing do
  return if img_refs.include?(img_ref)
  action_pull
end
