#
# Cookbook Name:: desktop
# Recipe:: backports
#
# Copyright 2015-2016 Andrew Jones
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

if node['platform'] == 'ubuntu'
  apt_repository 'backports' do
    uri node[:ubuntu][:archive_url]
    distribution "#{node[:lsb][:codename]}-backports"
    components ['main', 'restricted', 'universe', 'multiverse']
  end

  #
  # Pin a modern version of git, because trusty inexplicably shipped
  # with an ancient one
  #
  if Gem::Version.new(node[:lsb][:release]) < Gem::Version.new('16.04')
    apt_preference 'ubuntu-xenial' do
      glob '*'
      pin 'release n=xenial'
      pin_priority '100'
    end

    apt_preference 'ubuntu-xenial-git' do
      glob 'git'
      pin 'release n=xenial'
      pin_priority '710'
    end

    apt_repository 'xenial' do
      uri node[:ubuntu][:archive_url]
      distribution 'xenial'
      components ['main']
    end
  else
    # Delete the preferences, if present, on 16.04 and above.
    apt_preference 'ubuntu-xenial' do
      action :delete
    end

    apt_preference 'ubuntu-xenial-git' do
      action :delete
    end
  end
else
  apt_repository 'backports' do
    uri 'http://http.debian.net/debian'
    distribution "#{node[:lsb][:codename]}-backports"
    components ['main', 'contrib', 'non-free']
  end
end

apt_preference "#{node[:lsb][:codename]}-backports" do
    glob '*'
    pin "release n=#{node[:lsb][:codename]}-backports"
    # Same priority as the default distribution set in desktop::apt
    pin_priority '700'
    notifies :run, 'execute[apt-get update]', :immediately
end

# Debian's jessie-backports repo ships new core components.
if node[:lsb][:id] == 'Debian'
  package ['systemd', 'ifupdown'] do
    action :upgrade
  end
end
