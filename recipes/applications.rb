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
  node['platform']  == 'debian' ? 'firmware-linux-nonfree' : nil,
  'krb5-user',
  'mdadm',
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
 'silversearcher-ag',
] do
  action :install
end

# other CLI applications
package [
 'autossh',
 'avahi-utils',
 'bvi',
 'gddrescue',
 'icoutils', # wrestool
 'imagemagick',
 'irssi',
 'ldap-utils',
 'mediainfo',
 'ntpdate',
 'screen',
 'smartmontools',
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

# Accept the EULA for Microsoft's web fonts.
# Georgia and MS Comic Sans are the really key ones here.
execute 'accept-mscorefonts-eula' do
  command 'echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections'
  not_if 'debconf-get-selections | grep msttcorefonts/accepted-mscorefonts-eula | grep true'
end

# desktop fonts
package [
 'fonts-inconsolata',
 'fonts-liberation',
 'ttf-mscorefonts-installer',
 'xfonts-75dpi',
 'xfonts-100dpi',
 'xfonts-base',
 'xfonts-scalable',
] do
  action :install
  notifies :run, 'execute[fc-cache -fv]'
end

execute 'fc-cache -fv' do
  action :nothing
end

# desktop applications
package [
  'clusterssh',
  'cups',
  'emacs24',
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
  'wireshark',
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
include_recipe 'desktop::kde'
include_recipe 'desktop::google-chrome'
include_recipe 'desktop::vagrant'
include_recipe 'desktop::virtualbox'
include_recipe 'desktop::youtube-dl'


