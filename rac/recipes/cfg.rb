template "/u01/cfgrsp.properties" do
  owner 'grid'
  group 'oinstall'
  mode '0600'
  source 'cfgrsp.erb'
  variables(
  	:asm_pw => node['rac']['grid']['asm']['pw']
  	)
  notifies :run, 'execute[cfg]',:immediately
end

execute "cfg" do
  cwd "#{node['rac']['grid']['home']}/cfgtoollogs/"
  command "sudo -Eu grid ./configToolAllCommands RESPONSE_FILE=/u01/cfgrsp.properties"
  returns [0,3]
  action :nothing
end

