#
# Cookbook Name:: desktop
# Recipe:: tar
#
# Copyright 2016, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'desktop::apt'
if node[:lsb][:id] == 'Debian' &&
    Gem::Version.new(node[:lsb][:release]) < Gem::Version.new('9.0')
  
  apt_repository 'stretch' do
    uri 'http://mirror.cc.columbia.edu/debian'
    distribution 'stretch'
    components ['main', 'contrib', 'non-free']
  end

  apt_preference 'stretch' do
    glob '*'
    pin 'release n=stretch'
    pin_priority '500'
  end
else
  apt_preference 'stretch' do
    action :remove
  end

  apt_repository 'stretch' do
    action :remove
  end

  log "Not adding debian 'stretch' repos to " \
    "#{node[:lsb][:id]} #{node[:lsb][:release]}"
end 
