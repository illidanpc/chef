#udev setting

execute 'whitspace' do
  command 'echo "options=--whitelisted --replace-whitespace"  >> /etc/scsi_id.config'
  not_if { File.exists?("/etc/udev/rules.d/99-oracle-asmdevices.rules" ) }
end

cookbook_file "/dev/udev.sh" do
   owner 'oracle'
   group 'oinstall'
   mode '0777'
   action :create_if_missing
end

bash 'udev_setting' do
  cwd "/dev/"
  code "./udev.sh > /etc/udev/rules.d/99-oracle-asmdevices.rules"
  not_if { File.exists?("/etc/udev/rules.d/99-oracle-asmdevices.rules" ) }
end

bash 'udev_start' do
	code "/sbin/start_udev"
	not_if { File.exists?("/etc/udev/rules.d/99-oracle-asmdevices.rules" ) }
end


ruby_block 'set_udev_flag' do
  block do
    node.set[:oracle][:grid][:udev][:flag] = true
  end
  action :create
end
