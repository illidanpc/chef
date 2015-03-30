cookbook_file "/u01/cfgrsp.properties" do
  owner 'grid'
  group 'oinstall'
  mode '0755'
  source 'cfgrsp'
end

execute "cfg" do
  cwd "/u01/11.2.0/grid/cfgtoollogs/"
  command "./configToolAllCommands RESPONSE_FILE=/u01/cfgrsp.properties"
end

