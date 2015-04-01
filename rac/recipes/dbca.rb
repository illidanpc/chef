bash "create_db" do
    cwd "/u01/app/oracle/product/11.2.0/db_1/bin"
    code "sudo -Eu oracle ./dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbName chefming -sid chefming -SysPassword dba123 -SystemPassword dba123 -emConfiguration NONE -redoLogFileSize 500 -storageType ASM -asmSysPassword dba123 -diskGroupName DATA_DG -recoveryGroupName ARCH_DG -recoveryAreaDestination ARCH_DG -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16 -totalMemory 1050 -databaseType MULTIPURPOSE -nodelist racliu1,racliu2,racliu3"
    returns [0, 6]
end

