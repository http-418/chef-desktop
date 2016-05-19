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

include_recipe 'desktop::virtualbox'

vagrant_url =
  'https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb'

vagrant_path = 
  "#{Chef::Config[:file_cache_path]}/vagrant_1.8.1_x86_64.deb"

remote_file vagrant_path do
  source vagrant_url
  mode 0444
  checksum 'ed0e1ae0f35aecd47e0b3dfb486a230984a08ceda3b371486add4d42714a693d'
end

dpkg_package 'vagrant' do
  action :install
  source vagrant_path
end

# Vagrant ships its own SSL CAs.
# We force it to use system-wide SSL instead.

vagrant_ca_path = '/opt/vagrant/embedded/cacert.pem'

file vagrant_ca_path do
  action :delete
  not_if { File.symlink?(vagrant_ca_path) }
end

link vagrant_ca_path do
  to '/etc/ssl/certs/ca-certificates.crt'
end
