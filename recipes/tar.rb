#
# Cookbook Name:: desktop
# Recipe:: tar
#
# Copyright 2016, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

#
# This recipe installs tar 1.29 from 'stretch' on Debian 'jessie'.
# This is necessary to run debian scripts from 'stretch' and 'sid'
# while building packages.
#
include_recipe 'desktop::apt'
include_recipe 'desktop::stretch'

if node[:lsb][:id] == 'Debian' &&
    Gem::Version.new(node[:lsb][:release]) < Gem::Version.new('9.0')
    
  apt_preference 'tar' do
    package_name 'tar'
    pin 'release n=stretch'
    pin_priority '990'
    notifies :run, 'execute[apt-get update]', :immediately
  end
  
  apt_package 'tar' do
    action :upgrade
  end
else
  apt_preference 'tar' do
    action :remove
  end

  log "#{node[:lsb][:id]} #{node[:lsb][:release]} " \
    "does not require a new 'tar' version"
end
