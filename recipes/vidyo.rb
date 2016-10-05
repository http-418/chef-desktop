#
# Cookbook Name:: desktop
# Recipe:: vidyo
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
# This recipe installs the VidyoDesktop client.  It is not
# particularly useful unless you happen to have the proprietary Vidyo
# server installed somewhere.
#
deb_name = 'VidyoDesktopInstaller-ubuntu64-TAG_VD_3_6_3_017.deb'
deb_path = "#{Chef::Config[:file_cache_path]}/#{deb_name}"
remote_file deb_path do
  source "https://demo.vidyo.com/upload/#{deb_name}"
  checksum '9d2455dc29bfa7db5cf3ec535ffd2a8c86c5a71f78d7d89c40dbd744b2c15707'
end

package [
          'libqt4-designer',
          'libqt4-opengl',
          'libqt4-svg',
          'libqtgui4'
        ] do
  action :upgrade
end

dpkg_package deb_path
