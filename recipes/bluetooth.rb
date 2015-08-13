#
# Cookbook Name:: desktop
# Recipe:: bluetooth
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

[
  'bluetooth',
  'bluez',
  'bluez-tools',
  node['platform']  == 'debian' ? 'bluez-firmware' : nil,
].compact.each do |package_name|
  package package_name
end
