#
# Cookbook Name:: desktop
# Recipe:: wine
#
# Copyright 2015,2016 Andrew Jones
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
  # version may require a different gecko MSI.  Gecko 2.47 is used by
  # wine 1.9.17
  #
  # http://wiki.winehq.org/Gecko
  #
  [
    ['https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi',
      '3b8a361f5d63952d21caafd74e849a774994822fb96c5922b01d554f1677643a'],
    ['https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86_64.msi',
      'c565ea25e50ea953937d4ab01299e4306da4a556946327d253ea9b28357e4a7d']
  ].each do |url, checksum|
    file_name = "/usr/share/wine/gecko/#{::File.basename(url)}"
    remote_file file_name do
      source url
      checksum checksum
      mode 0644
    end
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

# # Upgrading gst plugins explodes because openCV doesn't support
# # multiarch -- installing amd64 breaks i386 and vice versa.  so a
# # side by side installation of plugins-bad is impossible :(
#
# # Install all gstreamer plugins for i386 and amd64.
# # Apt doesn't know about these hidden deps, since they're dlopen()ed.
# #
# gst_packages = %w(base good bad ugly).map do |plugin_class|
#   ["gstreamer1.0-plugins-#{plugin_class}:amd64",
#    "gstreamer1.0-plugins-#{plugin_class}:i386"]
# end.flatten

# package gst_packages do
#   action :upgrade
# end
