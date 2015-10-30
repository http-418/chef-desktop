
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
         'apt-transport-https'
        ] do
  action :install
end

slack_deb_path = "#{Chef::Config[:file_cache_path]}/slack-desktop-amd64.deb"

remote_file slack_deb_path do
  source 'https://slack-ssb-updates.global.ssl.fastly.net/linux_releases/slack-desktop-1.2.5-amd64.deb'
  checksum '2368e2449f08272d8ce38a423f44ed0cd35c1e77ca3c0525f069d0790b6ec58f'
end

dpkg_package slack_deb_path
