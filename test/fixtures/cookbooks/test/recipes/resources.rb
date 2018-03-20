#
# test image resource
#
crio_image 'nginx' do
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
  run_opts ['--net=host', "--workdir=#{data_dir.path}",
            "--volume=#{data_dir.path}:#{data_dir.path}",
            '--log-driver=json-file', "--log-opt=path=#{log_file.path}"]
  action [:create, :enable, :start]
end

#
# interact with redis
#

include_recipe 'yum-epel'

package 'redis'

execute 'redis-cli bgsave'
