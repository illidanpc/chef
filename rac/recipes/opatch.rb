
#Prepare GI home and RDBMS for patching on all nodes

execute "pre_patch" do
  cwd "/u01/11.2.0/grid/perl/lib/5.10.0"
  command "/u01/11.2.0/grid/crs/install/rootcrs.pl -unlock"
end


#Install latest OPatch version (on both GI Home(as grid user) and RDBMS Home(as oracle user)

execute "unzip_opatch_grid" do
    command "unzip -u /tmp/p6880880_112000_Linux-x86-64.zip"
    user "grid"
    group 'oinstall'
    cwd '/u01/11.2.0/grid'
end

execute "unzip_opatch_oracle" do
    command "unzip -u /tmp/p6880880_112000_Linux-x86-64.zip"
    user "grid"
    group 'oinstall'
    cwd '/u01/app/oracle/product/11.2.0/db_1/'
end


#create a response file for silent install


$ORACLE_HOME/OPatch/ocm/bin/emocmrsp
silent response file location - /tmp/ocm.rsp 

[grid@CHEFVM1 bin]$ ./emocmrsp 
OCM Installation Response Generator 10.3.4.0.0 - Production
Copyright (c) 2005, 2010, Oracle and/or its affiliates.  All rights reserved.

Provide your email address to be informed of security issues, install and
initiate Oracle Configuration Manager. Easier for you if you use your My
Oracle Support Email address/User Name.
Visit http://www.oracle.com/support/policies.html for details.
Email address/User Name: 

You have not provided an email address for notification of security issues.
Do you wish to remain uninformed of security issues ([Y]es, [N]o) [N]:  Y
The OCM configuration response file (ocm.rsp) was successfully created.
[grid@CHEFVM1 bin]$ pwd


#Install GRID Patch

bash "install_grid_patch" do
  cwd "/u01/11.2.0/grid/perl/lib/5.10.0"
  code "sudo -Eu grid /u01/11.2.0/grid/OPatch/opatch napply -silent -ocmrf /tmp/ocm.rsp -oh /u01/11.2.0/grid -local /tmp/gi_patch/19955028"
end



#Install RDBMS Patch (Make sure latest Opatch is installed on oracle home before proceedging)

bash "install_rdbms_patch1" do
  cwd "/u01/11.2.0/grid/perl/lib/5.10.0"
  code "sudo -Eu oracle /tmp/gi_patch/19955028/19769476/custom/server/19769476/custom/scripts/prepatch.sh -dbhome /u01/app/oracle/product/11.2.0/db_1"
end

bash "install_rdbms_patch2" do
  cwd "/u01/11.2.0/grid/perl/lib/5.10.0"
  code "sudo -Eu oracle /u01/app/oracle/product/11.2.0/db_1/OPatch/opatch napply -silent -ocmrf /tmp/ocm.rsp -oh /u01/app/oracle/product/11.2.0/db_1 -local /tmp/gi_patch/19955028/19769489"
end

bash "install_rdbms_patch3" do
  cwd "/u01/11.2.0/grid/perl/lib/5.10.0"
  code "sudo -Eu oracle /tmp/gi_patch/19955028/19769476/custom/server/19769476/custom/scripts/postpatch.sh -dbhome /u01/app/oracle/product/11.2.0/db_1"
end

bash "rootadd" do
  cwd "/u01/11.2.0/grid/perl/lib/5.10.0"
  code "/u01/11.2.0/grid/crs/install/rootadd_rdbms.sh"
end

bash "rootcrs" do
  cwd "/u01/11.2.0/grid/perl/lib/5.10.0"
  code "/u01/11.2.0/grid/crs/install/rootcrs.pl -patch"
end



#Verify that patches are applied
bash "get_grid_version" do
  cwd "/u01/11.2.0/grid/perl/lib/5.10.0"
  code "/u01/11.2.0/grid/OPatch/opatch lsinventory -detail -oh /u01/11.2.0/grid"
end

bash "get_oracle_version" do
  cwd "/u01/11.2.0/grid/perl/lib/5.10.0"
  code "/u01/app/oracle/product/11.2.0/db_1/OPatch/opatch lsinventory -oh /u01/app/oracle/product/11.2.0/db_1"
end

