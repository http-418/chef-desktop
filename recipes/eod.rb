#
# Cookbook Name:: desktop
# Recipe:: eod
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

package 'libpangox-1.0-0' do
  action :upgrade
end

#
# This recipe installs the Exceed On Demand client for Linux.
# It does not configure the corresponding MIME handler.
#
eod_tarball_path =
  Chef::Config['file_cache_path'] + '/eodclient8-13.8.3-linux-x64.tar.gz'

remote_file eod_tarball_path do
  source 'http://mimage.opentext.com/patches/connectivity/eod8/_ed0wn15/e0dc1n7/linux/eodclient8-13.8.3-linux-x64.tar.gz'
  checksum '9834a630863fbbcbeffbbeff4441eee0167fd2d1f71b36bccdcfec5c083ec139'
end

execute "tar -xvzf #{eod_tarball_path}" do
  cwd '/opt'
  umask 0002
  not_if{ File.exists?('/opt/Exceed_onDemand_Client_8/eodxc') }
end

link '/usr/local/bin/eodxc' do
  to '/opt/Exceed_onDemand_Client_8/eodxc'
end
