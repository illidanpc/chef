#udev setting
unless node[:rac][:grid][:udev][:flag]

#for linux 6
#execute 'whitspace' do
#  command 'echo "options=--whitelisted --replace-whitespace"  >> /etc/scsi_id.config'
#  not_if { File.exists?("/etc/udev/rules.d/99-oracle-asmdevices.rules" ) }
#end

cookbook_file "etc/udev/rules.d/99-oracle-asmdevices.rules" do
   mode '0750'
   source 'udev_rules'
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