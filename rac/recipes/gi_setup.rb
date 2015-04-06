unless node[:rac][:grid][:is_installed]


bash "run_gi_installer" do
    cwd "#{node[:rac][:install_dir]}/grid"
    environment (node[:rac][:grid][:env])  
#    code "sudo -Eu grid ./runInstaller -showProgress -silent -waitforcompletion -force -ignorePrereq -responseFile #{node[:rac][:rdbms][:install_dir]}/GI11g.rsp -invPtrLoc #{node[:rac][:grid][:base]}/oraInst.loc"
    code "sudo -Eu grid ./runInstaller -ignorePrereq -silent -force -showProgress -waitforcompletion -responseFile #{node[:rac][:install_dir]}/GI11g.rsp"
    returns [0, 6]
end

ruby_block 'set_gi_flag' do
  block do
    node.set[:rac][:grid][:is_installed] = true
  end
  action :create
end

end