#
# Cookbook Name:: oracle
# Recipe:: default
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

# Configure Oracle user, install the RDBMS's dependencies, configure
# kernel parameters, install the binaries and apply latest patch.
recipe[rac::gi_folders], recipe[gi]
# Set up and configure the oracle user.
include_recipe 'rac::gi_user_config' unless node[:oracle][:grid][:user][:flag]

## Install dependencies and configure kernel parameters.

include_recipe 'oracle::deps_install' unless node[:oracle][:grid][:deps][:flag]


# Setting up kernel parameters
include_recipe 'oracle::kernel_params' unless node[:oracle][:kernel][:flag]

# Udev
include_recipe 'oracle::udev' unless node[:oracle][:grid][:udev][:flag]
# GI folders
include_recipe 'oracle::gi_folders' unless node[:oracle][:grid][:gf][:flag]

# GI self
include_recipe 'oracle::gi_setup' unless node[:oracle][:grid][:is_installed]

