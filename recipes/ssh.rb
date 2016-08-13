package 'openssh-server'
package 'openssh-client'

template '/etc/ssh/sshd_config' do
  mode 0400
  source 'ssh/sshd_config.erb'
  variables(sftp_chroots: node['desktop']['ssh']['sftp_chroots'])
  notifies :reload, 'service[ssh]'
end

service 'ssh' do
  action [ :enable, :start ]
end

