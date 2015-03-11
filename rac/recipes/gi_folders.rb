

#setting GI home
[node[:oracle][:grid][:base], node[:oracle][:grid][:home],node[:oracle][:grid][:inventory],node[:oracle][:rdbms][:install_dir]].each do |dir|
  directory dir do
    owner 'grid'
    group 'oinstall'
    mode '0755'
    action :create
    recursive true
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

yum_package 'unzip'


execute "unzip_grid_media" do
    command "unzip #{node[:oracle][:grid][:install_files]}"
    user "grid"
    group 'oinstall'
    cwd node[:oracle][:rdbms][:install_dir]
end