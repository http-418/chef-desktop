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

include_recipe 'desktop::apt'
include_recipe 'desktop::backports'

if node[:platform] == 'debian'
  if node[:lsb][:codename] == 'jessie'
    include_recipe 'desktop::jessie_nvidia_repo'
  end
  
  apt_package [
   'build-essential',
   'libgl1-nvidia-glx',
   'linux-headers-amd64',
   'nvidia-kernel-dkms',
   'nvidia-settings',
   'nvidia-alternative',
   'nvidia-modprobe',
   'xserver-xorg-video-nvidia',
  ] do
    action :upgrade
  end

  #
  # After installing the regular driver and 64 bit libs, a nasty
  # equivs hack is required to get the 32 bit counterparts working.
  #
  # The libc-i386:i386 package was removed from debian at some point,
  # but 32 bit package metadata still have hard depends on it.  Oops.
  #
  package ['equivs', 'libc6', 'libc6:i386'] do
    action :upgrade
  end
  
  build_directory =
    File.join(Chef::Config.file_cache_path, 'libc-i386')

  directory build_directory do
    action :create
    mode 0o755
  end
  
  control_file_path =
    File.join(build_directory, 'control_file')

  package_path =
    File.join(build_directory,'libc6-i386_99_i386.deb')

  file control_file_path do
    mode 0o444
    content <<-EOM.gsub(/^ +/,'')
      Section: misc
      Priority: optional
      Standards-Version: 3.9.20

      Package: libc6-i386
      Version: 3:99
      Maintainer: Andrew Jones <andrew@jones.ec>
      Architecture: i386
      Description: Dummy package to satisfy legacy dependency.
      Depends: libc6:i386 (>= 2.1.3)
    EOM
  end

  execute 'libc-i386-build' do
    require 'shellwords'
    cwd build_directory
    command "equivs-build -a i386 #{control_file_path.shellescape}"
    creates package_path
  end

  dpkg_package 'libc6-i386:i386' do
    source package_path
  end

  package 'libgl1-nvidia-glx:i386'
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
    # This file is maintained by Chef.
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
  mode 0o444
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
  mode 0o444
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
  mode 0o555
end

link '/etc/mplayer/mplayer.conf' do
  to '/etc/mpv.conf'
end
