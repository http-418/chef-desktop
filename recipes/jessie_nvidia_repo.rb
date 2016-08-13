#
# Cookbook Name:: desktop
# Recipe:: jessie_nvidia_repo
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

#
# This recipe configures my personal repository of backported nvidia
# drivers for Debian 'jessie'
#
include_recipe 'desktop::apt'

if node[:platform] == 'debian' && node[:lsb][:codename] == 'jessie'
  apt_repository 'jessie-nvidia-367' do
    uri 'http://www.jones.ec/jessie-nvidia-367/'
    distribution 'jessie'
    components ['non-free']
    key 'jessie-nvidia-367.key'
  end
else
  apt_repository 'jessie-nvidia-367' do
    action :remove
  end
  
  log "Not configuring the 'jessie' repository for nVidia 367.x drivers " \
    "drivers on #{node[:lsb][:id]} #{node[:lsb][:release]}"
end
