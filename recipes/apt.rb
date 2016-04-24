#
# Cookbook Name:: desktop
# Recipe:: apt
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

if node['platform'] == 'debian'
  node.default['debian']['mirror'] = 'http://mirror.rit.edu/debian'
  platform_recipe = 'debian'
elsif node['platform'] == 'ubuntu'
  platform_recipe = 'ubuntu'
else
  raise "Unsupported platform: #{node['platform']}"
end

# Force apt to keep your old configuration files when possible,
# instead of prompting for you to make a decision.
file '/etc/apt/apt.conf.d/02dpkg-options' do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    Dpkg::Options {
      "--force-confdef";
      "--force-confold";
    }
  EOM
end

execute 'configure-multiarch' do
  command 'dpkg --add-architecture i386'
  not_if 'dpkg --print-foreign-architectures | grep i386'
  notifies :run, 'execute[apt-get update]', :immediately
end

include_recipe platform_recipe
