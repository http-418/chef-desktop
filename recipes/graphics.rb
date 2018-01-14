#
# Cookbook Name:: desktop
# Recipe:: graphics
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

include_recipe 'desktop::apt'

package ['xserver-xorg', 'pciutils']

directory '/etc/X11/xorg.conf.d/' do
  recursive true
  mode 0555
end

# Don't configure nvidia drivers on non-nvidia systems.
if system('lspci | grep VGA | grep -i nvidia')
  include_recipe 'desktop::nvidia'
  package 'xserver-xorg'
else
  log 'This system does not contain an nVidia GPU'
  file '/etc/X11/xorg.conf.d/20-nvidia.conf' do
    action :delete
  end
  package 'xserver-xorg-video-all'
end

if (node[:virtualization][:system] == 'vbox' &&
    node[:virtualization][:role] == 'guest')
  include_recipe 'desktop::virtualbox-guest'
end
