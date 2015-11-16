#
# Cookbook Name:: desktop
# Recipe:: wine
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

if node['platform'] != 'debian'
  Chef::Log.warn('desktop::wine is a no-op on Ubuntu, because no ' +
                 'modern wine version is available from upstream!')
else
  # The apt recipe configures multiarch.
  include_recipe 'desktop::apt'
  
  # Modern wine is only available via backports.
  include_recipe 'desktop::backports'

  package 'wine-development' do
    options "-t #{node[:lsb][:codename]}-backports"
    action [:install, :upgrade]
  end

  #
  # This is the "special" gecko installer wine searches for.
  #
  # The filename and checksum are hardcoded into wine.  Each wine
  # version may require a different gecko MSI.  Gecko 2.40 is used by
  # wine 1.7.50.
  #
  # http://wiki.winehq.org/Gecko
  #
  remote_file '/usr/share/wine/gecko/wine_gecko-2.40-x86.msi' do
    source 'http://downloads.sourceforge.net/project/wine/Wine%20Gecko/2.40/wine_gecko-2.40-x86.msi'
    checksum '1a29d17435a52b7663cea6f30a0771f74097962b07031947719bb7b46057d302'
    mode 0644
  end

  #
  # Un-install i386 development libraries from the old source build.
  #
  # These don't work correctly on a 64 bit system, because debian's
  # multiarch design didn't plan for cross-architecture development.
  #
  package [
                   'libfreetype6-dev:i386',
                   'libglu1-mesa-dev:i386',
                   'libxcomposite-dev:i386',
                   'libxrandr-dev:i386',
                   'libxi-dev:i386',
                   'libxcursor-dev:i386',
                   'libglu1-mesa-dev:i386',
                   'libxcomposite-dev:i386',
                   'libdbus-1-dev:i386',
                   'libtiff5-dev:i386',
                   'libncurses5-dev:i386',
                   'libosmesa6-dev:i386',
                   'libcups2-dev:i386',
                   'libfontconfig1-dev:i386',
                   'xserver-xorg-dev:i386',
          ] do
    action :remove
  end
end
