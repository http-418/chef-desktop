package 'xserver-xorg-video-nouveau' do
  action :purge
end

file '/etc/modprobe.d/nouveau-blacklist.conf' do
  mode 444
  content <<-EOM.gsub(/^ {4}/,'')
    # This file is maintained by Chef.
    # Local changes will be overwritten.
    blacklist nouveau
  EOM
  notifies :run, 'execute[nvidia-depmod]'
end

execute 'nvidia-depmod' do
  command 'depmod -a'
  action :nothing
end

if node['platform'] == 'debian'
  [
   'build-essential',
   'linux-headers-amd64',
   'libgl1-nvidia-glx-i386',
   'nvidia-kernel-dkms',
   'nvidia-settings',
   'nvidia-alternative',
   'xserver-xorg-video-nvidia',
  ].each do |package_name|
    package package_name
  end
elsif node['platform'] == 'ubuntu'
  [
   'build-essential',
   'linux-headers-generic',
   'nvidia-current'
  ].each do |package_name|
    package package_name
  end
end

log "platform: #{node['platform']}"
module_conf_path = if(node['platform'] == 'debian')
  '/etc/modules-load.d/nvidia.conf' 
else
  '/etc/modprobe.d/nvidia.conf'
end

file module_conf_path do
  mode 444
  content <<-EOM.gsub(/^ {4}/,'')
    # This file is maintained by Chef.
    # Local changes will be overwritten.
    nvidia
  EOM
end

execute 'depmod -a'

directory '/etc/X11/xorg.conf.d/' do
  recursive true
  mode 555
end

file '/etc/X11/xorg.conf.d/20-nvidia.conf' do
  mode 444
  content <<-EOM.gsub(/^ {4}/,'')
    # This file is maintained by Chef.
    # Local changes will be overwritten.
    Section "Device"
      Identifier "Nvidia GPU"
      Driver "nvidia"
    EndSection
  EOM
end
