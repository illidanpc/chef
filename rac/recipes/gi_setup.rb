file "#{node[:oracle][:grid][:base]}/oraInst.loc" do
  owner "grid"
  group 'oinstall'
  content "inst_group=oinstall\ninventory_loc=/g01/grid/app/oraInventory"
end

bash "run_gi_installer" do
    cwd "#{node[:oracle][:rdbms][:install_dir]}/grid"
    environment (node[:oracle][:rdbms][:env])
    code "sudo -Eu grid ./runInstaller -ignorePrereq -silent -force -responseFile #{node[:oracle][:rdbms][:install_dir]}/GI11g.rsp -invPtrLoc #{node[:oracle][:grid][:base]}/oraInst.loc"
    returns [0, 6]
end

ruby_block 'set_gi_flag' do
  block do
    node.set[:oracle][:grid][:is_installed] = true
  end
  action :create
end
