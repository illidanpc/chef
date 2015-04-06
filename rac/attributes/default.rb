#
# Cookbook Name:: rac
# Attributes::default
#
#

## Settings specific to the grid and oracle user in OS .
default[:rac][:oracle][:user][:uid] = 201
default[:rac][:oracle][:user][:gid] = 201
default[:rac][:oracle][:user][:shell] = '/bin/ksh'
default[:rac][:oracle][:user][:sup_grps] = {'dba' => 202,'asmdba'=> 5001}
default[:rac][:oracle][:user][:pw_set] = false
default[:rac][:oracle][:user][:pw]='oracle'


#default[:rac][:user][:edb] = 'oracle' #test only for the databag 
#default[:rac][:user][:edb_item] = 'foo' #test only for the databag 
default[:rac][:grid][:user][:pw_set] = false
default[:rac][:grid][:user][:pw]='grid'
default[:rac][:grid][:user][:uid]= 301
default[:rac][:grid][:user][:sup_grps]= {'dba'=>202, 'asmadmin' =>5000, 'asmdba'=> 5001,'asmoper'=>5002}



# Cluster setting

default[:rac][:grid][:scan][:name]= 'ora-test-scan'
default[:rac][:grid][:scan][:port]= '1521'

default[:rac][:grid][:cluster][:name]= 'ora-test-scan'
default[:rac][:grid][:cluster][:node1]= {'name' => 'racliu1', 'fqdn' => 'racliu1.covisint.com', 'vip' => 'racliu1-vip', 'pubip' => '10.66.2.178'}
default[:rac][:grid][:cluster][:node2]= {'name' => 'racliu2', 'fqdn' => 'racliu2.covisint.com','vip' => 'racliu2-vip', 'pubip' => '10.66.2.177'}
default[:rac][:grid][:cluster][:node3]= {'name' => 'racliu3', 'fqdn' => 'racliu3.covisint.com','vip' => 'racliu3-vip', 'pubip' => '10.66.2.176'}
default[:rac][:grid][:cluster][:eth0_inter] = '10.66.0.0'
default[:rac][:grid][:cluster][:eth1_inter] = '192.168.0.0'




# folder path
default[:rac][:oracle][:base] = '/u01/app/oracle'
default[:rac][:oracle][:home] = '/u01/app/oracle/product/11.2.0/db_1'
default[:rac][:oracle][:inventory] = '/u01/app/oraInventory'
default[:rac][:oracle][:dbname] = 'chefming'
default[:rac][:oracle][:sid] = 'chefming1'

default[:rac][:grid][:base] = '/u01/app/grid'
default[:rac][:grid][:home] = '/u01/11.2.0/grid'
default[:rac][:grid][:inventory] = '/u01/app/oraInventory'
default[:rac][:install_info] = {}
default[:rac][:install_dir] = "/s01"

# ASM setting
default[:rac][:grid][:asm][:sid]='+ASM1'
default[:rac][:grid][:asm][:pw]="Covisint123"
default[:rac][:grid][:asm][:au_size]='1'
default[:rac][:grid][:asm][:dg_name] = 'VOTE_DISK'
default[:rac][:grid][:asm][:ocr_dg] = '/dev/asmdisk/vote_disk_01,/dev/asmdisk/vote_disk_02,/dev/asmdisk/vote_disk_03'
default[:rac][:grid][:asm][:disk_string]= '/dev/asmdisk/*'

## Settings specific to the Oracle RDBMS proper.
default[:rac][:rdbms][:dbbin_version] = '11g'
default[:rac][:rdbms][:response_file_url] = ''
default[:rac][:rdbms][:db_create_template] = 'default_template.dbt'


