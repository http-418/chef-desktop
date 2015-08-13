#
# Cookbook Name:: desktop
# Recipe:: starcraft2
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

desktop_user = node['desktop']['user']['name']
desktop_group = node['desktop']['user']['group']
desktop_user_home = node['desktop']['user']['home']
wine = '/opt/wine/bin/wine'
wineprefix = "#{desktop_user_home}/wine/starcraft2"
setup_path = "#{wineprefix}/drive_c/Starcraft-II-Setup-enUS.exe"

directory "#{desktop_user_home}/wine" do
  mode 0750
  user desktop_user
  group desktop_group
end

directory wineprefix do
  mode 0750
  user desktop_user
  group desktop_group
end

execute 'winetricks sandbox' do
  cwd wineprefix
  user desktop_user
  environment({'WINEPREFIX' => wineprefix,
               'WINE' => wine})
end

remote_file setup_path do
  source 'http://dist.blizzard.com/downloads/sc2-installers/full/StarCraft-II-Setup-enUS.exe'
  not_if{ File.exists?(setup_path) }
end

execute '/opt/wine/bin/wine Starcraft-II-Setup-enUS.exe' do
  cwd "#{wineprefix}/drive_c"
  user desktop_user
  environment({'WINEPREFIX' => wineprefix})
end
