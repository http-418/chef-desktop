#
# Cookbook Name:: desktop
# Recipe:: steam_controller_udev_rules
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#
# This recipe configures udev rules to set permissions on /dev/uinput
# for Steam virtual gamepad support.
#

file '/etc/udev/rules.d/99-steam-controller-uinput.rules' do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    KERNEL=="uinput", GROUP="#{node[:desktop][:user][:group]}", MODE:="0660"
  EOM
  notifies :run, 'execute[udev-reload-uinput-driver]', :immediately
end

execute 'udev-reload-uinput-driver' do
  action :nothing
  command 'udevadm control --reload; modprobe -r uinput; modprobe uinput'
end