# Dependencies for Oracle 11.2.
# Source: <http://docs.oracle.com/cd/E11882_01/install.112/e24321/pre_install.htm#CIHFICFD>
# We omit version-release info by design, as their requirements are satisfied by
# CentOS 6.4, which is the minimum version targeted by oracle.
default[:rac][:deps][:comp] = ['binutils', 'compat-libcap1', 'compat-libstdc++-33', 'gcc', 'gcc-c++', 'glibc',
                         'glibc-devel', 'ksh', 'libgcc', 'libstdc++', 'libstdc++-devel', 'libaio',
                          'libaio-devel', 'make', 'sysstat','elfutils-libelf-devel']


# Oracle environment for 11g
default[:rac][:rdbms][:env] = {'ORACLE_BASE' => node[:rac][:oracle][:base],
                                  'ORACLE_HOME' => node[:rac][:oracle][:home],
                                  'PATH' => "/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/sbin:#{node[:rac][:oracle][:base]}/dba/bin:#{node[:rac][:oracle][:home]}/bin:#{node[:rac][:oracle][:home]}/OPatch"}

default[:rac][:grid][:env] =  {'ORACLE_BASE' => node[:rac][:grid][:base],
                                  'ORACLE_HOME' => node[:rac][:grid][:home],
                                  'PATH' => "/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/sbin:#{node[:rac][:grid][:base]}/bin:#{node[:rac][:grid][:home]}/OPatch"}

default[:rac][:rdbms][:install_files] = ['/sft/p13390677_112040_Linux-x86-64_1of7.zip',
                                         '/sft/p13390677_112040_Linux-x86-64_2of7.zip']

default[:rac][:grid][:install_files] = '/sft/p13390677_112040_Linux-x86-64_3of7.zip'

# Passwords set by createdb.rb for the default open database users.
# By order of appearance, those are: SYS, SYSTEM and DBSNMP.
# The latter is for the OEM agent.
default[:rac][:rdbms][:sys_pw] = 'dba123'
default[:rac][:rdbms][:system_pw] = 'dba123'
default[:rac][:rdbms][:dbsnmp_pw] = 'dba123'
default[:rac][:rdbms][:asmsys_pw]= 'dba123'

# Settings related to patching.
default[:rac][:rdbms][:opatch_update_url] = '/sft/p13390677_112040_Linux-x86-64.zip'
default[:rac][:rdbms][:latest_patch][:url] = '/sft/p13390677_112040_Linux-x86-64.zip'



# Typically the latest patch's expanded directory's name will match
# the part of the latest patch's filename following the initial 'p', 
# up until , and excluding, the first '_', but this is not guaranteed to
# always be the case.
default[:rac][:rdbms][:latest_patch][:dirname] = '16619892'
default[:rac][:rdbms][:latest_patch][:is_installed] = true


# Hash of DBs to create; the keys are the DBs' names, the values are Booleans,
# with true indicating the DB has already been created and should be skipped
# by createdb.rb. We don't create any DBs by default, hence the attribute's
# value is set to an empty Hash.
default[:rac][:rdbms][:dbs] = {}
# The directory under which we install the DBs.
default[:rac][:rdbms][:dbs_root] = "/d01/oradata"

# Local emConfiguration
# Attributes for the local database dbcontrol for all databases.
default[:rac][:rdbms][:dbconsole][:emconfig] = true
default[:rac][:rdbms][:dbconsole][:sysman_pw] = 'sysman_pw_goes_here'
default[:rac][:rdbms][:dbconsole][:notification_email] = 'foo@bar.inet'
default[:rac][:rdbms][:dbconsole][:outgoing_mail] = 'mailhost'


#flags 
default[:rac][:user][:flag]=false
default[:rac][:kernel][:flag]=false
default[:rac][:grid][:udev][:flag]=false
default[:rac][:grid][:gf][:flag]=false
default[:rac][:rdbms][:is_installed] = false
default[:rac][:grid][:is_installed] = false
default[:rac][:deps][:flag]=false
default[:rac][:sid][:flag]=false
default[:rac][:grid][:slave][:flag]=false
default[:rac][:grid][:root][:flag]=false
default[:rac][:grid][:asm][:flag]=false