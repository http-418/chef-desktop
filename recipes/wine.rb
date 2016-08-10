#
# Cookbook Name:: desktop
# Recipe:: wine
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

# Including desktop::apt on purpose, to configure multiarch.
include_recipe 'desktop::apt'

# TODO: install winetricks on Ubuntu
case node[:platform]
when 'ubuntu'
  apt_repository 'wine_ppa' do
    uri 'http://ppa.launchpad.net/ubuntu-wine/ppa/ubuntu'
    distribution node[:lsb][:codename]
    components ['main']
    key '5A9A06AEF9CB8DB0'
    keyserver 'keyserver.ubuntu.com'
  end

  package [ 'wine1.7', 'wine-gecko2.40' ]

  file '/etc/profile.d/wine.sh' do
    mode 0555
    content <<-EOM
      export WINE=/usr/bin/wine
    EOM
  end
when 'debian'
  # Remove the old wine-development builds from jessie-backports.
  package 'wine-development' do
    action :remove
    only_if 'dpkg --get-selections | grep ^wine-development | ' \
      'grep -v deinstall'
  end

  apt_repository 'wine_staging' do
    uri 'https://repos.wine-staging.com/debian/'
    distribution node[:lsb][:codename]
    components ['main']
    key 'https://repos.wine-staging.com/Release.key'
  end

  apt_preference 'wine_staging' do
    glob '*'
    pin 'origin repos.wine-staging.com'
    pin_priority '400'
  end

  package ['wine-staging', 'winehq-staging'] do
    action :upgrade
  end

  # This is required for ntlmauth.
  package ['winbind', 'p11-kit-modules'] do
    action :upgrade
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

  package 'winetricks'

  file '/etc/profile.d/wine.sh' do
    mode 0555
    content <<-EOM
      export WINE=/opt/wine-staging/bin/wine
      alias wine=$WINE
    EOM
  end
end
