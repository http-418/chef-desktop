#
# Cookbook Name:: desktop
# Recipe:: steam_controller_udev_rules
#
# Copyright 2016 Andrew Jones
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
# This recipe configures udev rules to set permissions on /dev/uinput
# for Steam virtual gamepad support.
#

template '/etc/udev/rules.d/99-steam-controller-uinput.rules' do
  source 'steam/steam-controller-perms.rules.erb'
  mode 0444
  notifies :run, 'execute[udev-reload-uinput-driver]', :immediately
end

execute 'udev-reload-uinput-driver' do
  action :nothing
  command 'udevadm control --reload; modprobe -r uinput; modprobe uinput'
end
