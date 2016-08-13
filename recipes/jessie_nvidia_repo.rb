#
# Cookbook Name:: desktop
# Recipe:: jessie_nvidia_repo
#
# Copyright 2016, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

#
# This recipe configures my personal repository of backported nvidia
# drivers for Debian 'jessie'
#
include_recipe 'desktop::apt'

if node[:platform] == 'debian' && node[:lsb][:codename] == 'jessie'
  apt_repository 'jessie-nvidia-367' do
    uri 'http://www.jones.ec/jessie-nvidia-367/'
    distribution 'jessie'
    components ['non-free']
    key 'jessie-nvidia-367.key'
  end
else
  apt_repository 'jessie-nvidia-367' do
    action :remove
  end
  
  log "Not configuring the 'jessie' repository for nVidia 367.x drivers " \
    "drivers on #{node[:lsb][:id]} #{node[:lsb][:release]}"
end
