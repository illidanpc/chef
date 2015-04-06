#
# Cookbook Name:: oracle
# Recipe:: oracle_user_config
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
#
## Create and configure the oracle user. 
#


# Create the oracle user.
# The argument to useradd's -g option must be an already existing
# group, else useradd will raise an error.
# Therefore, we must create the oinstall group before we do the oracle user.
unless node[:rac][:user][:flag]
  
group 'oinstall' do
  gid node[:rac][:oracle][:user][:gid]
end

user 'grid' do
  uid node[:rac][:grid][:user][:uid]
  gid node[:rac][:oracle][:user][:gid]
  shell node[:rac][:oracle][:user][:shell]
  comment 'RAC Administrator'
  supports :manage_home => true
end

user 'oracle' do
  uid node[:rac][:oracle][:user][:uid]
  gid node[:rac][:oracle][:user][:gid]
  shell node[:rac][:oracle][:user][:shell]
  comment 'Oracle Administrator'
  supports :manage_home => true
end

yum_package File.basename(node[:rac][:oracle][:user][:shell])

# Configure the oracle user.
# Make it a member of the appropriate supplementary groups, and
# ensure its environment will be set up properly upon login.
node[:rac][:grid][:user][:sup_grps].each_key do |grp|
  group grp do
    gid node[:rac][:grid][:user][:sup_grps][grp]
    members ['grid']
    append true
  end
end

template "/home/grid/.profile" do
  source 'grid_profile.erb'
  owner 'grid'
  group 'oinstall'
  variables(
    :g_home=> node[:rac][:grid][:home],
    :g_base=> node[:rac][:grid][:base],
    :g_sid=> node[:rac][:grid][:asm][:sid]
    )
end

node[:rac][:oracle][:user][:sup_grps].each_key do |grp|
  group grp do
    gid node[:rac][:oracle][:user][:sup_grps][grp]
    members ['oracle']
    append true
  end
end

template "/home/oracle/.profile" do
  source 'ora_profile.erb'
  owner 'oracle'
  group 'oinstall'
  variables(
    :o_home=> node[:rac][:grid][:home],
    :o_base=> node[:rac][:grid][:base],
    :o_sid=> node[:rac][:grid][:asm][:sid]
    )
end

# Set the oracle user's password.
unless node[:rac][:grid][:user][:pw_set]
#  ora_edb_item = Chef::EncryptedDataBagItem.load(node[:rac][:user][:edb], node[:rac][:user][:edb_item])
  ora_pw = node[:rac][:grid][:user][:pw]

  # Note that output formatter will display the password on your terminal.
  execute 'change_grid_user_pw' do
    command "echo grid:#{ora_pw} | /usr/sbin/chpasswd"
  end
  
  ruby_block 'set_g_pw_attr' do
    block do
      node.set[:rac][:grid][:user][:pw_set] = true
    end
    action :create
  end
end

# Set the oracle user's password.
unless node[:rac][:oracle][:user][:pw_set]
#  ora_edb_item = Chef::EncryptedDataBagItem.load(node[:rac][:user][:edb], node[:rac][:user][:edb_item])
  ora_pw = node[:rac][:oracle][:user][:pw]

  # Note that output formatter will display the password on your terminal.
  execute 'change_oracle_user_pw' do
    command "echo oracle:#{ora_pw} | /usr/sbin/chpasswd"
  end
  
  ruby_block 'set_o_pw_attr' do
    block do
      node.set[:rac][:oracle][:user][:pw_set] = true
    end
    action :create
  end
end


# Set resource limits for the  user.
cookbook_file '/etc/security/limits.conf' do
  mode '0644'
  source 'ora_limits'
end

ruby_block 'set_gi_user_flag' do
  block do
    node.set[:rac][:grid][:user][:flag] = true
  end
  action :create
end

end