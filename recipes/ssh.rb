package 'openssh-server'
package 'openssh-client'

template '/etc/ssh/sshd_config' do
  mode 0400
  source 'ssh/sshd_config.erb'
end

service 'ssh' do
  action [ :enable, :start ]
end

