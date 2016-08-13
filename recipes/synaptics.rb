#
# Cookbook Name:: desktop
# Recipe:: synaptics
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

package 'xserver-xorg-input-synaptics'

template '/usr/local/bin/synaptics.pl' do
  mode 0555
  source 'synaptics/synaptics.pl.erb'
end

directory '/etc/X11/xorg.conf.d' do
  mode 0500
end

template '/etc/X11/xorg.conf.d/20-synaptics.conf' do
  mode 0444
  source 'synaptics/synaptics.conf.erb'
end
