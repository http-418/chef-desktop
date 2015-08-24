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
[
  'debconf-utils', # debconf-get-selections
  'dos2unix',
  node['platform']  == 'debian' ? 'firmware-linux-nonfree' : nil,
  'mdadm',
  'sudo',
  'unzip',
  'zip',
  'p7zip-full'
].compact.each do |package_name|
  package package_name
end

# development
[
 'autoconf',
 'automake',
 'bison',
 'flex',
 'git',
 'libtool',
].each do |package_name|
  package package_name
end

# other CLI applications
[
 'autossh',
 'imagemagick',
 'irssi',
 'screen',
 'silversearcher-ag',
 'smbclient',
 'strace',
 'sysstat',
 'winetricks',
].each do |package_name|
  package package_name
end

# Accept the EULA for Microsoft's web fonts.
# Georgia and MS Comic Sans are the really key ones here.
execute 'accept-mscorefonts-eula' do
  command 'echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections'
  not_if 'debconf-get-selections | grep msttcorefonts/accepted-mscorefonts-eula | grep true'
end

# desktop fonts
[
 'fonts-inconsolata',
 'fonts-liberation',
 'ttf-mscorefonts-installer',
 'xfonts-75dpi',
 'xfonts-100dpi',
 'xfonts-base',
 'xfonts-scalable',
].each do |package_name|
  package package_name do
    notifies :run, 'execute[fc-cache -fv]'
  end
end

execute 'fc-cache -fv' do
  action :nothing
end

# desktop applications
[
  'emacs24',
  node['platform'] == 'debian' ? 'icedove' : nil,
  'gip',
  'keepassx',
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
  'xnest',
  'xserver-xephyr',
  'xterm',
].compact.each do |package_name|
  package package_name
end

link '/usr/bin/t' do
  to '/usr/bin/mrxvt'
end

include_recipe 'desktop::kde'
include_recipe 'desktop::google-chrome'
include_recipe 'desktop::vagrant'

