

deb_name = 'VidyoDesktopInstaller-ubuntu64-TAG_VD_3_6_3_017.deb'
deb_path = "#{Chef::Config[:file_cache_path]}/#{deb_name}"
remote_file deb_path do
  source "https://demo.vidyo.com/upload/#{deb_name}"
  checksum '9d2455dc29bfa7db5cf3ec535ffd2a8c86c5a71f78d7d89c40dbd744b2c15707'
end

package 'libqt4-gui'

dpkg_package deb_path
