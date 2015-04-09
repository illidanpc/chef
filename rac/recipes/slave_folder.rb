unless node['rac']['grid']['slave']['flag']

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

ruby_block 'set_slave_flag' do
  block do
    node.set['rac']['grid']['slave']['flag'] = true
  end
  action :create
end

end