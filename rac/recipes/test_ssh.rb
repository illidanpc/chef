  execute 'test_ssh' do
    command "ssh #{node[:rac][:grid][:cluster][:node2][:name]} touch #{node[:rac][:oracle][:home]}/1.test"
  end
 