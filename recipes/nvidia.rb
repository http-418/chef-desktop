#
# Cookbook Name:: desktop
# Recipe:: nvidia
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#
# This recipe installs and configures the proprietary nVidia drivers
# on Debian/Ubuntu.
#

package 'xserver-xorg-video-nouveau' do
  action :purge
end

file '/etc/modprobe.d/nouveau-blacklist.conf' do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    # This file is maintained by Chef.
    # Local changes will be overwritten.
    blacklist nouveau
  EOM
  notifies :run, 'execute[nvidia-depmod]', :immediately
end

execute 'nvidia-depmod' do
  command 'depmod -a'
  action :nothing
end

if node['platform'] == 'debian'
  package [
   'build-essential',
   'linux-headers-amd64',
   'libgl1-nvidia-glx-i386',
   'nvidia-kernel-dkms',
   'nvidia-settings',
   'nvidia-alternative',
   'nvidia-modprobe',
   'xserver-xorg-video-nvidia',
  ] do
    action :install
  end
elsif node['platform'] == 'ubuntu'
  include_recipe 'desktop::backports'
  package [
   'build-essential',
   'linux-headers-generic',
   'nvidia-current',
   'nvidia-modprobe',
  ] do
    action :install
  end
end

file '/etc/modules-load.d/nvidia.conf' do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    #
    # This file is maintained by Chef.
    # Local changes will be overwritten.
    #
    nvidia
    nvidia_uvm
  EOM
end

file '/etc/modprobe.d/nvidia.conf' do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    #
    # This file is maintained by Chef.
    # Local changes will be overwritten.
    #
    # This file is no longer needed with modern nVidia driver packages.
    # Chef overwrites it to ensure it is empty.
    #
  EOM
end

execute 'depmod -a'

file '/etc/X11/xorg.conf.d/20-nvidia.conf' do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    #
    # This file is maintained by Chef.
    # Local changes will be overwritten.
    #
    Section "Device"
      Identifier "Nvidia GPU"
      Driver "nvidia"
    EndSection
  EOM
end

# The nVidia driver has tearing under opengl.
file '/etc/mpv.conf' do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    #
    # This file is maintained by Chef.
    # Local changes will be reverted.
    #

    # Use XV to avoid tearing.
    vo=xv

    # Aggressive smoothing.
    vf=hqdn3d
  EOM
end

directory '/etc/mplayer' do
  mode 0555
end

link '/etc/mplayer/mplayer.conf' do
  to '/etc/mpv.conf'
end
