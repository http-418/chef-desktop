#
# Cookbook Name:: desktop
# Recipe:: fonts
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

execute 'fc-cache -fv' do
  action :nothing
end

# Accept the EULA for Microsoft's web fonts.
# Georgia and MS Comic Sans are the really key ones here.
execute 'accept-mscorefonts-eula' do
  command 'echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections'
  not_if 'debconf-get-selections | grep msttcorefonts/accepted-mscorefonts-eula | grep true'
end

# desktop fonts
package [
 'fonts-inconsolata',
 'fonts-liberation',
 'ttf-mscorefonts-installer',
 'xfonts-75dpi',
 'xfonts-100dpi',
 'xfonts-base',
 'xfonts-scalable',
] do
  action :install
  notifies :run, 'execute[fc-cache -fv]'
end
