#
# Cookbook Name:: desktop
# Recipe:: steam_fonts
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute

package 'unzip'

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
