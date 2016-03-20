#
# Cookbook Name:: desktop
# Recipe:: default
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'desktop::apt'

package ['xserver-xorg', 'pciutils']

directory '/etc/X11/xorg.conf.d/' do
  recursive true
  mode 0555
end

# Don't configure nvidia drivers on non-nvidia systems.
if system('lspci | grep VGA | grep -i nvidia') 
  include_recipe 'desktop::nvidia'
  package 'xserver-xorg'
else
  log 'This system does not contain an nVidia GPU'
  file '/etc/X11/xorg.conf.d/20-nvidia.conf' do
    action :delete
  end
  package 'xserver-xorg-video-all'
end

if (node[:virtualization][:system] == 'vbox' &&
    node[:virtualization][:role] == 'guest')
  include_recipe 'desktop::virtualbox-guest'
end
