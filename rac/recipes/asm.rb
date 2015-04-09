unless node['rac']['grid']['asm']['flag']

execute "asm_data" do
  cwd "#{node['rac']['grid']['home']}/bin"
  command "sudo -Eu grid ./asmca -silent -createDiskGroup -diskString '#{node['rac']['grid']['asm']['disk_string']}' -diskGroupName DATA_DG -diskList /dev/asmdisk/db_data_01 -redundancy EXTERNAL -au_size #{node['rac']['grid']['asm']['au_size']} -sysAsmPassword oracle"
end

execute "asm_arch" do
  cwd "#{node['rac']['grid']['home']}/bin"
  command "sudo -Eu grid ./asmca -silent -createDiskGroup -diskString '#{node['rac']['grid']['asm']['disk_string']}' -diskGroupName ARCH_DG -diskList /dev/asmdisk/db_arch_01 -redundancy EXTERNAL -au_size #{node['rac']['grid']['asm']['au_size']} -sysAsmPassword oracle"
end

execute "asm_redo" do
  cwd "#{node['rac']['grid']['home']}/bin"
  command "sudo -Eu grid ./asmca -silent -createDiskGroup -diskString '#{node['rac']['grid']['asm']['disk_string']}' -diskGroupName REDO_DG -diskList /dev/asmdisk/db_redo_01 -redundancy EXTERNAL -au_size #{node['rac']['grid']['asm']['au_size']} -sysAsmPassword oracle"
end

ruby_block 'set_asm_flag' do
  block do
    node.set['rac']['grid']['asm']['flag'] = true
  end
  action :create
end

end