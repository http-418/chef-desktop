#
# Cookbook Name:: desktop
# Recipe:: backports
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'

if node['platform'] == 'ubuntu'
  apt_repository 'backports' do
    uri 'http://archive.ubuntu.com/ubuntu'
    distribution "#{node[:lsb][:codename]}-backports"
    components ['main', 'restricted', 'universe', 'multiverse']
    notifies :run, 'execute[apt-get update]', :immediately
  end
else
  apt_repository 'backports' do
    uri 'http://http.debian.net/debian'
    distribution "#{node[:lsb][:codename]}-backports"
    components ['main']
    notifies :run, 'execute[apt-get update]', :immediately
  end
end
