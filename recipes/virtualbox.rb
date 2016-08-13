#
# Cookbook Name:: desktop
# Recipe:: virtualbox
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

include_recipe 'apt'

apt_repository 'virtualbox' do
  uri 'http://download.virtualbox.org/virtualbox/debian'
  components ['contrib']
  distribution node[:lsb][:codename]
  key 'https://www.virtualbox.org/download/oracle_vbox_2016.asc'
  action :add
end

package 'virtualbox-4.3' do
  action :remove
  only_if 'dpkg --get-selections | grep virtualbox-4.3'
end
   
package [ 
         'build-essential',
         'dkms',
         'virtualbox-5.0' 
        ] do
  action :install
  timeout 3600
end

group 'vboxusers' do
  append true
  members node['desktop']['user']['name']
end
