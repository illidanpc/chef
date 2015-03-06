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


#setting GI home
[node[:oracle][:grid][:base], node[:oracle][:grid][:soft],node[:oracle][:grid][:inventory]].each do |dir|
  directory dir do
    owner 'grid'
    group 'oinstall'
    mode '0755'
    action :create
  end
end

# GI template.
template "#{node[:oracle][:rdbms][:install_dir]}/GI11g.rsp" do
  owner 'grid'
  group 'oinstall'
  mode '0644'
end