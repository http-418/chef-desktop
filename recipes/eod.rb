#
# Cookbook Name:: desktop
# Recipe:: eod
# Author:: Andrew Jones
#
# This recipe installs the Exceed On Demand client for Linux.
# It does not configure the corresponding MIME handler.
#

eod_tarball_path = 
  Chef::Config['file_cache_path'] + '/eodclient8-13.8.3-linux-x64.tar.gz'

remote_file eod_tarball_path do 
  source 'http://mimage.opentext.com/patches/connectivity/eod8/_ed0wn15/e0dc1n7/linux/eodclient8-13.8.3-linux-x64.tar.gz' 
  checksum '9834a630863fbbcbeffbbeff4441eee0167fd2d1f71b36bccdcfec5c083ec139'
end

execute "tar -xvzf #{eod_tarball_path}" do
  cwd '/opt'
  umask 0002
  not_if{ File.exists?('/opt/Exceed_onDemand_Client_8/eodxc') }
end

link '/usr/local/bin/eodxc' do
  to '/opt/Exceed_onDemand_Client_8/eodxc'
end
