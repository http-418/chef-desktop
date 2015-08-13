#
# Cookbook Name:: desktop
# Recipe:: steam
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#
# This recipe attempts to install steam and fix up fonts, but it will
# fail because of Steam's irritating clickthrough EULA.  Workaround:
# Manually install the steam package before including this recipe.
#
apt_repository 'steam' do
  uri 'http://repo.steampowered.com/steam/'
  components ['precise', 'steam']
  keyserver 'keyserver.ubuntu.com'
  key 'F24AEA9FB05498B7'
  notifies :run, 'execute[apt-get update]', :immediately
end

# Hidden depedencies not reflected in apt, for some reason.
[
 'libsdl2-2.0-0:i386',
 'libxtst6:i386',
 'libpulse0:i386',
].each do |package_name|
  package package_name
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

package 'steam'
