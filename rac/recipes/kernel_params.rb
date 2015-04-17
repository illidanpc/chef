
unless node[:rac][:kernel][:flag]


cookbook_file '/etc/sysctl.conf' do
  source 'ora_params'
  mode '0644'
  notifies :run, 'bash[sysctl_reload]', :immediately
end

execute 'cleanup_shm' do
  command "rm -rf /tmp/shm*"
end

bash 'cal_param1' do
  code "echo $\"((`free |grep Mem | awk '{print $2}'`*0.7 /`/usr/bin/getconf PAGE_SIZE`))\" |bc -l | awk -F'.' '{print $1}' >> /tmp/shmall"
end

bash 'cal_param2' do
  code "echo $\"((`free |grep Mem | awk '{print $2}'`/2))\" |bc -l | awk -F'.' '{print $1}' >> /tmp/shmmax"
end

bash 'cal_param3' do
  code "echo \nkernel.shmall = `cat /tmp/shmall` >> /etc/sysctl.conf"
end

bash 'cal_param4' do
  code "echo \nkernel.shmmax = `cat /tmp/shmmax` >> /etc/sysctl.conf "
end

bash 'sysctl_reload' do
  code 'sysctl -p'
end


ruby_block 'set_kernel_flag' do
  block do
    node.set[:rac][:kernel][:flag] = true
  end
  action :create
end

end