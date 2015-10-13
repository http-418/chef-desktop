#
# Cookbook Name:: desktop
# Recipe:: virtualbox
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'

apt_repository 'virtualbox' do
  uri 'http://download.virtualbox.org/virtualbox/debian'
  components ['contrib']
  distribution node[:lsb][:codename]
  key 'http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc'
  action :add
  notifies :run, 'execute[apt-get update]', :immediately
end

package 'virtualbox-4.3' do
  action :remove
end
   
package [ 
         'build-essential',
         'dkms',
         'virtualbox-5.0' 
        ] do
    action :install
end

