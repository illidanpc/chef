template "/u01/cfgrsp.properties" do
  owner 'grid'
  group 'oinstall'
  mode '0755'
  source 'cfgrsp.erb'
  variables(
  	:asm_pw => node[:rac][:grid][:asm][:pw]
  	)
end

execute "cfg" do
  cwd "#{node[:rac][:grid][:home]}/cfgtoollogs/"
  command "sudo -Eu grid ./configToolAllCommands RESPONSE_FILE=/u01/cfgrsp.properties"
end

