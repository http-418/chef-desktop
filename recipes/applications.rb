#
# Cookbook Name:: desktop
# Recipe:: applications
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
# This is the catch-all recipe for configuring desktop applications.
# Complex installs get their own recipes (e.g. kde, wine)
#
include_recipe 'desktop::apt'

# system utilities
package [
  'debconf-utils', # debconf-get-selections
  'dnsutils',
  'dos2unix',
  'ethtool',
  node['platform']  == 'debian' ? 'firmware-linux-nonfree' : nil,
  'hfsprogs',
  'hfsplus',
  'ipmitool',
  'krb5-user',
  'mdadm',
  'nmon',
  'ntpdate',
  'pv',
  'smartmontools',
  'sudo',
  'unzip',
  'zip',
  'p7zip-full'
].compact do
  action :upgrade
  timeout 3600
end

# development
package [
 'autoconf',
 'automake',
 'bison',
 'build-essential',
 'cloc',
 'devscripts',
 'doxygen',
 'fakeroot',
 'flex',
 'git',
 'libpq-dev',
 'libtool',
 'libpq-dev',
 'python3',
 'silversearcher-ag',
 'subversion',
 'svn-buildpackage',
 'valgrind',
 'xmldiff'
] do
  action :upgrade
  timeout 3600
end

# other CLI applications
package [
 'autossh',
 'avahi-utils',
 'bchunk',
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
 'rsync',
 'screen',
 'smbclient',
 'sqlite',
 'sshpass',
 'strace',
 'sysstat',
 'tcpdump',
 'time', # gnu time is better than shell builtins.
 'toilet',
 'whois',
 'winetricks',
] do
  action :upgrade
  timeout 3600
end

# Complex applications that may depend upon dev packages
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

# misc desktop applications
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
  action :upgrade
  timeout 3600
end

link '/usr/bin/t' do
  to '/usr/bin/mrxvt'
end

link '/usr/bin/mplayer' do
  to '/usr/bin/mpv'
end

package [ 'nano' ] do
  action :remove
end

# Update GDK pixbuf backends after package installation.
execute 'gdk-pixbuf-update' do
  command '/usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0/gdk-pixbuf-query-loaders --update-cache'
  user 'root'
end

# Tar 1.29 for Debian 'jessie'
include_recipe 'desktop::tar'
