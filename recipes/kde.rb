#
# Cookbook Name:: desktop
# Recipe:: kde
#
# Installs KDE and a default system-wide configuration.
#

include_recipe 'desktop::apt'

package 'debconf-utils'

execute "kde-preseed-#{dm_package}" do
  command "echo \"#{dm_package} shared/default-x-display-manager select #{dm_package}\" | debconf-set-selections"
  not_if "debconf-get-selections | grep shared/default-x-display-manager | grep \"#{dm_package}$\""
  notifies :run, "execute[#{node[:desktop][:display_manager]}-reconfigure]"
end

package [
          'plasma-desktop',
          'kscreen', # Display settings are absent without this package.
          'yakuake',
          node[:desktop][:display_manager]
        ] do
  action :install
  timeout 3600
end

service node[:desktop][:display_manager] do
  action [ :start, :enable ]
end

execute "#{node[:desktop][:display_manager]}-reconfigure" do
  command "dpkg-reconfigure -f noninteractive #{node[:desktop][:display_manager]}"
  action :nothing
  only_if "dpkg --get-selections | grep ^#{node[:desktop][:display_manager]} | grep -v deinstall"
end

# Ubuntu 16.04+ are missing plasma-widget-adjustableclock
if node[:platform] == 'ubuntu' &&
    Gem::Version.new(node[:platform_version]) >= Gem::Version.new('16.04')
  log 'plasma-widget-adjustableclock is missing from 16.04 and above!'
  log 'TODO: build adjustableclock from source.'
else
  package 'plasma-widget-adjustableclock'
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
