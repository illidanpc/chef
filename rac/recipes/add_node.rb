
bash "add_gi" do
  code "sudo -Eu grid ssh #{node['rac']['grid']['cluster']['node1']['name']} /u01/11.2.0/grid/oui/bin/addNode.sh -ignorePrereq -silent -force "CLUSTER_NEW_NODES={#{node['rac']['grid']['cluster']['node2']['name']}}" "CLUSTER_NEW_VIRTUAL_HOSTNAMES={#{node['rac']['grid']['cluster']['node2']['vip']}" "
  env "IGNORE_PREADDNODE_CHECKS=Y "
end

bash "orainstRoot_node2" do
  cwd "#{node[:rac][:grid][:inventory]}"
  code "./orainstRoot.sh"
end

bash "crs_root_node2" do
  cwd "/u01/11.2.0/grid/perl/lib/5.10.0"
  code "#{node[:rac][:grid][:home]}/root.sh"
end


bash "add_rdbms" do
  code "sudo -Eu oracle ssh #{node['rac']['grid']['cluster']['node1']['name']} /u01/app/oracle/product/11.2.0/db_1/oui/bin/addNode.sh -silent "CLUSTER_NEW_NODES={#{node['rac']['grid']['cluster']['node2']['name']}}" "
end

execute "root_rdbms_node2" do
  command "/root.sh"
  cwd "#{node[:rac][:oracle][:home]}"
end

execute "add_instance" do
	command "sudo -Eu oracle ssh #{node['rac']['grid']['cluster']['node1']['name']} #{node[:rac][:oracle][:home]}/bin/dbca -silent -addInstance -nodeList #{node['rac']['grid']['cluster']['node2']['name']} -gdbName #{node[:rac][:oracle][:dbname]} -instanceName chefming2 -sysDBAUserName sys -sysDBAPassword #{node[:rac][:rdbms][:sys_pw]} "
end
