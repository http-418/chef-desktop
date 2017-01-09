#
# Cookbook Name:: desktop
# Recipe:: stretch
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
# This recipe adds the 'stretch' repo and appropriate apt preferences
# to allow installation of certain 'stretch' packages on 'jessie'
#
include_recipe 'desktop::apt'
if node[:lsb][:id] == 'Debian' &&
    Gem::Version.new(node[:lsb][:release]) < Gem::Version.new('9.0')
  
  apt_repository 'stretch' do
    uri node[:debian][:mirror]
    distribution 'stretch'
    components ['main', 'contrib', 'non-free']
  end

  apt_preference 'stretch' do
    glob '*'
    pin 'release n=stretch'
    pin_priority '500'
  end
else
  apt_preference 'stretch' do
    action :remove
  end

  apt_repository 'stretch' do
    action :remove
  end

  log "Not adding debian 'stretch' repos to " \
    "#{node[:lsb][:id]} #{node[:lsb][:release]}"
end
