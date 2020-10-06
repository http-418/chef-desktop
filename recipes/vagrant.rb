#
# Cookbook Name:: desktop
# Recipe:: vagrant
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

# TODO: use Debian upstream vagrant instead of the commercial version

#
# Installs vagrant + vbox on Debian/Ubuntu.
#
include_recipe 'desktop::virtualbox'

vagrant_url =
  'https://releases.hashicorp.com/vagrant/2.1.2/vagrant_2.1.2_x86_64.deb'

vagrant_path =
  "#{Chef::Config[:file_cache_path]}/vagrant_2.1.2_x86_64.deb"

remote_file vagrant_path do
  source vagrant_url
  mode 0444
  checksum 'f614a60b258a856322f23d33a24201d26ab2555d047814fec403e834eb7d62b4'
end

dpkg_package 'vagrant' do
  action :install
  source vagrant_path
end

#
# Vagrant ships its own SSL CAs.
# We force it to use system-wide SSL instead.
#
vagrant_ca_path = '/opt/vagrant/embedded/cacert.pem'

file vagrant_ca_path do
  action :delete
  not_if { File.symlink?(vagrant_ca_path) }
end

link vagrant_ca_path do
  to '/etc/ssl/certs/ca-certificates.crt'
end
