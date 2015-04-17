unless node['rac']['grid']['gf']['flag']

#setting GI home
[node['rac']['grid']['base'], node['rac']['grid']['home'],node['rac']['grid']['inventory'],node['rac']['install_dir']].each do |dir|
  directory dir do
    owner 'grid'
    group 'oinstall'
    mode '0775'
    action :create
    recursive true
  end
end

#setting oracle home
[node['rac']['oracle']['base'], node['rac']['oracle']['home'],node['rac']['oracle']['inventory'],node['rac']['install_dir']].each do |dir|
  directory dir do
    owner 'oracle'
    group 'oinstall'
    mode '0775'
    action :create
    recursive true
  end
end

execute "chown_back_to_grid" do
  command "chown -R grid.oinstall /u01"
end

execute "chown_back_to_oracle" do
  command "chown -R oracle.oinstall /u01/app/oracle"
end


# GI rsp template.
template "#{node['rac']['install_dir']}/GI11g.rsp" do
  source 'GI11g.rsp.erb'
  owner 'grid'
  group 'oinstall'
  mode '0644'
  variables(
    :INVENTORY_LOCATION => node['rac']['grid']['inventory'],
    :ORACLE_BASE => node['rac']['grid']['base'],
    :ORACLE_HOME => node['rac']['grid']['home'],
    :scan_name => node['rac']['grid']['scan']['name'],
    :scan_port => node['rac']['grid']['scan']['port'],
    :cluster_name => node['rac']['grid']['cluster']['name'],
    :cluster_nodes => node['rac']['grid']['cluster']['node1']['fqdn'] + ":" + node['rac']['grid']['cluster']['node1']['vip'],
    :eth0_inter => node['rac']['grid']['cluster']['eth0_inter'],
    :eth1_inter => node['rac']['grid']['cluster']['eth1_inter'],
    :dg_name => node['rac']['grid']['asm']['dg_name'],
    :ocr_dg=> node['rac']['grid']['asm']['ocr_dg'],
    :disk_string=> node['rac']['grid']['asm']['disk_string'],
    :asm_pw=> node['rac']['grid']['asm']['pw'],
    :au_size=> node['rac']['grid']['asm']['au_size']
  )
end

#yum_package 'unzip'


execute "unzip_grid_media" do
    command "unzip -u #{node['rac']['grid']['install_files']}"
    user "grid"
    group 'oinstall'
    cwd node['rac']['install_dir']
end

execute 'cvuqdisk_package' do
  command "rpm -Uvh #{node['rac']['install_dir']}/grid/rpm/cvuqdisk-1.0.9-1.rpm "
  returns [0,1]
end


ruby_block 'set_gf_flag' do
  block do
    node.set['rac']['grid']['gf']['flag'] = true
  end
  action :create
end

end