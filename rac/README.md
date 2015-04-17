rac Cookbook
============
This Cookbook is currently install the oracle rac multi-nodes on OEL 7.

Requirements
------------
1. set the root and grid trust with known hosts manually 
2. set the sudo without tty
   chmod 777 /etc/sudoers
   vi /etc/sudoers
   #disable tty require
   chmod 440 /etc/sudoers
3. If the chef client is 11.18 , you should set the no_lazy_load due to the recipe will run very long time

    1) Clear the cache (/var/chef/cache/cookbooks/) so cookbook will be redownloaded
    2) Add a line no_lazy_load = true in /etc/chef/client.rb
4. If you meet the ssh environment problem, you can create a file 
   ~/.ssh/config: (locally)
   add line "SendEnv IGNORE_PREADDNODE_CHECKS"
   /etc/ssh/sshd_config (remote)
   add line "AcceptEnv IGNORE_PREADDNODE_CHECKS"
Attributes
----------
  rac:
    deps:
      comp:
        binutils
        compat-libcap1
        compat-libstdc++-33
        gcc
        gcc-c++
        glibc
        glibc-devel
        ksh
        libgcc
        libstdc++
        libstdc++-devel
        libaio
        libaio-devel
        make
        sysstat
        elfutils-libelf-devel
      flag: false
    grid:
      asm:
        au_size:     1
        dg_name:     VOTE_DISK
        disk_string: /dev/asmdisk/*
        flag:        false
        ocr_dg:      /dev/asmdisk/vote_disk_01,/dev/asmdisk/vote_disk_02,/dev/asmdisk/vote_disk_03
        pw:          Covisint123
        sid:         +ASM1
      base:          /u01/app/grid
      cluster:
        eth0_inter: 10.66.0.0
        eth1_inter: 192.168.0.0
        name:       ora-test-scan
        node1:
          fqdn:  racliu1.covisint.com
          name:  racliu1
          pubip: 10.66.2.178
          vip:   racliu1-vip
        node2:
          fqdn:  racliu2.covisint.com
          name:  racliu2
          pubip: 10.66.2.177
          vip:   racliu2-vip
        node3:
          fqdn:  racliu3.covisint.com
          name:  racliu3
          pubip: 10.66.2.176
          vip:   racliu3-vip
      env:
        ORACLE_BASE: /u01/app/grid
        ORACLE_HOME: /u01/11.2.0/grid
        PATH:        /usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/sbin:/u01/app/grid/bin:/u01/11.2.0/grid/OPatch
      gf:
        flag: false
      home:          /u01/11.2.0/grid
      install_files: /sft/p13390677_112040_Linux-x86-64_3of7.zip
      inventory:     /u01/app/oraInventory
      is_installed:  false
      root:
        flag: false
      scan:
        name: ora-test-scan
        port: 1521
      slave:
        flag: false
      udev:
        flag: false
      user:
        pw:       grid
        pw_set:   false
        sup_grps:
          asmadmin: 5000
          asmdba:   5001
          asmoper:  5002
          dba:      202
        uid:      301
    install_dir:  /s01
    install_info:
    kernel:
      flag: false
    oracle:
      base:      /u01/app/oracle
      dbname:    chefming
      home:      /u01/app/oracle/product/11.2.0/db_1
      inventory: /u01/app/oraInventory
      sid:       chefming1
      user:
        gid:      201
        pw:       oracle
        pw_set:   false
        shell:    /bin/ksh
        sup_grps:
          asmdba: 5001
          dba:    202
        uid:      201
    rdbms:
      asmsys_pw:          dba123
      db_create_template: default_template.dbt
      dbbin_version:      11g
      dbconsole:
        emconfig:           true
        notification_email: foo@bar.inet
        outgoing_mail:      mailhost
        sysman_pw:          sysman_pw_goes_here
      dbs:
      dbs_root:           /d01/oradata
      dbsnmp_pw:          dba123
      env:
        ORACLE_BASE: /u01/app/oracle
        ORACLE_HOME: /u01/app/oracle/product/11.2.0/db_1
        PATH:        /usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/sbin:/u01/app/oracle/dba/bin:/u01/app/oracle/product/11.2.0/db_1/bin:/u01/app/oracle/product/11.2.0/db_1/OPatch
      install_files:
        /sft/p13390677_112040_Linux-x86-64_1of7.zip
        /sft/p13390677_112040_Linux-x86-64_2of7.zip
      is_installed:       false
      latest_patch:
        dirname:      16619892
        is_installed: true
        url:          /sft/p13390677_112040_Linux-x86-64.zip
      opatch_update_url:  /sft/p13390677_112040_Linux-x86-64.zip
      response_file_url:  
      sys_pw:             dba123
      system_pw:          dba123
    sid:
      flag: false
    user:
      flag: false



Usage
-----
knife create role rac_primary
"recipe[rac::gi_folders]","recipe[rac::ohas]","recipe[rac::gi_setup]","recipe[rac::gi_root]","recipe[rac::cfg]","recipe[rac::asm]","recipe[rac::oracle_setup]","recipe[rac::dbca]"

knife create role rac_slave
"recipe[rac::slave_folder]","recipe[rac::ohas]","recipe[rac::add_node]"


knife bootstrap 10.66.2.178 -r 'role[rac_primary]' -j '{"rac" : {"grid": {"cluster": {"node1" : {"name" : "racliu1", "fqdn" : "racliu1.covisint.com" , "vip":"racliu1-vip"}}}, "oracle":{"dbname" : "chefming","sid" : "chefming1"}}}' 

knife bootstrap 10.66.2.177 -r 'role[rac_slave]' -j '{"rac" : {"grid": {"cluster": {"node1" : {"name" : "racliu1", "fqdn" : "racliu1.covisint.com" , "vip":"racliu1-vip"},"new_node":{"name" : "racliu2", "fqdn" : "racliu2.covisint.com" , "vip":"racliu2-vip"}}},"oracle":{"dbname":"chefming","sid":"chefming2"}}}' 


Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Illidan Zhu
