#
# Cookbook Name:: desktop
# Recipe:: libgcrypt11
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#
# Spotify and Slack linux clients require a library that has been
# removed from both Ubuntu and Debian.  No way around it.  Fortunately
# Ubuntu 14.04 LTS retains libgcrypt11.  On Debian, we just have to
# pull the wheezy version.
#

if node['platform'] == 'debian'
  libgcrypt11_path = Chef::Config[:file_cache_path] + '/libgcrypt11.deb'

  remote_file libgcrypt11_path do
    source 'http://security.debian.org/debian-security/pool/updates/main/libg/libgcrypt11/libgcrypt11_1.5.0-5+deb7u4_amd64.deb'
    checksum '67cabf2672cb6a95afe05eaa773abcb10dc941c56326a789fa8a90d3d58a48d8'
    notifies :install, 'dpkg_package[libgcrypt11]', :immediately
  end
  
  dpkg_package 'libgcrypt11' do
    package_name libgcrypt11_path
    action :nothing
  end

  log 'Doing initial install on libgcrypt11...' do
    not_if 'dpkg --get-selections | grep libgcrypt11 | grep -v deinstall'
    notifies :install, 'dpkg_package[libgcrypt11]', :immediately
  end
elsif node['platform'] == 'ubuntu'
  # This will blow up on Ubuntu releases newer than 14.04.
  # I guess that's 2016's problem.
  package 'libgcrypt11'
end
