
bash "orainstRoot" do
  cwd "#{node[:oracle][:grid][:inventory]}"
  code "./orainstRoot.sh"
end

bash "crs_root" do
  cwd "#{node[:oracle][:grid][:home]}"
  code "./root.sh"
end

