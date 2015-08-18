#
# Cookbook Name:: desktop-work
# Recipe:: citrix
# Author:: Andrew Jones
#
require 'fileutils'
require 'nokogiri'
require 'tempfile'

citrix_html_path = Tempfile.new('citrix_html').path
citrix_deb_path = "#{Chef::Config[:file_cache_path]}/icaclient_amd64.deb"

remote_file citrix_html_path do
  source 'https://www.citrix.com/downloads/citrix-receiver/legacy-receiver-for-linux/receiver-for-linux-131.html'
  not_if{ File.exists?(citrix_deb_path) }
end

#
# We fetch the download page to get the rel reflecting our acceptance
# of the EULA.  (Not to worry: the user will be prompted with a
# duplicate EULA when the app is actually launched.)
#
ruby_block 'citrix-get-url' do
  block do
    page = Nokogiri::HTML(open(citrix_html_path))
    final_rel = 
      page.css(".ctx-dl-link")
      .map{|el| el['rel']}
      .select{ |rel| rel.include?("icaclient") && rel.include?("amd64") }
      .first
    link = "https:#{final_rel}" 
    node.set['desktop_citrix_onetime_url'] = link
  end
  not_if{ File.exists?(citrix_deb_path) }
end

#
# The checksum prevents us from attempting a download over and over.
#
# Deleting the checksum will make this recipe blow up: The file will
# always need to be downloaded, but the one-time URL will never be
# present in the expected attribute.
#
remote_file citrix_deb_path do
  source lazy { node['desktop_citrix_onetime_url'] }
  checksum '730ae2e1fa24dd047e37da8783aea916bf6c50e3ba76f0c32d9cec855fba1452'
end  

ruby_block 'citrix-purge-url' do
  block do
    node.delete('desktop_citrix_onetime_url')
    FileUtils.rm(citrix_html_path) rescue nil
  end
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
 'libxp6',
 'libxp6:i386',
 'libwebkitgtk-1.0-0',
 'nspluginwrapper',
]

package_names.reject{ |p| p.include?(":i386") }.each do |amd64_package|
  package amd64_package
end

package_names.select{ |p| p.include?(":i386") }.each do |i386_package|
  package i386_package
end

# Accept another duplicate EULA.
execute 'citrix-accept-eula' do
  command "echo icaclient icaclient/accepteula select true | " +
    "debconf-set-selections"
  not_if "debconf-get-selections | grep icaclient/accepteula | grep true"
end

dpkg_package citrix_deb_path

Dir.glob('/usr/share/ca-certificates/mozilla/*').each do |source_path|
  target_path = 
    '/opt/Citrix/ICAClient/keystore/cacerts/' + File.basename(source_path)
  link target_path do
    to source_path
  end
end
