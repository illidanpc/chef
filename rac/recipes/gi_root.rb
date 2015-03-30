
bash "orainstRoot" do
  cwd "/u01/app/oraInventory"
  code "./orainstRoot.sh"
end

bash "crs_root" do
  cwd "/u01/11.2.0/grid"
  code "./root.sh"
end

