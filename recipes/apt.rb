if node['platform'] == 'debian'
  include_recipe 'debian'
elsif node['platform'] == 'ubuntu'
  include_recipe 'ubuntu'
else
  raise "Unsupported platform: #{node['platform']}"
end

#
# Force apt to keep your old configuration files when possible,
# instead of prompting for you to make a decision.
#
file '/etc/apt/apt.conf.d/02dpkg-options' do
  mode 0444
  content <<-EOM.gsub(/^ {4}/,'')
    Dpkg::Options {
      "--force-confdef";
      "--force-confold";
    }
  EOM
end

apt_repository 'google-chrome-unstable' do
  uri 'http://dl.google.com/linux/chrome/deb/'
  components ['stable', 'main']
  keyserver 'keyserver.ubuntu.com'
  key 'A040830F7FAC5991'
end

execute 'configure-multiarch' do
  command 'dpkg --add-architecture i386'
  not_if 'dpkg --print-foreign-architectures | grep i386'
  notifies :run, 'execute[apt-get update]', :immediately
end
