#
# Cookbook Name:: desktop
# Recipe:: kde
#
# Installs KDE and a default system-wide configuration.
#

# package 'debconf-utils'

# execute 'preseed-dm' do
#   command 'echo "kdm shared/default-x-display-manager select kdm" | debconf-set-selections'  
# end

[
  'kde-plasma-desktop',
  'yakuake'
].each do |package_name|
  package package_name
end

service 'kdm' do
  action [ :start, :enable ]
end

apps_directory = '/etc/kde4/share/kde4/apps/'
config_directory = '/etc/kde4/share/kde4/config/'

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

template "#{config_directory}/konsolerc" do
  mode 0444
  source 'kde/konsolerc.erb'
end

template "#{apps_directory}/konsole/Shell.profile" do
  mode 0444
  source 'kde/Shell.profile.erb'
end
