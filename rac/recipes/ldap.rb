# Set ldap

cookbook_file '/etc/nsswitch.conf' do
  mode '0600'
  source 'nss'
end

directory '/etc/sssd' do
    mode '0640'
    action :create
end

cookbook_file '/etc/sssd/sssd.conf' do
  mode '0600'
  source 'sssd'
end

bash 'update' do
	code "authconfig --enablesssd --enablesssdauth --enablelocauthorize --enablemkhomedir --enablepamaccess --disablewinbind --disablekrb5 --nostart --update"
end