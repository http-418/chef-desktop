#
# Cookbook Name:: desktop
# Recipe:: virtualbox-guest
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

if (node[:virtualization][:system] == 'vbox' &&
    node[:virtualization][:role] == 'guest')

  package ['virtualbox-guest-dkms',
           'virtualbox-guest-utils',
           'virtualbox-guest-x11'] do
  end

  file '/etc/X11/xorg.conf.d/20-nvidia.conf' do
    action :delete
  end

  file '/etc/X11/xorg.conf.d/20-vboxvideo.conf' do
    mode 0444
    content <<-EOM.gsub(/^ {4}/,'')
    # This file is maintained by Chef.
    # Local changes will be overwritten.
    Section "Device"
      Identifier "VirtualBox"
      Driver "vboxvideo"
    EndSection
  EOM
    notifies :restart, 'service[kdm]'
  end

else
  file '/etc/X11/xorg.conf.d/20-vboxvideo.conf' do
    action :delete
  end

  log 'This host is not a VirtualBox guest.'
end
