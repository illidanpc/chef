
unless node[:rac][:kernel][:flag]

bash 'sysctl_reload' do
  code 'source /etc/init.d/functions && apply_sysctl'
  action :nothing
end

bash 'cal_param1' do
	code "echo $\"((`free |grep Mem | awk '{print $2}'`*0.7 /`/usr/bin/getconf PAGE_SIZE`))\" |bc -l | awk -F'.' '{print $1}'"
	action :nothing
end

bash 'cal_param2' do
	code "echo $\"((`free |grep Mem | awk '{print $2}'`/2))\" |bc -l | awk -F'.' '{print $1}'"
	action :nothing
end


template '/etc/sysctl.conf' do
  source 'ora_param.erb'
  mode '0644'
  variables(
  	:shmall => 'bash[cal_param1]' ,
  	:shmmax => 'bash[cal_param2]'
  	)
  notifies :run, 'bash[sysctl_reload]', :immediately
end

ruby_block 'set_kernel_flag' do
  block do
    node.set[:rac][:kernel][:flag] = true
  end
  action :create
end

end