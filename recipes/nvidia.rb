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
  notifies :run, 'execute[nvidia-depmod]'
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
   'xserver-xorg-video-nvidia',
  ] do
    action :install
  end
elsif node['platform'] == 'ubuntu'
  package [
   'build-essential',
   'linux-headers-generic',
   'nvidia-current'
  ] do
    action :install
  end
end

module_conf_path = '/etc/modprobe.d/nvidia.conf'
file module_conf_path do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    # This file is maintained by Chef.
    # Local changes will be overwritten.
    install nvidia /bin/true
  EOM
end

execute 'depmod -a'

directory '/etc/X11/xorg.conf.d/' do
  recursive true
  mode 0555
end

file '/etc/X11/xorg.conf.d/20-nvidia.conf' do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    # This file is maintained by Chef.
    # Local changes will be overwritten.
    Section "Device"
      Identifier "Nvidia GPU"
      Driver "nvidia"
    EndSection
  EOM
end
