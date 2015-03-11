



 bash 'run_gi_installer' do
    cwd "#{node[:oracle][:rdbms][:install_dir]}/grid"
    environment (node[:oracle][:rdbms][:env])
    code "sudo -Eu grid ./runInstaller -showProgress -silent -waitforcompletion -ignoreSysPrereqs -responseFile #{node[:oracle][:rdbms][:install_dir]}/GI11G.rsp -invPtrLoc #{node[:oracle][:grid][:base]}/oraInst.loc"
    returns [0, 6]
  end

