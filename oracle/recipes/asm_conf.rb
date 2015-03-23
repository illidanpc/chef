
file "#{node[:oracle][:grid][:home]}/cfgtoollogs/cfgrsp.properties" do
  owner "grid"
  group 'oinstall'
  content "oracle.assistants.asm|S_ASMPASSWORD=Oracle_12345\noracle.assistants.asm|S_ASMMONITORPASSWORD==Oracle_12345"
end

execute "grid_dg start" do
  command "./configToolAllCommands RESPONSE_FILE=./cfgrsp.properties"
  cwd "#{node[:oracle][:grid][:home]}/cfgtoollogs"
end

execute "data_dg start" do
  command "asmca -silent -configureASM -sysAsmPassword Oracle_12345 -asmsnmpPassword Oracle_12345 -diskString '/dev/asm*' -diskGroupName DATA_DG -disk '/dev/asm-diske','/dev/asm-diskf','/dev/asm-diskg' -redundancy EXTERNAL"
  environment (node[:oracle][:grid][:env]) 
end

execute "FRA start" do
  command "asmca -silent -configureASM -sysAsmPassword Oracle_12345 -asmsnmpPassword Oracle_12345 -diskString '/dev/asm*' -diskGroupName FRA -disk '/dev/asm-diskh' -redundancy EXTERNAL"
  environment (node[:oracle][:grid][:env])
end

