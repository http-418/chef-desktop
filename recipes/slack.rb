#
# Cookbook Name:: desktop
# Recipe:: slack
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'desktop::libgcrypt11'

package [ 
         'gconf2', 
         'gconf-service', 
         'libgtk2.0-0', 
         'libudev1', 
         'libgcrypt11',
         'libnotify4', 
         'libxtst6', 
         'libnss3', 
         'python', 
         'gvfs-bin', 
         'xdg-utils',
         'apt-transport-https',
         'libgnome-keyring0',
        ] do
  action :install
end

# Slack doesn't have official Ubuntu/Trusty repos, so use Jessie everywhere.
apt_repository 'slacktechnologies_slack' do
  components ['main']
  distribution 'jessie'
  key 'https://packagecloud.io/slacktechnologies/slack/gpgkey'
  uri 'https://packagecloud.io/slacktechnologies/slack/debian/'
end

package 'slack-desktop'
