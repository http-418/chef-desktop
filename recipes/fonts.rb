#
# Cookbook Name:: desktop
# Recipe:: fonts
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
