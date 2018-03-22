#
# test image resource
#
crio_image 'busybox' do
  tag 'musl'
end

crio_image 'busybox-second' do
  repo 'busybox'
  tag 'musl'
  action :pull_if_missing
end

#
# test container resource
#
app_name = 'redis'

log_file = file "/var/log/#{app_name}.log"
data_dir = directory '/data'

crio_container app_name do
  image app_name
  tag '3.2'
  run_opts ['--net=host', "--volume=#{data_dir.path}:#{data_dir.path}",
            '--log-driver=json-file', "--log-opt=path=#{log_file.path}"]
  pull_image true
  action [:create, :enable, :start]
end

#
# interact with redis
#

include_recipe 'yum-epel'

package 'redis'

# force bgsave so we can test the vol-mount
execute 'redis-cli bgsave' do
  not_if { ::File.exist?('/data/dump.rdb') }
end
