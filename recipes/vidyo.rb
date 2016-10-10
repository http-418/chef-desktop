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

include_recipe 'desktop::apt'

package [
          'libxss1',
          'libasound2'
        ] do
  action :upgrade
end

debian_before_stretch =
  node[:platform] == 'debian' &&
  Gem::Version.new(node[:lsb][:release]) < Gem::Version.new('9.0')

ubuntu_before_xenial =
  node[:platform] == 'ubuntu' &&
  Gem::Version.new(node[:lsb][:release]) < Gem::Version.new('16.04')

if (debian_before_stretch || ubuntu_before_xenial)
  package 'libqt4-gui' do
    action :upgrade
  end
else
  package [
            'libqt4-designer',
            'libqt4-opengl',
            'libqt4-svg',
            'libqtgui4',
            'equivs'
          ] do
    action :upgrade
  end

  build_directory =
    File.join(Chef::Config.file_cache_path, 'libqt4-gui')

  directory build_directory do
    action :create
    mode 0o755
  end

  control_file_path =
    File.join(build_directory, 'control_file')

  package_path =
    File.join(build_directory,'libqt4-gui_4.8.1_amd64.deb')

  file control_file_path do
    mode 0o444
    content <<-EOM.gsub(/^ {6}/,'')
      Section: misc
      Priority: optional
      Standards-Version: 3.9.20

      Package: libqt4-gui
      Version: 4:4.8.1
      Maintainer: Andrew Jones <andrew@jones.ec>
      Architecture: amd64
      Description: Dummy package to satisfy legacy dependency.
      Depends: libqt4-designer (>= 4), libqt4-opengl (>= 4), \
               libqt4-svg (>= 4), libqtgui4 (>= 4)
    EOM
  end

  execute 'libqt4-gui-build' do
    require 'shellwords'
    cwd build_directory
    command "equivs-build -a amd64 #{control_file_path.shellescape}"
    creates package_path
  end

  dpkg_package 'libqt4-gui' do
    source package_path
  end
end

vidyo_deb_name = 'VidyoDesktopInstaller-ubuntu64-TAG_VD_3_6_3_017.deb'
vidyo_deb_path = "#{Chef::Config[:file_cache_path]}/#{vidyo_deb_name}"

remote_file vidyo_deb_path do
  source "https://demo.vidyo.com/upload/#{vidyo_deb_name}"
  checksum '9d2455dc29bfa7db5cf3ec535ffd2a8c86c5a71f78d7d89c40dbd744b2c15707'
end

dpkg_package vidyo_deb_path
