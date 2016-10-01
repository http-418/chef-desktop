#
# Cookbook Name:: desktop
# Recipe:: firefox
#
# Copyright 2016 Andrew Jones
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

include_recipe 'desktop::apt'

if node[:platform] == 'debian'
  apt_repository 'mozilla.debian.net' do
    uri 'http://mozilla.debian.net/'
    keyserver 'hkps.pool.sks-keyservers.net'
    key '85F06FBC75E067C3F305C3C985A3D26506C4AE2A'
    distribution "#{node[:lsb][:codename]}-backports"
    components ['firefox-release']
  end
end

package 'firefox' do
  action :upgrade
end
