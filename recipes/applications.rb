# system utilities
[
  'bluetooth',
  'bluez',
  'bluez-tools',
  'bluez-firmware',
  'debconf-utils', # debconf-get-selections
  'dos2unix',
  'firmware-linux-nonfree',
  'mdadm',
  'sudo',
  'unzip',
].each do |package_name|
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
include_recipe 'desktop::steam'

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
  'xterm',
].compact.each do |package_name|
  package package_name
end

link '/usr/bin/t' do
  to '/usr/bin/mrxvt'
end

# kde
[
  'kde-plasma-desktop',
  'yakuake'
].each do |package_name|
  package package_name
end

service 'kdm' do
  action :start
end
