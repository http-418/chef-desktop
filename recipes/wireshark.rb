#
# Cookbook Name:: desktop
# Recipe:: wireshark
#
# Installs Wireshark and configures non-privileged access.
#

include_recipe 'apt'

package 'debconf-utils'

execute 'wireshark-preseed-dumpcap' do
  command 'echo "wireshark-common wireshark-common/install-setuid boolean true" | debconf-set-selections'
  not_if 'debconf-get-selections | grep wireshark-common/install-setuid | grep true'
  notifies :run, 'execute[wireshark-reconfigure]'
end

package 'wireshark'

execute 'wireshark-reconfigure' do
  command 'dpkg-reconfigure -f noninteractive wireshark-common'
  action :nothing
end

group 'wireshark' do
  action :modify
  members node['desktop']['user']['name']
  append true
end
