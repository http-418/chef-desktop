#
# Cookbook Name:: desktop
# Recipe::xrdp
#
# Installs xrdp 
#

package [ 'freerdp-x11', 'x11vnc', 'xrdp', ]

template '/etc/xrdp/xrdp.ini' do
  source 'xrdp/xrdp.ini.erb'
  mode 0444
  notifies :restart, 'service[xrdp]', :immediately
end

service 'xrdp' do
  action [:enable, :start]
end
