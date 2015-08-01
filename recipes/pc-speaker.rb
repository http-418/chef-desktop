execute 'modprobe -r pcspkr' do
  only_if 'lsmod | grep pcspkr'
end

file '/etc/modprobe.d/pcspkr-blacklist.conf' do
  mode 444
  content <<-EOM.gsub(/^ {4}/,'')
    # This file is maintained by Chef.
    # Local changes will be overwritten.
    blacklist pcspkr
  EOM
  notifies :run, 'execute[pcspkr-depmod]'
end

execute 'pcspkr-depmod' do
  command 'depmod -a'
  action :nothing
end
