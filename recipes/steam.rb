#
# Cookbook Name:: desktop
# Recipe:: steam
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
# This recipe installs Steam and its fonts.  It used to fail due to an
# EULA, but that should not happen anymore.
#
include_recipe 'desktop::apt'
include_recipe 'desktop::user'
include_recipe 'desktop::steam_fonts'
include_recipe 'desktop::steam_controller_udev_rules'

if node[:platform] == 'ubuntu'
  apt_repository 'steam' do
    uri 'http://repo.steampowered.com/steam/'
    components ['precise', 'steam']
    keyserver 'keyserver.ubuntu.com'
    key 'F24AEA9FB05498B7'
  end

  file '/etc/apt/preferences.d/steam.pref' do
    content <<-EOM.gsub(/^ */,'')
      Package: steam:i386
      Pin: origin repo.steampowered.com
      Pin-Priority: 900
    EOM
    notifies :run, 'execute[apt-get update]', :immediately
  end
else
  include_recipe 'desktop::stretch'

  file '/etc/apt/preferences.d/steam.pref' do
    content <<-EOM.gsub(/^ */,'')
      Package: steam:i386
      Pin: release n=stretch
      Pin-Priority: 900
    EOM
    notifies :run, 'execute[apt-get update]', :immediately
  end
end

# Hidden dependencies not reflected in apt, for some reason.
package [
 'libsdl2-2.0-0:i386',
 'libsdl2-2.0-0',
 'libxtst6:i386',
 'libxtst6',
 'libpulse0:i386',
 'libpulse0',
] do
  action :upgrade
end

package 'debconf-utils' do
  action :upgrade
end

# Accept the Steam EULA.
steam_selections_path = Chef::Config[:file_cache_path] + '/steam.selections'
file steam_selections_path do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    # STEAM LICENSE AGREEMENT (ARROW keys scroll, TAB key to move to "Ok")
    steam   steam/license   note
    # STEAM PURGE NOTE
    steam   steam/purge     note
    # Do you agree to all terms of the Steam License Agreement?
    steam   steam/question  select  I AGREE
  EOM
end

execute 'accept-steam-eula' do
  command "cat #{steam_selections_path} | debconf-set-selections"
end

apt_package 'steam' do
  action :upgrade
end

#
# Modern versions of ubuntu fail to load GL libraries if the bundled
# libstdc++ / libgcc are enabled inside the Steam ubuntu12 runtime.
# So we delete them.
#
# You will know you have been bitten if you see messages like this:
#
# libGL error: unable to load driver: swrast_dri.so
# libGL error: failed to load driver: swrast
#
steam_lib_path =
  File.join(node[:desktop][:user][:home],
            '.local',
            'share',
            'Steam',
            'ubuntu12_32',
            'steam-runtime',
            'i386',
            'usr',
            'lib',
            'i386-linux-gnu')

[
 'libstdc++.so.6',
 'libgcc_s.so.1'
].each do |lib_name|
  file File.join(steam_lib_path, lib_name) do
    action :delete
  end
end
