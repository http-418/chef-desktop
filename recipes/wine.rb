#
# Cookbook Name:: desktop
# Recipe:: wine
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'desktop::apt'

if node['platform'] != 'debian'
  apt_repository 'wine_ppa' do
    uri 'http://ppa.launchpad.net/ubuntu-wine/ppa/ubuntu'
    distribution node[:lsb][:codename]
    components ['main']
    key '5A9A06AEF9CB8DB0'
    keyserver 'keyserver.ubuntu.com'
  end

  package [ 'wine1.7', 'wine-gecko2.40' ]
else  
  # Modern wine is only available via backports.
  include_recipe 'desktop::backports'

  apt_preference 'wine-development' do
    pin 'release a=jessie-backports'
    pin_priority '600'
  end

  apt_package 'wine-development' do
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

  package 'winetricks'

  file '/etc/profile.d/wine.sh' do
    mode 0555
    content <<-EOM
      export WINE=/usr/bin/wine-development
      alias wine=$WINE
    EOM
  end
end
