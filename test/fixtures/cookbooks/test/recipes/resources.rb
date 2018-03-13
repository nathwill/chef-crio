
img = crio_image 'redis' do
  repo 'docker.io/library/redis'
  tag '3.2'
end

d = directory '/data'

crio_container 'redis' do
  image img.repo
  tag img.tag
  run_opts ["--volume=#{d.path}:#{d.path}",
           '--net=host', "--workdir=#{d.path}"]
  supervise true
  action [:create, :enable, :start]
end
