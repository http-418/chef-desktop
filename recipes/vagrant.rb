#
# Cookbook Name:: desktop
# Recipe:: vagrant
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#
# Installs vagrant + vbox on Debian/Ubuntu.
#

package [ 'build-essential', 'dkms', 'virtualbox-4.3' ] do
  action :install
end

vagrant_url = 
  "https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.deb"

vagrant_path = 
  "#{Chef::Config[:file_cache_path]}/vagrant_1.7.4_x86_64.deb"

remote_file vagrant_path do
  source vagrant_url
  mode 0444
  checksum 'dcd2c2b5d7ae2183d82b8b363979901474ba8d2006410576ada89d7fa7668336'
end

dpkg_package 'vagrant' do
  action :install
  source vagrant_path
end
