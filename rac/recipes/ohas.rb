cookbook_file "/etc/systemd/system/ohas.service" do
  mode '0644'
  source 'ohas'
  notifies :run, 'execute[ohas1]','execute[ohas2]','execute[ohas3]',:immediately
end

execute "ohas1" do
  command "systemctl daemon-reload"
  action :nothing
end

execute "ohas2" do
  command "systemctl enable ohas.service"
  action :nothing
end

execute "ohas3" do
  command "systemctl start ohas.service"
  action :nothing
end
