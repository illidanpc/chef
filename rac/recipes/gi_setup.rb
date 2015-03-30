unless node[:oracle][:grid][:is_installed]
file "#{node[:oracle][:grid][:base]}/oraInst.loc" do
  owner "grid"
  group 'oinstall'
  content "inst_group=oinstall\ninventory_loc=/g01/grid/app/oraInventory"
end


bash "run_gi_installer" do
    cwd "#{node[:oracle][:rdbms][:install_dir]}/grid"
    environment (node[:oracle][:grid][:env])  
#    code "sudo -Eu grid ./runInstaller -showProgress -silent -waitforcompletion -force -ignorePrereq -responseFile #{node[:oracle][:rdbms][:install_dir]}/GI11g.rsp -invPtrLoc #{node[:oracle][:grid][:base]}/oraInst.loc"
    code "sudo -Eu grid ./runInstaller -ignorePrereq -silent -force -responseFile /home/grid/grid_install_0323.rsp"
    returns [0, 6]
end

ruby_block 'set_gi_flag' do
  block do
    node.set[:oracle][:grid][:is_installed] = true
  end
  action :create
end

end