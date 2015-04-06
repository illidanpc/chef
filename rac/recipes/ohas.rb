cookbook_file "/etc/systemd/system/ohas.service" do
  mode '0644'
  source 'ohas'
  notifies :run, 'execute[ohas]',:immediately
end

execute "ohas" do
  command "systemctl daemon-reload && systemctl enable ohas.service && systemctl start ohas.service"
  action :nothing
end


