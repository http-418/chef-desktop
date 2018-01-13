#
# Cookbook Name:: desktop
# Recipe:: libgcrypt11
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
# Spotify and Slack linux clients require a library that has been
# removed from both Ubuntu and Debian.  No way around it.  Fortunately
# Ubuntu 14.04 LTS retains libgcrypt11.  On Debian, we just have to
# pull the wheezy version.
#
if node['platform'] == 'debian'
  libgcrypt11_path = Chef::Config[:file_cache_path] + '/libgcrypt11.deb'

  remote_file libgcrypt11_path do
    source 'http://security.debian.org/debian-security/pool/updates/main/libg/libgcrypt11/libgcrypt11_1.5.0-5+deb7u6_amd64.deb'
    checksum '4b44bc35225aa51ce70a982c49bf320cb0861556e04a867e4a9231fb8dd31820'
    notifies :install, 'dpkg_package[libgcrypt11]', :immediately
  end

  dpkg_package 'libgcrypt11' do
    package_name libgcrypt11_path
    action :nothing
  end

  log 'Doing initial install on libgcrypt11...' do
    not_if 'dpkg --get-selections | grep libgcrypt11 | grep -v deinstall'
    notifies :install, 'dpkg_package[libgcrypt11]', :immediately
  end
elsif node['platform'] == 'ubuntu'
  version = Gem::Version.new(node[:platform_version])

  if version > Gem::Version.new('14.04')
    package 'libgcrypt20'
  else
    package 'libgcrypt11'
  end
end
