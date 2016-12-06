#
# Cookbook Name:: desktop
# Recipe:: user
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
# This recipe configures the sudo-enabled user account.
# Other recipes assume this will be the primary desktop user.
#
node['desktop']['user'].tap do |user|
  group user['group'] do
    gid user['gid']
  end
  
  user user['name'] do
    comment "#{node['fqdn']} administrator"
    uid user['uid']
    gid user['group']
    home user['home']
    shell '/bin/bash'
    manage_home user['home']['manage?']
  end

  user['home']['directories'].each do |dir|
    directory user['home'] + "/#{dir}" do
      owner user['name']
      group user['group']
      mode 0700
      recursive true
    end
  end

  file "/etc/sudoers.d/#{user['name']}" do
    user 'root'
    group 'root'
    mode 0440
    content <<-EOM.gsub(/^ {6}/,'')
      # This file is maintained by Chef.
      # Local changes will be overwritten.
      #{user['name']} ALL=(ALL:ALL) NOPASSWD: ALL
    EOM
  end
end

file "/etc/sudoers.d/proxy" do
    user 'root'
    group 'root'
    mode 0440
    content <<-EOM.gsub(/^ {6}/,'')
      # This file is maintained by Chef.
      # Local changes will be overwritten.
      Defaults env_keep += "http_proxy https_proxy"
    EOM
end
