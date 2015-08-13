#
# Cookbook Name:: desktop
# Recipe:: synaptics
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

package 'xserver-xorg-input-synaptics'

template '/usr/local/bin/synaptics.pl' do
  mode 0555
  source 'synaptics/synaptics.pl.erb'
end

template '/etc/X11/xorg.conf.d/20-synaptics.conf' do
  mode 0444
  source 'synaptics/synaptics.conf.erb'
end
