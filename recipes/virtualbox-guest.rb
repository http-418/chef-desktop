#
# Cookbook Name:: desktop
# Recipe:: virtualbox-guest
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

if (node[:virtualization][:system] == 'vbox' &&
    node[:virtualization][:role] == 'guest')

  package ['virtualbox-guest-dkms',
           'virtualbox-guest-utils',
           'virtualbox-guest-x11'] do
  end

  file '/etc/X11/xorg.conf.d/20-nvidia.conf' do
    action :delete
  end

  file '/etc/X11/xorg.conf.d/20-vboxvideo.conf' do
    mode 0444
    content <<-EOM.gsub(/^ {6}/,'')
      # This file is maintained by Chef.
      # Local changes will be overwritten.
      Section "Device"
        Identifier "VirtualBox"
        Driver "vboxvideo"
      EndSection
    EOM
    notifies :restart, "service[#{node[:desktop][:display_manager]}]"
  end

else
  file '/etc/X11/xorg.conf.d/20-vboxvideo.conf' do
    action :delete
  end

  log 'This host is not a VirtualBox guest.'
end
