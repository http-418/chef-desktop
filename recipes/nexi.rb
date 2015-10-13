

deb_name = 'VidyoDesktopInstaller-ubuntu64-TAG_VD_3_5_4_010.deb'
deb_path = "#{Chef::Config[:file_cache_path]}/#{deb_name}"
remote_file deb_path do
  source "https://demo.vidyo.com/upload/#{deb_name}"
  checksum '9c5ab8293b6888336bc8d7a6d8b6d097f40efd201966c18cfd983f8adf58627c'
end

package 'libqt4-gui'

dpkg_package deb_path
