cookbook_file "/etc/systemd/system/ohas.service" do
  mode '0644'
  source 'ohas'
end

execute "ohas1" do
  command "systemctl daemon-reload"
end

execute "ohas2" do
  command "systemctl enable ohas.service"
end

execute "ohas3" do
  command "systemctl start ohas.service"
end
