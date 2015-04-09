unless node['rac']['rdbms']['is_installed']

node['rac']['rdbms']['install_files'].each do |zip_file|

  execute "unzip_oracle_media_#{zip_file}" do
    command "unzip -u #{zip_file}"
    user "oracle"
    group 'oinstall'
    cwd node['rac']['install_dir']
  end
end


# Filesystem template.
template "#{node['rac']['install_dir']}/db11R2.rsp" do
  owner 'oracle'
  group 'oinstall'
  mode '0644'
  source 'db11g.rsp.erb'
  variables(
    :INVENTORY_LOCATION => node['rac']['oracle']['inventory'],
    :ORACLE_BASE => node['rac']['oracle']['base'],
    :ORACLE_HOME => node['rac']['oracle']['home'],
    :cluster_nodes => node['rac']['grid']['cluster']['node1']['name']
    )
end



bash 'run_rdbms_installer' do
    cwd "#{node['rac']['install_dir']}/database"
    environment (node['rac']['rdbms']['env'])
    code "sudo -Eu oracle ./runInstaller -showProgress -silent -waitforcompletion -ignorePrereq -responseFile #{node['rac']['install_dir']}/db11R2.rsp "
    returns [0, 6]
  end

execute 'root_rdbms_node1' do
    command "#{node['rac']['oracle']['home']}/root.sh"
  end

#execute "root_rdbms_node2" do
#  command "ssh #{node['rac']['grid']['cluster']['node2']['name']} #{node['rac']['oracle']['home']}/root.sh"
#end

#execute "root_rdbms_node3" do
#  command "ssh #{node['rac']['grid']['cluster']['node3']['name']} #{node['rac']['oracle']['home']}/root.sh"
#end


  ruby_block 'set_rdbms_install_flag' do
  block do
    node.set['rac']['rdbms']['is_installed'] = true
  end
  action :create
end

end