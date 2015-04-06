#udev setting
unless node[:rac][:grid][:udev][:flag]

execute 'whitspace' do
  command 'echo "options=--whitelisted --replace-whitespace"  >> /etc/scsi_id.config'
  not_if { File.exists?("/etc/udev/rules.d/99-oracle-asmdevices.rules" ) }
end

cookbook_file "/dev/udev.sh" do
   mode '0750'
   action :create_if_missing
end

bash 'udev_setting' do
  cwd "/dev/"
  code "./udev.sh > /etc/udev/rules.d/99-oracle-asmdevices.rules"
  not_if { File.exists?("/etc/udev/rules.d/99-oracle-asmdevices.rules" ) }
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