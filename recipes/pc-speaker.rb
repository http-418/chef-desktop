#
# Cookbook Name:: desktop
# Recipe:: pc-speaker
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

# This recipe disables the PC speaker driver on Debian.
execute 'modprobe -r pcspkr' do
  only_if 'lsmod | grep pcspkr'
end

file '/etc/modprobe.d/pcspkr-blacklist.conf' do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    # This file is maintained by #{Chef::Dist::PRODUCT}.
    # Local changes will be overwritten.
    blacklist pcspkr
  EOM
  notifies :run, 'execute[pcspkr-depmod]'
end

execute 'pcspkr-depmod' do
  command 'depmod -a'
  action :nothing
end
