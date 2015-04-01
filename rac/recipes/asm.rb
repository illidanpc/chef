execute "asm_data" do
  cwd "/u01/11.2.0/grid/bin"
  command "sudo -Eu grid ./asmca -silent -createDiskGroup -diskString '/dev/asmdisk/*' -diskGroupName DATA_DG -diskList /dev/asmdisk/db_data_01 -redundancy EXTERNAL -au_size 1 -sysAsmPassword oracle"
end

execute "asm_arch" do
  cwd "/u01/11.2.0/grid/bin"
  command "sudo -Eu grid ./asmca -silent -createDiskGroup -diskString '/dev/asmdisk/*' -diskGroupName ARCH_DG -diskList /dev/asmdisk/db_arch_01 -redundancy EXTERNAL -au_size 1 -sysAsmPassword oracle"
end

execute "asm_redo" do
  cwd "/u01/11.2.0/grid/bin"
  command "sudo -Eu grid ./asmca -silent -createDiskGroup -diskString '/dev/asmdisk/*' -diskGroupName REDO_DG -diskList /dev/asmdisk/db_redo_01 -redundancy EXTERNAL -au_size 1 -sysAsmPassword oracle"
end

