#
# Cookbook Name:: desktop
# Recipe:: bluetooth
#
# Copyright 2020 Andrew Jones
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
# Installs the Bluetooth stack on Debian/Ubuntu.
#
directory '/lib/firmware' do
  mode 0755
end

directory '/lib/firmware/brcm' do
  mode 0755
end

#
# This proprietary Broadcom firmware is distributed by Plugable systems.
# Most Bluetooth dongles will not work correctly without it.
#
# http://plugable.com/2014/06/23/plugable-usb-bluetooth-adapter-solving-hfphsp-profile-issues-on-linux
#
# There is a newer "A1" firmware that exists.  Modern kernels raise an
# error about the missing "A1" file. But making the version from the
# bcm firmware project available breaks my existing BT dongles.
#
remote_file '/lib/firmware/brcm/BCM20702A0-0a5c-21e8.hcd' do
  mode 0444
  source 'https://s3.amazonaws.com/plugable/bin/fw-0a5c_21e8.hcd'
  checksum 'd699c13fe1e20c068a8a88dbbed49edc12527b0ceeeaac3411e3298573451536'
  notifies :run, 'execute[btusb-reload]'
end

execute 'btusb-reload' do
  action :nothing
  command '/sbin/modprobe -r btusb; /sbin/modprobe btusb'
end

include_recipe 'desktop::apt'

[
  'blueman',
  'bluetooth',
  'bluez',
  'bluez-obexd',
  'bluez-tools',
  'pulseaudio',
  'pulseaudio-module-bluetooth',
  'sudo'
].compact.each do |package_name|
  package package_name do
    action :upgrade
  end
end

if node['platform']  == 'debian'
  package [
           'bluez-firmware',
           'firmware-atheros',
           'firmware-linux',
           'firmware-linux-nonfree',
          ] do
    action :upgrade
  end
end

#
# sys-proctable's unusual platform scheme confuses the gem_package and
# chef_gem providers, so we are stuck with an execute resource.
#
gem_path = Pathname.new(Gem.ruby).dirname.join('gem').to_s
gem_name = 'sys-proctable'
gem_version = '>= 1.1.4'

execute "chef_gem_install_#{gem_name}" do
  command "#{gem_path} install #{gem_name} " \
    '--no-user-install ' \
    '-q -N --platform universal-linux ' \
    "-v '#{gem_version}'"
  umask 0022
  live_stream true if respond_to?(:live_stream)
end

# Make sure PulseAudio has BT support enabled for all PulseAudio users.
ruby_block 'load-pa-bt-module' do
  block do
    Gem.clear_paths

    require 'etc'
    require 'sys/proctable'

    pulseaudio_user_uid_pairs = Sys::ProcTable.ps.select do |pp|
      pp.cmdline.start_with?('/usr/bin/pulseaudio')
    end.map do |pp|
      [Etc.getpwuid(pp.uid).name, pp.uid] rescue nil
    end.compact

    pulseaudio_user_uid_pairs.each do |user_name,user_id|
      pa_server = "unix:/run/user/#{user_id}/pulse/native"

      Chef::Log.info("Updating Pulseaudio user: #{user_name} (#{user_id})")
      Chef::Log.info("Updating Pulseaudio server: #{pa_server}")

      Chef::Resource::Execute.new("#{user_name}-pactl-bt-load",
                                  node.run_context).tap do |ee|
        ee.command "pactl --server #{pa_server} " \
          "load-module module-bluetooth-discover"
        ee.user user_name
        ee.not_if "pactl --server #{pa_server} list | grep module-bluetooth-discover"
      end.run_action(:run)
    end
  end
end
