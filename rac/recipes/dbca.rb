unless node['rac']['sid']['flag']

bash "create_db" do
    cwd "#{node['rac']['oracle']['home']}/bin"
    code "sudo -Eu oracle ./dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbName #{node['rac']['oracle']['dbname']} -sid #{node['rac']['oracle']['dbname']} -SysPassword #{node['rac']['rdbms']['sys_pw']} -SystemPassword #{node['rac']['rdbms']['system_pw']} -emConfiguration NONE -redoLogFileSize 500 -storageType ASM -asmSysPassword #{node['rac']['rdbms']['asmsys_pw']} -diskGroupName DATA_DG -recoveryGroupName ARCH_DG -recoveryAreaDestination ARCH_DG -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16 -totalMemory 1050 -databaseType MULTIPURPOSE -nodelist #{node['rac']['grid']['cluster']['node1']['name']}"
    returns [0, 6]
end

ruby_block 'set_sid_flag' do
  block do
    node.set['rac']['sid']['flag'] = true
  end
  action :create
end
end