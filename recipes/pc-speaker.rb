#
# Cookbook Name:: desktop
# Recipe:: pc-speaker
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#
# This recipe disables the internal PC speaker hardware.
# 

execute 'modprobe -r pcspkr' do
  only_if 'lsmod | grep pcspkr'
end

file '/etc/modprobe.d/pcspkr-blacklist.conf' do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    # This file is maintained by Chef.
    # Local changes will be overwritten.
    blacklist pcspkr
  EOM
  notifies :run, 'execute[pcspkr-depmod]'
end

execute 'pcspkr-depmod' do
  command 'depmod -a'
  action :nothing
end
