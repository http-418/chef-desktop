#
# Cookbook Name:: desktop
# Recipe:: default
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

# apt
include_recipe 'apt'

# Hardware.
include_recipe 'desktop::bluetooth'
include_recipe 'desktop::irqbalance'
include_recipe 'desktop::pc-speaker'
include_recipe 'desktop::pulseaudio'
include_recipe 'desktop::synaptics'

package 'pciutils'

# Don't configure nvidia drivers on non-nvidia systems.
if system('lspci | grep VGA | grep -i nvidia') 
  include_recipe 'desktop::nvidia'
else
  log 'This system does not contain an nVidia GPU'
  file '/etc/X11/xorg.conf.d/20-nvidia.conf' do
    action :delete
  end
  package 'xserver-xorg'
  package 'xserver-xorg-video-all'
end

# Software.
include_recipe 'desktop::applications'
include_recipe 'desktop::ssh'

# Primary user configuration -- see attributes/user.rb!
include_recipe 'desktop::user'

