#
# Cookbook Name:: oracle
# Recipe:: deps_install
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
## Install Oracle RDBMS' dependencies.
#

node[:oracle][:rdbms][:deps].each do |dep|
  yum_package dep
end

execute 'cvuqdisk_package' do
  command 'rpm -Uvh /sft/grid/rpm/cvuqdisk-1.0.9-1.rpm 2>/dev/null'
  returns [0,1]
end