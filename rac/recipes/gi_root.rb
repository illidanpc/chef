unless node[:rac][:grid][:root][:flag]

bash "orainstRoot_node1" do
  cwd "#{node[:rac][:grid][:inventory]}"
  code "./orainstRoot.sh"
end

bash "crs_root_node1" do
  cwd "#{node[:rac][:grid][:home]}"
  code "./root.sh"
end

execute "orainstRoot_node2" do
  command "ssh #{node[:rac][:grid][:cluster][:node2][:name]} #{node[:rac][:grid][:inventory]}/orainstRoot.sh"
end

execute "crs_root_node2" do
  command "ssh #{node[:rac][:grid][:cluster][:node2][:name]} #{node[:rac][:grid][:home]}/root.sh"
end

execute "orainstRoot_node3" do
  command "ssh #{node[:rac][:grid][:cluster][:node3][:name]} #{node[:rac][:grid][:inventory]}/orainstRoot.sh"
end

execute "crs_root_node3" do
  command "ssh #{node[:rac][:grid][:cluster][:node3][:name]} #{node[:rac][:grid][:home]}/root.sh"
end

ruby_block 'set_root_flag' do
  block do
    node.set[:rac][:grid][:root][:flag] = true
  end
  action :create
end

end