
bash "add_gi" do
  code "ssh #{node['rac']['grid']['cluster']['node1']['name']} sudo -Eu grid /u01/11.2.0/grid/oui/bin/addNode.sh -ignorePrereq -silent -force \"CLUSTER_NEW_NODES={#{node['rac']['grid']['cluster']['new_node']['name']}}\" \"CLUSTER_NEW_VIRTUAL_HOSTNAMES={#{node['rac']['grid']['cluster']['new_node']['vip']}}\" "
  environment 'IGNORE_PREADDNODE_CHECKS' => 'Y'
end

bash "orainstRoot_new_node" do
  cwd "#{node['rac']['grid']['inventory']}"
  code "./orainstRoot.sh"
end

bash "crs_root_new_node" do
  cwd "/u01/11.2.0/grid/perl/lib/5.10.0"
  code "#{node['rac']['grid']['home']}/root.sh"
end


bash "add_rdbms" do
  code "ssh #{node['rac']['grid']['cluster']['node1']['name']} sudo -Eu oracle /u01/app/oracle/product/11.2.0/db_1/oui/bin/addNode.sh -silent \"CLUSTER_NEW_NODES={#{node['rac']['grid']['cluster']['new_node']['name']}}\" "
end

execute "root_rdbms_new_node" do
  command "./root.sh"
  cwd "#{node['rac']['oracle']['home']}"
end

execute "add_instance" do
	command "ssh #{node['rac']['grid']['cluster']['node1']['name']} sudo -Eu oracle #{node['rac]['oracle]['home']}/bin/dbca -silent -addInstance -nodeList #{node['rac']['grid']['cluster']['new_node']['name']} -gdbName #{node['rac]['oracle]['dbname']} -instanceName #{node['rac']['oracle']['sid']} -sysDBAUserName sys -sysDBAPassword #{node['rac]['rdbms]['sys_pw']} "
end
