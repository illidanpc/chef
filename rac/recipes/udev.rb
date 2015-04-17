#udev setting
unless node[:rac][:grid][:udev][:flag]

#for linux 6
#execute 'whitspace' do
#  command 'echo "options=--whitelisted --replace-whitespace"  >> /etc/scsi_id.config'
#  not_if { File.exists?("/etc/udev/rules.d/99-oracle-asmdevices.rules" ) }
#end

execute 'format_xvdb1' do
	command "fdisk /dev/xvdb1"
end

execute 'format_xvdc1' do
	command "fdisk /dev/xvdc1"
end

execute 'format_xvdd1' do
	command "fdisk /dev/xvdd1"
end

execute 'format_xvde1' do
	command "fdisk /dev/xvde1"
end

execute 'format_xvdf1' do
	command "fdisk /dev/xvdf1"
end

execute 'format_xvdg1' do
	command "fdisk /dev/xvdg1"
end

template "etc/udev/rules.d/99-oracle-asmdevices.rules" do
   mode '0750'
   source 'udev_rules'
   variables(
   	:prefix => node['rac']['oracle']['dbname']
   	)
   notifies :run, 'bash[udev_start]', :immediately
end

bash 'udev_start' do
	code "/sbin/start_udev"
	action :nothing
end


ruby_block 'set_udev_flag' do
  block do
    node.set[:rac][:grid][:udev][:flag] = true
  end
  action :create
end
end