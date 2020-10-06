#
# Cookbook Name:: desktop
# Recipe:: wine
#
# Copyright 2020 Andrew Jones
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
  # Remove the old PPA-based repo, as it is no longer used.
  apt_repository 'wine_ppa' do
    uri 'http://ppa.launchpad.net/ubuntu-wine/ppa/ubuntu'
    action :remove
  end
when 'debian'
  # Remove the old wine-development builds from jessie-backports.
  package 'wine-development' do
    action :remove
    only_if 'dpkg --get-selections | grep ^wine-development | ' \
      'grep -v deinstall'
  end
else
  raise 'Unsupported outside Debian/Ubuntu'
end

apt_repository 'wine_staging' do
  uri 'https://dl.winehq.org/wine-builds/debian/'
  distribution node[:lsb][:codename]
  components ['main']
  # Note: the signing key is stored here as a cookbook_file.
  key 'default/wine-staging.key'
end

#
# This is no longer needed, as the package names no longer overlap.
#
# (Why does WineHQ packaging change annually? Because it can.)
#
apt_preference 'wine_staging' do
  action :remove
end

['wine-staging-amd64', 'wine-staging-i386'].each do |pkg_name|
  package pkg_name do
    if (node[:platform] == 'ubuntu' &&
        Gem::Version.new(node[:lsb][:release]) < Gem::Version.new('20.04')) ||
        (node[:platform] == 'debian' &&
         Gem::Version.new(node[:lsb][:release]) < Gem::Version.new('11'))
      # We're stuck on 4.5 forever, because wine integrates a new audio
      # system that's not supported before 20.04 or Debian 11
      action :install
      version "4.5~#{node[:lsb][:codename].downcase}"
    else
      action :upgrade
    end
  end
end



# This is required for ntlmauth.
package ['winbind', 'p11-kit-modules'] do
  action :upgrade
end

#
# This is the "special" gecko installer wine searches for.
#
# The filename and checksum are hardcoded into wine.  Each wine
# version may require a different gecko MSI.  Gecko 2.47 is used by wine 4.x,
# and 2.47.1 is used by wine 5.0-RC
#
# http://wiki.winehq.org/Gecko
#

gecko_dir = '/usr/share/wine/gecko/'

directory gecko_dir do
  recursive true
  mode 0644
end

[
 ['https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi',
  '3b8a361f5d63952d21caafd74e849a774994822fb96c5922b01d554f1677643a'],
 ['https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86_64.msi',
  'c565ea25e50ea953937d4ab01299e4306da4a556946327d253ea9b28357e4a7d'],
 ['https://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86.msi',
  'f00b0e2892404827e8ce6811dedfc25ae699a09955bb3df1bbb31753e51da051'],
 ['https://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86_64.msi',
  '69312e79a988da3e7d292382005e92bc4d4b2a52a23c34440ae3007feb57474a']
].each do |url, checksum|
  file_name = "#{gecko_dir}#{::File.basename(url)}"
  remote_file file_name do
    source url
    checksum checksum
    mode 0644
  end
end

file '/etc/profile.d/wine.sh' do
  mode 0555
  content <<-EOM
      export WINE=/opt/wine-staging/bin/wine
      alias wine=$WINE
    EOM
end
