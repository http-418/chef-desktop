default['desktop']['user'].tap do |user|
  user['name'] = 'ajones'
  user['uid'] = '1000'
  user['group'] = 'ajones'
  user['gid'] = '1000'
  user['home'] = '/home/ajones'
end

