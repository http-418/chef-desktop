#
# Cookbook Name:: desktop
# Recipe:: ssh
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

package 'openssh-server'
package 'openssh-client'

template '/etc/ssh/sshd_config' do
  mode 0400
  source 'ssh/sshd_config.erb'
  variables(sftp_chroots: node['desktop']['ssh']['sftp_chroots'])
  notifies :reload, 'service[ssh]'
end

service 'ssh' do
  action [ :enable, :start ]
end

