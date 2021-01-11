#
# Cookbook Name:: desktop
# Recipe:: docker
#
# Copyright 2021 Andrew Jones
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

include_recipe 'desktop::backports'

package 'apt-transport-https' do
  action :upgrade
end

apt_repository 'docker' do
  uri "https://download.docker.com/linux/#{node[:lsb][:id].downcase}"
  distribution node[:lsb][:codename].downcase
  components ['stable']
  key 'docker.key'
end

apt_package 'docker.io' do
  action :purge
end

file '/etc/default/docker.io' do
  action :delete
end

ruby_block 'purge-aufs-warning' do
  block do
    if ::File.directory?('/var/lib/docker/aufs')
      raise "Please rm -rf /var/lib/docker/aufs before upgrade.\n" \
            'WARNING: This will delete all of your existing docker containers!'
    end
  end
end

docker_service = 'docker'

apt_package 'docker-engine' do
  action :remove
  notifies :stop, "service[#{docker_service}]", :before
end

apt_package 'docker-ce' do
  action :upgrade
  notifies :restart, "service[#{docker_service}]"
end

template '/etc/default/docker' do
  mode 0444
  source 'docker/docker-defaults.erb'
  notifies :restart, "service[#{docker_service}]"
end

template '/etc/docker/daemon.json' do
  mode 0444
  source 'docker/daemon.json.erb'
  notifies :restart, "service[#{docker_service}]"
end

service docker_service do
  action [:enable, :start]
end
