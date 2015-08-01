default['desktop']['user'].tap do |user|
  user['name'] = 'ajones'
  user['uid'] = '1001'
  user['group'] = 'ajones'
  user['gid'] = '1001'
  user['home'] = '/home/ajones'
end

