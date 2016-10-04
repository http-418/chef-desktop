#
# Cookbook Name:: desktop
# Recipe:: citrix
#
# Copyright 2015 Andrew Jones
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# This recipe installs the Citrix Receiver for Linux
#
chef_gem 'nokogiri' do
  compile_time false
end

require 'digest'
require 'fileutils'
require 'tmpdir'

citrix_html_path = '/tmp/' + Dir::Tmpname.make_tmpname('citrix', 'html')
citrix_deb_path = "#{Chef::Config[:file_cache_path]}/icaclient_amd64.deb"
citrix_checksum =
  'd41e70624960b9dd9c4856bfb051dad4ef1eb4eb6a586a530b09dc74a714b1df'

citrix_deb_is_valid = lambda do
  (File.exists?(citrix_deb_path) &&
   Digest::SHA256.hexdigest(File.read(citrix_deb_path)) == citrix_checksum)
end

remote_file citrix_html_path do
  top_url = 'https://www.citrix.com/downloads/citrix-receiver/'
  source [
           'legacy-receiver-for-linux/receiver-for-linux-134.html',
           'linux/receiver-for-linux-latest.html'
         ].map { |fragment| top_url + fragment }
  not_if{ citrix_deb_is_valid.call }   
end

#
# We fetch the download page to get the rel reflecting our acceptance
# of the EULA.  (Not to worry: the user will be prompted with a
# duplicate EULA when the app is actually launched.)
#
ruby_block 'citrix-get-url' do
  block do
    require 'nokogiri'
    page = Nokogiri::HTML(open(citrix_html_path))
    final_rel = 
      page.css(".ctx-dl-link")
      .map{|el| el['rel']}
      .select{ |rel| rel.include?("icaclient") && rel.include?("amd64") }
      .first
    link = "https:#{final_rel}"
    node.run_state['desktop_citrix_onetime_url'] = link
  end
  not_if{ citrix_deb_is_valid.call }
end

#
# The checksum prevents us from attempting a download over and over.
#
# Deleting the checksum will make this recipe blow up: The file will
# always need to be downloaded, but the one-time URL will never be
# present in the expected attribute.
#
remote_file citrix_deb_path do
  source lazy { node.run_state['desktop_citrix_onetime_url'] }
  checksum citrix_checksum
end

package_names = [ 
 'debconf-utils',
 'libatk1.0-0',
 'libatk1.0-0:i386',
 'libcairo2',
 'libcairo2:i386',
 'libcanberra-gtk-module',
 'libcanberra-gtk-module:i386',
 'libgtk2.0-0',
 'libgtk2.0-0:i386',
 'libspeex1',
 'libspeex1:i386',
 'libxmu6',
 'libxmu6:i386',
 'libxpm4',
 'libxpm4:i386',
 'libxp6',
 'libxp6:i386',
 'libwebkitgtk-1.0-0',
]

# amd64, all in one batch
package package_names.reject{ |p| p.include?(":i386") } do
  action :install
end

# now that the amd64 versions are pre-installed, tackle i386
package package_names.select{ |p| p.include?(":i386") } do
  action :install
end

# Accept another duplicate EULA.
execute 'citrix-accept-eula' do
  command "echo icaclient icaclient/accepteula select true | " +
    "debconf-set-selections"
  not_if "debconf-get-selections | grep icaclient/accepteula | grep true"
end

dpkg_package citrix_deb_path do
  options '--force-confnew'
end

Dir.glob('/usr/share/ca-certificates/mozilla/*').each do |source_path|
  target_path = 
    '/opt/Citrix/ICAClient/keystore/cacerts/' + File.basename(source_path)
  link target_path do
    to source_path
  end
end

execute 'c_rehash /opt/Citrix/ICAClient/keystore/cacerts/'

# Attempt to install a default wfclient.ini with TWIUse_NET_ACTIVE=Off
begin
  citrix_directory = File.join(node['desktop']['user']['home'], '.ICAClient')
  citrix_ini_path = File.join(citrix_directory, 'wfclient.ini')

  directory citrix_directory do
    user node['desktop']['user']['name']
    group node['desktop']['user']['group']
    mode 0770
  end

  template citrix_ini_path  do
    user node['desktop']['user']['name']
    group node['desktop']['user']['group']
    mode 0660
    source 'citrix/wfclient.ini.erb'
    not_if "grep TWIUse_NET_ACTIVE=Off #{citrix_ini_path}"
  end

  log 'Skipping default Citrix wfclient.ini, TWIUse_NET_ACTIVE already set' do
    only_if "grep TWIUse_NET_ACTIVE=Off #{citrix_ini_path}"
  end  
rescue
  log 'Skipping default Citrix wfclient.ini, unable to load desktop user'
end
