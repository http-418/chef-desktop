#
# Cookbook Name:: desktop
# Recipe:: youtube-dl
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#
# youtube-dl updates way too fast for distributions to keep up.
# This recipe updates it directly from git.
#

include_recipe 'apt'

package [ 'ffmpeg', 'pandoc' ]

ytdl_src_path = '/usr/local/src/youtube-dl'
directory ytdl_src_path do
  user node['desktop']['user']['name']
  group node['desktop']['user']['group']
end

git ytdl_src_path do
  repository 'https://github.com/rg3/youtube-dl.git'
  user node['desktop']['user']['name']
  group node['desktop']['user']['group']
  revision 'master'
  action :sync
  notifies :run, 'execute[youtube-dl-make]', :immediately
end

execute 'youtube-dl-make' do
  cwd ytdl_src_path
  user node['desktop']['user']['name']
  command 'make clean && make'
  creates "#{ytdl_src_path}/youtube-dl"
end

link '/usr/local/bin/youtube-dl' do
  to "#{ytdl_src_path}/youtube-dl"
end

package 'youtube-dl' do
  action :remove
end
