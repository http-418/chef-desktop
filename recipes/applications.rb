#
# Cookbook Name:: desktop
# Recipe:: applications
#
# This is the catch-all recipe for configuring desktop applications.
# Complex installs get their own recipes (e.g. kde, wine, steam)
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
 'imagemagick',
 'irssi',
 'screen',
 'silversearcher-ag',
 'smbclient',
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

include_recipe 'desktop::spotify'

# # Steam is disabled, for now.
# # It has a click-through EULA that requires interactive use of dh_input.
# include_recipe 'desktop::steam'

# desktop applications
[
  'blueman',
  'emacs24',
  node['platform'] == 'debian' ? 'icedove' : nil,
  'gip',
  'google-chrome-unstable',
  'google-chrome-beta', # yes this is out of order
  'keepassx',
  'mpv', # mplayer fork
  'mrxvt',
  'mwm',
  'mumble',
  'pavucontrol',
  'pidgin',
  'pidgin-otr',
  'pulseaudio',
  'xclip',
  'xserver-xephyr',
  'xterm',
].compact.each do |package_name|
  package package_name
end

link '/usr/bin/t' do
  to '/usr/bin/mrxvt'
end

include_recipe 'desktop::kde'
