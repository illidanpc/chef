# Set ldap
echo 'sudoers: files sss' >>  /etc/nsswitch.conf

cookbook_file '/etc/sssd/sssd.conf' do
  mode '0600'
  source 'sssd'
end

bash 'update' do
	code "authconfig --enablesssd --enablesssdauth --enablelocauthorize --enablemkhomedir --enablepamaccess --disablewinbind --disablekrb5 --nostart --update"
end