#
# Cookbook Name:: desktop
# Recipe:: backports
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

if node['platform'] == 'debian'
  include_recipe 'apt'

  apt_repository 'backports' do
    uri 'http://http.debian.net/debian'
    distribution "#{node[:lsb][:codename]}-backports"
    components ['main']
    notifies :run, 'execute[apt-get update]', :immediately
  end
end
