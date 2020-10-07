#
# Cookbook Name:: desktop
# Recipe:: apt
#
# Copyright 2020 Andrew Jones
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
# Force apt to keep your old configuration files when possible,
# instead of prompting for you to make a decision.
#
file '/etc/apt/apt.conf.d/02dpkg-options' do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    Dpkg::Options {
      "--force-confdef";
      "--force-confold";
    }
  EOM
end

apt_preference 'default-distribution' do
  glob '*'
  pin "release n=#{node[:lsb][:codename]}"
  pin_priority '700'
end

if node[:platform] == 'ubuntu'
  package 'appstream' do
    action :remove
  end

  file '/etc/apt/apt.conf.d/50appstream' do
    content "# Appstream was disabled by #{ChefUtils::Dist::Infra::PRODUCT}."
    mode 0444
    user 'root'
    group 'root'
  end
end

# The distribution cookbooks are deprecated, so mirrors have to be configured.
template '/etc/apt/sources.list' do
  mode 0444
  source 'apt/sources.list.erb'
  owner 'root'
  group 'root'
  notifies :run, 'execute[apt-get update]', :immediately
end

execute 'configure-multiarch' do
  command 'dpkg --add-architecture i386'
  not_if 'dpkg --print-foreign-architectures | grep i386'
  notifies :run, 'execute[apt-get update]', :immediately
end

package [
  'apt-transport-https',
  'gnupg',
  'dirmngr',
] do
  action :upgrade
end

# This is a dummy for compatibility with newer apt cookbooks.
execute 'apt-get update' do
  action :nothing
end

include_recipe 'apt'
