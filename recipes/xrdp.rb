#
# Cookbook Name:: desktop
# Recipe::xrdp
#
# Installs and configures xrdp/sesman, an RDP-to-VNC gateway for
# Linux.  Listens for RDP on 3389, starts Xvnc if needed.
#

package [ 'freerdp-x11', 'mwm', 'x11vnc', 'xrdp', ]

template '/etc/xrdp/xrdp.ini' do
  source 'xrdp/xrdp.ini.erb'
  mode 0444
  notifies :restart, 'service[xrdp]', :immediately
end

template '/etc/xrdp/startwm.sh' do
  source 'xrdp/startwm.sh.erb'
  mode 0555
end

# By default, only members of 'tsusers' can log in via RDP.
group 'tsusers' do
  members [ node['desktop']['user']['name'] ]
  notifies :restart, 'service[xrdp]', :immediately
end

service 'xrdp' do
  action [:enable, :start]
end

config_directory = "#{node[:desktop][:user][:home]}/.config"
autostart_directory = "#{config_directory}/autostart"

directory config_directory do
  user node[:desktop][:user][:name]
  group node[:desktop][:user][:group]
  mode 0750
end

directory autostart_directory do
  user node[:desktop][:user][:name]
  group node[:desktop][:user][:group]
  mode 0750
end

# Start x11vnc on login.
user_name = node[:desktop][:user][:name]
file "#{autostart_directory}/x11vnc.desktop" do
  user user_name
  group node[:desktop][:user][:group]
  mode 0555
  content <<-EOM.gsub(/^ {4}/,'')
    [Desktop Entry]
    Exec=sh -c "x11vnc -unixpw #{user_name} -listen localhost &"
    Hidden=false
    Name=x11vnc for #{user_name}
    Type=Application
    NoDisplay=true
  EOM
end
