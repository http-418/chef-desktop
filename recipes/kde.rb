#
# Cookbook Name:: desktop
# Recipe:: kde
#
# Installs KDE and a default system-wide configuration.
#

include_recipe 'desktop::apt'

package 'debconf-utils'

execute 'kde-preseed-kdm' do
  command 'echo "kdm shared/default-x-display-manager select kdm" | debconf-set-selections'
  not_if 'debconf-get-selections | grep shared/default-x-display-manager | grep "kdm$"'
  notifies :run, 'execute[kdm-reconfigure]'
end

[
  'kde-plasma-desktop',
  'kscreen', # Display settings are absent without this package.
  'plasma-widget-adjustableclock',
  'yakuake'
].each do |package_name|
  package package_name
end

service 'kdm' do
  action [ :start, :enable ]
end

execute 'kdm-reconfigure' do
  command 'dpkg-reconfigure -f noninteractive kdm'
  action :nothing
  only_if 'dpkg --get-selections | grep ^kdm | grep -v deinstall'
end

apps_directory = '/usr/share/kde4/apps/'
config_directory = '/etc/kde4'

directory apps_directory do
  mode 0555
  recursive true
end

directory config_directory do
  mode 0555
  recursive true
end

directory "#{apps_directory}/konsole" do
  mode 0555
  recursive true
end

template "#{config_directory}/auroraerc" do
  mode 0444
  source 'kde/auroraerc.erb'
end

template "#{config_directory}/konsolerc" do
  mode 0444
  source 'kde/konsolerc.erb'
end

template "#{apps_directory}/konsole/Desktop-Cookbook-Shell.profile" do
  mode 0444
  source 'kde/Desktop-Cookbook-Shell.profile.erb'
end
