#
# Cookbook Name:: desktop
# Recipe:: tar
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
# This recipe installs tar 1.29 from 'stretch' on Debian 'jessie'.
# This is necessary to run debian scripts from 'stretch' and 'sid'
# while building packages.
#
include_recipe 'desktop::apt'
include_recipe 'desktop::stretch'

if node[:lsb][:id] == 'Debian' &&
    Gem::Version.new(node[:lsb][:release]) < Gem::Version.new('9.0')
    
  apt_preference 'tar' do
    package_name 'tar'
    pin 'release n=stretch'
    pin_priority '990'
    notifies :run, 'execute[apt-get update]', :immediately
  end
  
  apt_package 'tar' do
    action :upgrade
  end
else
  apt_preference 'tar' do
    action :remove
  end

  log "#{node[:lsb][:id]} #{node[:lsb][:release]} " \
    "does not require a new 'tar' version"
end
