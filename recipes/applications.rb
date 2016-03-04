#
# Cookbook Name:: desktop
# Recipe:: applications
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#
# This is the catch-all recipe for configuring desktop applications.
# Complex installs get their own recipes (e.g. kde, wine)
#

# system utilities
package [
  'debconf-utils', # debconf-get-selections
  'dnsutils',
  'dos2unix',
  'ethtool',
  node['platform']  == 'debian' ? 'firmware-linux-nonfree' : nil,
  'krb5-user',
  'mdadm',
  'nmon',
  'ntpdate',
  'smartmontools',
  'sudo',
  'unzip',
  'zip',
  'p7zip-full'
].compact do
  action :install
end

# development
package [
 'autoconf',
 'automake',
 'bison',
 'build-essential',
 'cloc',
 'flex',
 'git',
 'libpq-dev',
 'libtool',
 'libpq-dev',
 'python3',
 'silversearcher-ag',
] do
  action :install
end

# other CLI applications
package [
 'autossh',
 'avahi-utils',
 'bvi',
 'cadaver', # cli webdav client
 'davfs2',
 'gddrescue',
 'icoutils', # wrestool
 'imagemagick',
 'irssi',
 'ldap-utils',
 'mediainfo',
 'ncftp',
 'ntpdate',
 'picocom',
 'pwgen',
 'screen',
 'smbclient',
 'sqlite',
 'strace',
 'sysstat',
 'tcpdump',
 'time', # gnu time is better than shell builtins.
 'toilet',
 'whois',
 'winetricks',
] do
 action :install
end

# desktop applications
package [
  'clusterssh',
  'cups',
  node['platform'] == 'debian' ? 'icedove' : nil,
  'gimp',
  'gip',
  'gstreamer1.0-plugins-bad',
  'gstreamer1.0-plugins-ugly',
  'handbrake',
  'keepassx',
  'libreoffice',
  'libreoffice-kde',
  'libreoffice-pdfimport',
  'mesa-utils', # glxgears
  'mpv', # mplayer fork
  'mrxvt',
  'mwm',
  'mumble',
  'okular',
  'pavucontrol',
  'pidgin',
  'pidgin-otr',
  'pulseaudio',
  'xclip',
  'xinput',
  'xnest',
  'xserver-xephyr',
  'xterm',
].compact do
  action :install
end

link '/usr/bin/t' do
  to '/usr/bin/mrxvt'
end

include_recipe 'desktop::docker'
include_recipe 'desktop::emacs'
include_recipe 'desktop::fonts'
include_recipe 'desktop::hub'
include_recipe 'desktop::kde'
include_recipe 'desktop::google-chrome'
include_recipe 'desktop::vagrant'
include_recipe 'desktop::virtualbox'
include_recipe 'desktop::youtube-dl'
include_recipe 'desktop::wireshark'

# Update GDK pixbuf backends after package installation.
execute 'gdk-pixbuf-query-loaders --update-cache' do
  user 'root'
end

