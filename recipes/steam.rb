#
# Cookbook Name:: desktop
# Recipe:: steam
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#
# This recipe installs Steam and its fonts.  It used to fail due to an
# EULA, but that should not happen anymore.
#
include_recipe 'apt'
include_recipe 'desktop::user'

apt_repository 'steam' do
  uri 'http://repo.steampowered.com/steam/'
  components ['precise', 'steam']
  keyserver 'keyserver.ubuntu.com'
  key 'F24AEA9FB05498B7'
end

if node[:platform] == 'ubuntu'
  # It has to be glob * because steam is an i386 package, and
  # apt_preferences doesn't understand multiarch package names.
  apt_preference 'steam' do
    glob '*'
    pin 'origin repo.steampowered.com'
    pin_priority '600'
    notifies :run, 'execute[apt-get update]', :immediately
  end
end

# Hidden dependencies not reflected in apt, for some reason.
package [
 'libsdl2-2.0-0:i386',
 'libsdl2-2.0-0',
 'libxtst6:i386',
 'libxtst6',
 'libpulse0:i386',
 'libpulse0',
] do
  action :upgrade
end

package [ 'debconf-utils', 'unzip', ] do
  action :upgrade
end

# Steam's extra special fonts.
steam_fonts_zip_path = Chef::Config[:file_cache_path] + '/SteamFonts.zip'
user_fonts_path = node['desktop']['user']['home'] + '/.fonts'
remote_file steam_fonts_zip_path  do
  source 'https://support.steampowered.com/downloads/1974-YFKL-4947/SteamFonts.zip'
  checksum 'a03bcc9581f2896cac39967633fc43546af5ed9d73d505a10cae4016797dfeb1'
end

directory user_fonts_path do
  user node['desktop']['user']['name']
  group node['desktop']['user']['group']
  mode 0755
end

execute 'steam-fonts-unzip' do
  user node['desktop']['user']['name']
  command "unzip -d #{user_fonts_path} #{steam_fonts_zip_path}"
  creates "#{user_fonts_path}/arialbd.ttf"
end

# Accept the Steam EULA.
steam_selections_path = Chef::Config[:file_cache_path] + '/steam.selections'
file steam_selections_path do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    # STEAM LICENSE AGREEMENT (ARROW keys scroll, TAB key to move to "Ok")
    steam   steam/license   note
    # STEAM PURGE NOTE
    steam   steam/purge     note
    # Do you agree to all terms of the Steam License Agreement?
    steam   steam/question  select  I AGREE
  EOM
end

execute 'accept-steam-eula' do
  command "cat #{steam_selections_path} | debconf-set-selections"
end

apt_package 'steam' do
  action :upgrade
end
  
