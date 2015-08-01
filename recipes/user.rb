node['desktop']['user'].tap do |user|
  user user['name'] do
    comment "#{node['fqdn']} administrator"
    uid user['uid']
    gid user['group']
    home user['home']
    shell '/bin/bash'
    manage_home true
  end

  directory user['home'] + '/bin' do
    owner user['name']
    group user['group']
    mode 0700
  end
end
