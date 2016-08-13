#
# Cookbook Name:: desktop
# Recipe:: youtube-dl
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
# youtube-dl updates way too fast for distributions to keep up.
# This recipe updates it directly from git.
#
include_recipe 'apt'

if node['platform'] == 'debian'
  package [ 'ffmpeg', 'pandoc' ]
elsif node['platform'] == 'ubuntu'
  package [ 'libav-tools', 'pandoc' ]
else
  raise "Unsupported platform: #{node['platform']}"
end

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
