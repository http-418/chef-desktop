

deb_name = 'VidyoDesktopInstaller-ubuntu64-TAG_VD_3_3_0_027.deb'
deb_path = "#{Chef::Config[:file_cache_path]}/#{deb_name}"
remote_file deb_path do
  source "https://demo.vidyo.com/upload/#{deb_name}"
  checksum 'ac19b3995d31274e33d9b72db665cb86b475e07028c1ba0aa9ece220c84fae10'
end

package 'libqt4-gui'

dpkg_package deb_path
