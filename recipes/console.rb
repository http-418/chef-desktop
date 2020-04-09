#
# Cookbook Name:: desktop
# Recipe:: console
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

package ['debconf-utils','console-setup'] do
  action :upgrade
end

remote_file '/usr/share/consolefonts/Sun12x22.psfu' do
  source 'https://github.com/legionus/kbd/' +
    'blob/master/data/consolefonts/sun12x22.psfu?raw=true'
  mode 0444
  user 'root'
  group 'root'
end

# On systemd-equipped systems, the linux console parses XKBOPTIONS
template '/etc/default/keyboard' do
  source 'console/default-keyboard.erb'
  mode 0444
  user 'root'
  group 'root'
end

template '/etc/default/console-setup' do
  source 'console/default-console-setup.erb'
  mode 0444
  user 'root'
  group 'root'
end

execute 'setupcon' do
  user 'root'
end
