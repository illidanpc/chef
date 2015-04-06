
bash "orainstRoot" do
  cwd "#{node[:rac][:grid][:inventory]}"
  code "./orainstRoot.sh"
end

bash "crs_root" do
  cwd "#{node[:rac][:grid][:home]}"
  code "./root.sh"
end

