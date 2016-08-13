#
# Cookbook Name:: desktop
# Recipe:: wireshark
#
# Copyright 2015 Andrew Jones
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
# Installs Wireshark and configures non-privileged access.
#
include_recipe 'apt'

package 'debconf-utils'

execute 'wireshark-preseed-dumpcap' do
  command 'echo "wireshark-common wireshark-common/install-setuid boolean true" | debconf-set-selections'
  not_if 'debconf-get-selections | grep wireshark-common/install-setuid | grep true'
  notifies :run, 'execute[wireshark-reconfigure]'
end

package 'wireshark'

execute 'wireshark-reconfigure' do
  command 'dpkg-reconfigure -f noninteractive wireshark-common'
  action :nothing
end

group 'wireshark' do
  action :modify
  members node['desktop']['user']['name']
  append true
end
