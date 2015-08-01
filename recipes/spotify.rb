#
# Spotify's ancient linux client requires a library that has been
# removed from both Ubuntu and Debian.  No way around it.  Fortunately
# Ubuntu 14.04 LTS retains libgcrypt11.  On Debian, we just have to
# pull the wheezy version.
#
if node['platform'] == 'debian'
  libgcrypt11_path = Chef::Config[:file_cache_path] + '/libgcrypt11.deb'
  remote_file libgcrypt11_path do
    source 'http://security.debian.org/debian-security/pool/updates/main/libg/libgcrypt11/libgcrypt11_1.5.0-5+deb7u3_amd64.deb'
    checksum 'dc415d0de33a59faf30cc33ac6a49dcd4a4a6759c487fbd8b000a5465fbf6602'
  end
  dpkg_package libgcrypt11_path do
    not_if 'dpkg --get-selections | grep libgcrypt11'
  end
elsif node['platform'] == 'ubuntu'
  # This will blow up on Ubuntu releases newer than 14.04.
  # I guess that's 2016's problem.
  package 'libgcrypt11'
end

apt_repository 'spotify' do
  uri 'http://repository.spotify.com'
  components ['stable', 'non-free']
  keyserver 'keyserver.ubuntu.com'
  key 'D2C19886'
end

package 'spotify-client'
