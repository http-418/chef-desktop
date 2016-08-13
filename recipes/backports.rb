#
# Cookbook Name:: desktop
# Recipe:: backports
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'desktop::apt'

if node['platform'] == 'ubuntu'
  apt_repository 'backports' do
    uri 'http://archive.ubuntu.com/ubuntu'
    distribution "#{node[:lsb][:codename]}-backports"
    components ['main', 'restricted', 'universe', 'multiverse']
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

