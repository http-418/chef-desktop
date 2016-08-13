#
# Cookbook Name:: desktop
# Recipe:: pulseaudio
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

include_recipe 'apt'
package ['procps', 'pulseaudio']

directory '/etc/pulse' do
  mode 0755
end

template '/etc/pulse/daemon.conf' do
  source 'pulseaudio/daemon.conf.erb'
  mode 0444
  notifies :run, 'execute[pulseaudio-restart]'
end

execute 'pulseaudio-restart' do
  command 'killall -15 pulseaudio'
  only_if 'pgrep pulseaudio'
  action :nothing
  ignore_failure true
end
