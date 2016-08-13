#
# Cookbook Name:: desktop
# Recipe:: kde
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
# Installs KDE and a default system-wide configuration.
#

include_recipe 'desktop::apt'

package 'debconf-utils'

execute "kde-preseed-#{node[:desktop][:display_manager]}" do
  command "echo \"#{node[:desktop][:display_manager]} shared/default-x-display-manager select #{node[:desktop][:display_manager]}\" | debconf-set-selections"
  not_if "debconf-get-selections | grep shared/default-x-display-manager | grep \"#{node[:desktop][:display_manager]}$\""
  notifies :run, "execute[#{node[:desktop][:display_manager]}-reconfigure]"
end

package [
          'plasma-desktop',
          'kscreen', # Display settings are absent without this package.
          'yakuake'
        ] do
  action :upgrade
  timeout 3600
end

package node[:desktop][:display_manager] do
  action :upgrade
end

service node[:desktop][:display_manager] do
  action [ :start, :enable ]
end

execute "#{node[:desktop][:display_manager]}-reconfigure" do
  command "dpkg-reconfigure -f noninteractive #{node[:desktop][:display_manager]}"
  action :nothing
  only_if "dpkg --get-selections | grep ^#{node[:desktop][:display_manager]} | grep -v deinstall"
end

# Ubuntu 16.04+ are missing plasma-widget-adjustableclock
if node[:platform] == 'ubuntu' &&
    Gem::Version.new(node[:platform_version]) >= Gem::Version.new('16.04')
  log 'plasma-widget-adjustableclock is missing from 16.04 and above!'
  log 'TODO: build adjustableclock from source.'
else
  package 'plasma-widget-adjustableclock'
end

apps_directory = '/usr/share/kde4/apps/'
config_directory = '/etc/kde4'

directory apps_directory do
  mode 0555
  recursive true
end

directory config_directory do
  mode 0555
  recursive true
end

directory "#{apps_directory}/konsole" do
  mode 0555
  recursive true
end

template "#{config_directory}/auroraerc" do
  mode 0444
  source 'kde/auroraerc.erb'
end

template "#{config_directory}/konsolerc" do
  mode 0444
  source 'kde/konsolerc.erb'
end

template "#{apps_directory}/konsole/Desktop-Cookbook-Shell.profile" do
  mode 0444
  source 'kde/Desktop-Cookbook-Shell.profile.erb'
end
