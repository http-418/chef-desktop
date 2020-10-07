#
# Cookbook Name:: desktop
# Recipe:: nvidia
#
# Copyright 2015 Andrew Jones
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# This recipe installs and configures the proprietary nVidia drivers
# on Debian/Ubuntu.
#
package 'xserver-xorg-video-nouveau' do
  action :purge
end

file '/etc/modprobe.d/nouveau-blacklist.conf' do
  mode 0o444
  content <<-EOM.gsub(/^ {4}/,'')
    # This file is maintained by #{Chef::Dist::PRODUCT}.
    # Local changes will be overwritten.
    blacklist nouveau
  EOM
  notifies :run, 'execute[nvidia-depmod]', :immediately
end

execute 'nvidia-depmod' do
  command 'depmod -a'
  action :nothing
end

include_recipe 'desktop::apt'
include_recipe 'desktop::backports'

if node[:platform] == 'debian'

  package ['nvidia-driver',
           'nvidia-driver-bin',
           'nvidia-driver-libs-i386'] do
    action :upgrade
  end
x
elsif node[:platform] == 'ubuntu'
  apt_package [
   'build-essential',
   'linux-headers-generic',
   'nvidia-352',
   'nvidia-modprobe',
  ] do
    action :upgrade
  end
end

file '/etc/modules-load.d/nvidia.conf' do
  mode 0o444
  content <<-EOM.gsub(/^ {4}/,'')
    #
    # This file is maintained by #{Chef::Dist::PRODUCT}.
    # Local changes will be overwritten.
    #
    nvidia_current
    nvidia_current_modeset
    nvidia_current_uvm
  EOM
end

file '/etc/modprobe.d/nvidia.conf' do
  mode 0o444
  content <<-EOM.gsub(/^ {4}/,'')
    #
    # This file is maintained by #{Chef::Dist::PRODUCT}.
    # Local changes will be overwritten.
    #
    # This file is no longer needed with modern nVidia driver packages.
    # #{Chef::Dist::PRODUCT} overwrites it to ensure it is empty.
    #
  EOM
end

execute 'depmod -a'

file '/etc/X11/xorg.conf.d/20-nvidia.conf' do
  mode 0o444
  content <<-EOM.gsub(/^ {4}/,'')
    #
    # This file is maintained by #{Chef::Dist::PRODUCT}.
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
  mode 0o444
  content <<-EOM.gsub(/^ {4}/,'')
    #
    # This file is maintained by #{Chef::Dist::PRODUCT}.
    # Local changes will be reverted.
    #

    # Use XV to avoid tearing.
    vo=xv

    # Aggressive smoothing.
    vf=hqdn3d
  EOM
end

directory '/etc/mplayer' do
  mode 0o555
end

link '/etc/mplayer/mplayer.conf' do
  to '/etc/mpv.conf'
end
