  template "#{node[:rac][:oracle][:home]}/network/admin/listener.ora" do
    owner 'oracle'
    group 'oinstall'
    mode '0644'
  end
  
  # Starting listener 
  execute 'start_listener' do
    command "#{node[:rac][:oracle][:home]}/bin/lsnrctl start"
    user 'oracle'
    group 'oinstall'
    environment (node[:rac][:rdbms][:env])
  end
 
