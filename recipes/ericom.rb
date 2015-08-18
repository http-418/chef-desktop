#
# Cookbook Name:: desktop
# Recipe:: ericom
# Author:: Andrew Jones
#
# This recipe installs the Ericom Blaze RDP client.
# It also configures the necessary MIME handler.
#

if node['desktop']['ericom']['url']

  ericom_directory = Chef::Config['file_cache_path'] + '/ericom'
  ericom_tarball = ericom_directory + '/RDP_Linux.tar.gz'
  ericom_deb = ericom_directory + '/Ericom-Blaze-Client_3.5-1_i386.deb'

  directory ericom_directory do
    mode 0555
  end

  remote_file ericom_tarball do
    source node['desktop']['ericom']['url']
    checksum 'e4ac58cc8a0bfa63c77dc7b7955f754b4a8dd5b5718bd6f90059958661956b2e'
  end

  execute "tar -xzf #{ericom_tarball} Ericom-Blaze-Client_3.5-1_i386.deb" do
    cwd ericom_directory
    creates ericom_deb
  end

  dpkg_package ericom_deb

  file '/usr/share/applications/ericom.desktop' do
    mode 0444
    content <<-EOM.gsub(/'^ {4}/,'')
    [Desktop Entry]
    Name=ericom
    Exec=/usr/bin/blaze %u
    Type=Application
    NoDisplay=true
    Categories=Application;
    MimeType=x-scheme-handler/ericom;
  EOM
  end

  execute "add-ericom-to-defaults" do
    command "echo x-scheme-handler/ericom=ericom.desktop >> " +
      "/usr/share/applications/defaults.list"
    not_if "grep ericom.desktop /usr/share/applications/defaults.list"
  end

end
