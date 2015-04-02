#
# Cookbook Name:: oracle
# Attributes::default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

## Settings specific to the Oracle user.
default[:oracle][:user][:uid] = 201
default[:oracle][:user][:gid] = 201
default[:oracle][:user][:shell] = '/bin/ksh'
default[:oracle][:user][:sup_grps] = {'dba' => 202,'asmdba'=> 5001}
default[:oracle][:user][:pw_set] = false
default[:oracle][:grid][:pw_set] = false
#default[:oracle][:user][:edb] = 'oracle'
#default[:oracle][:user][:edb_item] = 'foo'
default[:oracle][:user][:pw]='oracle'
default[:oracle][:grid][:user][:flag]=false

default[:oracle][:grid][:uid]= 301
default[:oracle][:grid][:sup_grps]= {'dba'=>202, 'asmadmin' =>5000, 'asmdba'=> 5001,'asmoper'=>5002}
default[:oracle][:grid][:pw]='grid'


# Cluster setting

default[:oracle][:grid][:scan][:name]= 'red-cluster-scan'
default[:oracle][:grid][:scan][:port]= '1623'
default[:oracle][:grid][:cluster][:name]= 'red-cluster'
default[:oracle][:grid][:cluster][:node1]= {'name' => 'racliu1', 'vip' => 'racliu1-vip', 'pubip' => '10.66.2.178'}
default[:oracle][:grid][:cluster][:node2]= {'name' => 'racliu2', 'vip' => 'racliu2-vip', 'pubip' => '10.66.2.177'}
default[:oracle][:grid][:cluster][:node3]= {'name' => 'racliu3', 'vip' => 'racliu3-vip', 'pubip' => '10.66.2.176'}
default[:oracle][:grid][:cluster][:eth0_inter] = '10.66.2.0'
default[:oracle][:grid][:cluster][:eth1_inter] = '172.168.1.0'
default[:oracle][:grid][:cluster][:dg_name] = 'GRID_DG'
default[:oracle][:grid][:cluster][:ocr_dg] = '/dev/asm-diskb,/dev/asm-diskc,/dev/asm-diskd'
default[:oracle][:grid][:cluster][:disk_string]= '/dev/asm*'


# General Oracle settings.
default[:oracle][:ora_base] = '/u01/app/oracle'
default[:oracle][:ora_inventory] = '/u01/app/oraInventory'
default[:oracle][:grid][:base] = '/g01/grid/app/grid'
default[:oracle][:grid][:p_base] = '/g01/grid/app'
default[:oracle][:grid][:home] = '/g01/grid/app/11.2.0/grid'
default[:oracle][:grid][:inventory] = '/g01/grid/app/oraInventory'
default[:oracle][:grid][:asm][:sid]='+ASM1'
default[:oracle][:grid][:asm][:pw]="Oracle_12345"

## Settings specific to the Oracle RDBMS proper.
default[:oracle][:rdbms][:dbbin_version] = '11g'
default[:oracle][:rdbms][:ora_home] = "#{node[:oracle][:ora_base]}/product/11.2.0.4"
default[:oracle][:rdbms][:ora_home_12c] = "#{node[:oracle][:ora_base]}/12R1"
default[:oracle][:rdbms][:is_installed] = false
default[:oracle][:grid][:is_installed] = false
default[:oracle][:rdbms][:install_info] = {}
default[:oracle][:rdbms][:install_dir] = "/s01"
default[:oracle][:rdbms][:response_file_url] = ''
default[:oracle][:rdbms][:db_create_template] = 'default_template.dbt'
default[:oracle][:kernel][:flag]=false
default[:oracle][:grid][:udev][:flag]=false
default[:oracle][:grid][:gf][:flag]=false

# Dependencies for Oracle 11.2.
# Source: <http://docs.oracle.com/cd/E11882_01/install.112/e24321/pre_install.htm#CIHFICFD>
# We omit version-release info by design, as their requirements are satisfied by
# CentOS 6.4, which is the minimum version targeted by oracle.
default[:oracle][:rdbms][:deps] = ['binutils', 'compat-libcap1', 'compat-libstdc++-33', 'gcc', 'gcc-c++', 'glibc',
                                   'glibc-devel', 'ksh', 'libgcc', 'libstdc++', 'libstdc++-devel', 'libaio',
                                   'libaio-devel', 'make', 'sysstat','elfutils-libelf-devel']
default[:oracle][:grid][:deps][:flag]=false

# Oracle environment for 11g
default[:oracle][:rdbms][:env] = {'ORACLE_BASE' => node[:oracle][:ora_base],
                                  'ORACLE_HOME' => node[:oracle][:rdbms][:ora_home],
                                  'PATH' => "/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/sbin:#{node[:oracle][:ora_base]}/dba/bin:#{node[:oracle][:rdbms][:ora_home]}/bin:#{node[:oracle][:rdbms][:ora_home]}/OPatch"}

default[:oracle][:grid][:env] =  {'ORACLE_BASE' => '/u01/app/grid',
                                  'ORACLE_HOME' => '/u01/11.2.0/grid',
                                  'PATH' => "/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/sbin:/u01/11.2.0/grid/bin:/u01/11.2.0/grid/OPatch"}

default[:oracle][:rdbms][:install_files] = ['/sft/p13390677_112040_Linux-x86-64_1of7.zip',
                                            '/sft/p13390677_112040_Linux-x86-64_2of7.zip']

default[:oracle][:grid][:install_files] = '/sft/p13390677_112040_Linux-x86-64_3of7.zip'

# Passwords set by createdb.rb for the default open database users.
# By order of appearance, those are: SYS, SYSTEM and DBSNMP.
# The latter is for the OEM agent.
default[:oracle][:rdbms][:sys_pw] = 'sys_pw_goes_here'
default[:oracle][:rdbms][:system_pw] = 'system_pw_goes_here'
default[:oracle][:rdbms][:dbsnmp_pw] = 'dbsnmp_pw_goes_here'

# Settings related to patching.
default[:oracle][:rdbms][:opatch_update_url] = '/sft/p13390677_112040_Linux-x86-64.zip'
default[:oracle][:rdbms][:latest_patch][:url] = '/sft/p13390677_112040_Linux-x86-64.zip'



# Typically the latest patch's expanded directory's name will match
# the part of the latest patch's filename following the initial 'p', 
# up until , and excluding, the first '_', but this is not guaranteed to
# always be the case.
default[:oracle][:rdbms][:latest_patch][:dirname] = '16619892'
default[:oracle][:rdbms][:latest_patch][:dirname_12c] = '18031528'
default[:oracle][:rdbms][:latest_patch][:is_installed] = true


# Hash of DBs to create; the keys are the DBs' names, the values are Booleans,
# with true indicating the DB has already been created and should be skipped
# by createdb.rb. We don't create any DBs by default, hence the attribute's
# value is set to an empty Hash.
default[:oracle][:rdbms][:dbs] = {}
# The directory under which we install the DBs.
default[:oracle][:rdbms][:dbs_root] = "/d01/oradata"

# Local emConfiguration
# Attributes for the local database dbcontrol for all databases.
default[:oracle][:rdbms][:dbconsole][:emconfig] = true
default[:oracle][:rdbms][:dbconsole][:sysman_pw] = 'sysman_pw_goes_here'
default[:oracle][:rdbms][:dbconsole][:notification_email] = 'foo@bar.inet'
default[:oracle][:rdbms][:dbconsole][:outgoing_mail] = 'mailhost'
