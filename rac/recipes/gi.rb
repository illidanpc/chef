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
[node[:oracle][:grid][:base], node[:oracle][:grid][:home],node[:oracle][:grid][:inventory]].each do |dir|
  directory dir do
    owner 'grid'
    group 'oinstall'
    mode '0755'
    action :create
  end
end

# GI rsp template.
template "#{node[:oracle][:rdbms][:install_dir]}/GI11g.rsp" do
  source 'GI11g.rsp.erb'
  owner 'grid'
  group 'oinstall'
  mode '0644'
  variables(
    :INVENTORY_LOCATION => node[:oracle][:grid][:inventory],
    :ORACLE_BASE => node[:oracle][:grid][:base],
    :ORACLE_HOME => node[:oracle][:grid][:home],
    :scan_name => node[:oracle][:grid][:scan][:name],
    :scan_port => node[:oracle][:grid][:scan][:port],
    :cluster_name => node[:oracle][:grid][:cluster][:name],
    :node1_name => node[:oracle][:grid][:cluster][:node1][:name],
    :node1_vip => node[:oracle][:grid][:cluster][:node1][:vip],
    :node2_name => node[:oracle][:grid][:cluster][:node2][:name],
    :node2_vip => node[:oracle][:grid][:cluster][:node2][:vip],
    :eth0_inter => node[:oracle][:grid][:cluster][:eth0_inter],
    :eth1_inter => node[:oracle][:grid][:cluster][:eth1_inter],
    :dg_name => node[:oracle][:grid][:cluster][:dg_name],
    :ocr_dg=> node[:oracle][:grid][:cluster][:ocr_dg],
    :disk_string=> node[:oracle][:grid][:cluster][:disk_string]

  )
end


 bash 'run_gi_installer' do
    cwd "#{node[:oracle][:rdbms][:install_dir]}/database"
    environment (node[:oracle][:rdbms][:env])
    code "sudo -Eu oracle ./runInstaller -showProgress -silent -waitforcompletion -ignoreSysPrereqs -responseFile #{node[:oracle][:rdbms][:install_dir]}/GI11G.rsp -invPtrLoc #{node[:oracle][:grid][:base]}/oraInst.loc"
    returns [0, 6]
  end

