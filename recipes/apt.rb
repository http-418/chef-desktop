#
# Cookbook Name:: desktop
# Recipe:: apt
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

if node[:platform] == 'debian'
  node.default['debian']['mirror'] = 'http://mirror.rit.edu/debian'
  node.set['debian']['deb_src'] = true
  platform_recipe = 'debian'
elsif node[:platform] == 'ubuntu'
  node.set['ubuntu']['deb_src'] = true
  platform_recipe = 'ubuntu'
else
  raise "Unsupported platform: #{node[:platform]}"
end

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

execute 'configure-multiarch' do
  command 'dpkg --add-architecture i386'
  not_if 'dpkg --print-foreign-architectures | grep i386'
  notifies :run, 'execute[apt-get update]', :immediately
end

apt_preference 'default-distribution' do
  glob '*'
  pin "release n=#{node[:lsb][:codename]}"
  pin_priority '700'
end

include_recipe platform_recipe
