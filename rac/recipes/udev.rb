#udev setting
cookbook_file "/dev/udev.sh" do
   owner 'oracle'
   group 'oinstall'
   mode '0644'
end

bash 'udev_setting' do
  cwd "/dev/"
  code "./udev.sh > /etc/udev/rules.d/99-oracle-asmdevices.rules"
end

bash 'udev_start' do
	code "start_udev"
end
