bash "run_rdbms_installer" do
    cwd "/tmp/database/"
    code "sudo -Eu oracle ./runInstaller -ignorePrereq -silent -force -responseFile /home/oracle/db_install_0324.rsp"
    returns [0, 6]
end

bash "rdbms_root" do
  cwd "/u01/app/oracle/product/11.2.0/db_1/"
  code "./root.sh"
end

