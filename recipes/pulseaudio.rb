#
# Cookbook Name:: desktop
# Recipe:: pulseaudio
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
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
