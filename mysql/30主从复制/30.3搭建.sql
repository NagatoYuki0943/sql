1 准备
    (PDF)

    准备好两台服务器之后，在上述的两台服务器中分别安装好MySQL，并完成基础的初始化准备(安装、密码配置等操作)工作。 其中：
    192.168.200.200 作为主服务器master
    192.168.200.201 作为从服务器slave

    两个docker
        172.17.0.2  主
            docker run -d --name mysql1 -p 3307:3306 -e MYSQL_ROOT_PASSWORD=root mysql
            docker exec -it mysql1 bash
        172.17.0.3  副
            docker run -d --name mysql2 -p 3308:3306 -e MYSQL_ROOT_PASSWORD=root mysql
            docker exec -it mysql2 bash


2 主库配置
    1. 修改配置文件
        /etc/my.cnf
        docker /etc/mysql/my.cnf
        #mysql 服务ID，保证整个集群环境中唯一，取值范围：1 – 232-1，默认为1
        server-id=1
        #是否只读,1 代表只读, 0 代表读写
        read-only=0
        #忽略的数据, 指不需要同步的数据库
        #binlog-ignore-db=mysql
        #指定同步的数据库
        #binlog-do-db=mb

        show variables like '%server_id%';
        +----------------+-------+
        | Variable_name  | Value |
        +----------------+-------+
        | server_id      | 1     |
        | server_id_bits | 32    |
        +----------------+-------+


    2. 重启MySQL服务器
        systemctl restart mysqld


    3. 登录mysql，创建远程连接的账号，并授予主从复制权限
        #创建itcast用户，并设置密码，该用户可在任意主机连接该MySQL服务
        create user 'itcast'@'%' identified with mysql_native_password by 'Root@123456';    -- Root@123456 是密码
        #为 'itcast'@'%' 用户分配主从复制权限
        grant replication slave on *.* to 'itcast'@'%';
        grant all privileges on *.* to 'itcast'@'%' with grant option;


    4. 通过指令，查看二进制日志坐标
        show master status;
        +---------------+----------+--------------+------------------+-------------------+
        | File          | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
        +---------------+----------+--------------+------------------+-------------------+
        | binlog.000003 |      156 |              |                  |                   |
        +---------------+----------+--------------+------------------+-------------------+

        字段含义说明：
            file : 从哪个日志文件开始推送日志文件
            position ： 从哪个位置开始推送日志
            binlog_ignore_db : 指定不需要同步的数据库


3 从库配置
    1. 修改配置文件
        /etc/my.cnf
        docker /etc/mysql/my.cnf
        #mysql 服务ID，保证整个集群环境中唯一，取值范围：1 – 2^32-1，和主库不一样即可
        server-id=10    #设置为2不管用,就设置为20了
        #是否只读,1 代表只读, 0 代表读写
        read-only=1

        show variables like '%server_id%';
        +----------------+-------+
        | Variable_name  | Value |
        +----------------+-------+
        | server_id      | 10    |
        | server_id_bits | 32    |
        +----------------+-------+


    2. 重新启动MySQL服务
        systemctl restart mysqld


    3. 登录mysql，设置主库配置
        change replication source to source_host='172.17.0.2', source_user='itcast',
        source_password='Root@123456', source_log_file='binlog.000003',
        source_log_pos=156;
        Query OK, 0 rows affected, 2 warnings (0.25 sec)


        上述是 8.0.23 中的语法。如果mysql是 8.0.23 之前的版本，执行如下SQL：
        change master to master_host='172.17.0.2', master_user='itcast',
        master_password='Root@123456', master_log_file='binlog.000003',
        master_log_pos=156;

        参数名           含义               8.0.23之前
        source_host     主库IP地址          MASTER_HOST
        source_user     连接主库的用户名     MASTER_USER
        source_password 连接主库的密码       MASTER_PASSWORD
        source_log_file binlog日志文件名     MASTER_LOG_FILE
        source_log_pos  binlog日志文件位置   MASTER_LOG_POS


    4. 开启同步操作
        start replica;  # 8.0.22之后
        Query OK, 0 rows affected (0.01 sec)

        start slave;    #8.0.22之前


    5. 查看主从同步状态
        show replica status;  #8.0.22之后
        show slave status;    #8.0.22之前


        show replica status \G;
        *************************** 1. row ***************************
                     Replica_IO_State: Waiting for source to send event
                          Source_Host: 172.17.0.2
                          Source_User: itcast
                          Source_Port: 3306
                        Connect_Retry: 60
                      Source_Log_File: binlog.000003
                  Read_Source_Log_Pos: 663
                       Relay_Log_File: 76e6e93bbf12-relay-bin.000002
                        Relay_Log_Pos: 321
                Relay_Source_Log_File: binlog.000003
                   Replica_IO_Running: Yes      -- important
                  Replica_SQL_Running: Yes      -- important
                      Replicate_Do_DB:
                  Replicate_Ignore_DB:
                   Replicate_Do_Table:
               Replicate_Ignore_Table:
              Replicate_Wild_Do_Table:
          Replicate_Wild_Ignore_Table:
                           Last_Errno: 0
                           Last_Error:
                         Skip_Counter: 0
                  Exec_Source_Log_Pos: 663
                      Relay_Log_Space: 537
                      Until_Condition: None
                       Until_Log_File:
                        Until_Log_Pos: 0
                   Source_SSL_Allowed: No
                   Source_SSL_CA_File:
                   Source_SSL_CA_Path:
                      Source_SSL_Cert:
                    Source_SSL_Cipher:
                       Source_SSL_Key:
                Seconds_Behind_Source: 0
        Source_SSL_Verify_Server_Cert: No
                        Last_IO_Errno: 0
                        Last_IO_Error:
                       Last_SQL_Errno: 0
                       Last_SQL_Error:
          Replicate_Ignore_Server_Ids:
                     Source_Server_Id: 1
                          Source_UUID: 8dc0c8ce-252d-11ed-93fb-0242ac110002
                     Source_Info_File: mysql.slave_master_info
                            SQL_Delay: 0
                  SQL_Remaining_Delay: NULL
            Replica_SQL_Running_State: Replica has read all relay log; waiting for more updates
                   Source_Retry_Count: 86400
                          Source_Bind:
              Last_IO_Error_Timestamp:
             Last_SQL_Error_Timestamp:
                       Source_SSL_Crl:
                   Source_SSL_Crlpath:
                   Retrieved_Gtid_Set:
                    Executed_Gtid_Set:
                        Auto_Position: 0
                 Replicate_Rewrite_DB:
                         Channel_Name:
                   Source_TLS_Version:
               Source_public_key_path:
                Get_Source_public_key: 0
                    Network_Namespace:
        1 row in set (0.00 sec)

        ERROR:
        No query specified


4 测试
    1. 在主库 mysql1(172.17.0.2) 上创建数据库、表，并插入数据
        create database mb;
        show databases;
        +--------------------+
        | Database           |
        +--------------------+
        | information_schema |
        | mb                 |
        | mysql              |
        | performance_schema |
        | sys                |
        +--------------------+

        use mb;
        create table tb_user(
            id int(11) primary key not null auto_increment,
            name varchar(50) not null,
            sex varchar(1)
        )engine=innodb default charset=utf8mb4;
        insert into tb_user(id,name,sex) values(null,'Tom', '1'),(null,'Trigger','0'),(null,'Dawn','1');

        select * from tb_user;
        +----+---------+------+
        | id | name    | sex  |
        +----+---------+------+
        |  1 | Tom     | 1    |
        |  2 | Trigger | 0    |
        |  3 | Dawn    | 1    |
        +----+---------+------+


    2. 在从库 mysql2(172.17.0.3) 中查询数据，验证主从是否同步
        show databases;
        +--------------------+
        | Database           |
        +--------------------+
        | information_schema |
        | mb                 |
        | mysql              |
        | performance_schema |
        | sys                |
        +--------------------+

        use mb;
        Database changed
        show tables;
        +----------------+
        | Tables_in_mb |
        +----------------+
        | tb_user        |
        +----------------+

        select * from tb_user;
        +----+---------+------+
        | id | name    | sex  |
        +----+---------+------+
        |  1 | Tom     | 1    |
        |  2 | Trigger | 0    |
        |  3 | Dawn    | 1    |
        +----+---------+------+


    3.重启两台服务器尝试效果
        主库:
            show master status;
            +---------------+----------+--------------+------------------+-------------------+
            | File          | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
            +---------------+----------+--------------+------------------+-------------------+
            | binlog.000004 |      156 |              |                  |                   |
            +---------------+----------+--------------+------------------+-------------------+

        从库:
            show replica status \G;
            *************************** 1. row ***************************
                         Replica_IO_State: Waiting for source to send event
                              Source_Host: 172.17.0.2
                              Source_User: itcast
                              Source_Port: 3306
                            Connect_Retry: 60
                          Source_Log_File: binlog.000004
                      Read_Source_Log_Pos: 156
                           Relay_Log_File: 76e6e93bbf12-relay-bin.000005
                            Relay_Log_Pos: 365
                    Relay_Source_Log_File: binlog.000004
                       Replica_IO_Running: Yes
                      Replica_SQL_Running: Yes
                          Replicate_Do_DB:
                      Replicate_Ignore_DB:
                       Replicate_Do_Table:
                   Replicate_Ignore_Table:
                  Replicate_Wild_Do_Table:
              Replicate_Wild_Ignore_Table:
                               Last_Errno: 0
                               Last_Error:
                             Skip_Counter: 0
                      Exec_Source_Log_Pos: 156
                          Relay_Log_Space: 746
                          Until_Condition: None
                           Until_Log_File:
                            Until_Log_Pos: 0
                       Source_SSL_Allowed: No
                       Source_SSL_CA_File:
                       Source_SSL_CA_Path:
                          Source_SSL_Cert:
                        Source_SSL_Cipher:
                           Source_SSL_Key:
                    Seconds_Behind_Source: 0
            Source_SSL_Verify_Server_Cert: No
                            Last_IO_Errno: 0
                            Last_IO_Error:
                           Last_SQL_Errno: 0
                           Last_SQL_Error:
              Replicate_Ignore_Server_Ids:
                         Source_Server_Id: 1
                              Source_UUID: 8dc0c8ce-252d-11ed-93fb-0242ac110002
                         Source_Info_File: mysql.slave_master_info
                                SQL_Delay: 0
                      SQL_Remaining_Delay: NULL
                Replica_SQL_Running_State: Replica has read all relay log; waiting for more updates
                       Source_Retry_Count: 86400
                              Source_Bind:
                  Last_IO_Error_Timestamp:
                 Last_SQL_Error_Timestamp:
                           Source_SSL_Crl:
                       Source_SSL_Crlpath:
                       Retrieved_Gtid_Set:
                        Executed_Gtid_Set:
                            Auto_Position: 0
                     Replicate_Rewrite_DB:
                             Channel_Name:
                       Source_TLS_Version:
                   Source_public_key_path:
                    Get_Source_public_key: 0
                        Network_Namespace:
            1 row in set (0.00 sec)

            ERROR:
            No query specified

        主库:
            select * from tb_user;
            +----+---------+------+
            | id | name    | sex  |
            +----+---------+------+
            |  1 | Tom     | 1    |
            |  2 | Trigger | 0    |
            |  3 | Dawn    | 1    |
            +----+---------+------+

            insert into tb_user value(null, 'Butt', 0);     -- 主库添加数据

            select * from tb_user;
            +----+---------+------+
            | id | name    | sex  |
            +----+---------+------+
            |  1 | Tom     | 1    |
            |  2 | Trigger | 0    |
            |  3 | Dawn    | 1    |
            |  6 | Butt    | 0    |
            +----+---------+------+

        从库:
            select * from tb_user;
            +----+---------+------+
            | id | name    | sex  |
            +----+---------+------+
            |  1 | Tom     | 1    |
            |  2 | Trigger | 0    |
            |  3 | Dawn    | 1    |
            |  6 | Butt    | 0    |                         -- 右侧也会新添加数据
            +----+---------+------+

        主库:
            show databases;
            +--------------------+
            | Database           |
            +--------------------+
            | information_schema |
            | mb                 |
            | mysql              |
            | performance_schema |
            | sys                |
            +--------------------+

            create database test;

            show databases;
            +--------------------+
            | Database           |
            +--------------------+
            | information_schema |
            | mb                 |
            | mysql              |
            | performance_schema |
            | sys                |
            | test               |
            +--------------------+

        右侧:
            show databases;
            +--------------------+
            | Database           |
            +--------------------+
            | information_schema |
            | mb                 |
            | mysql              |
            | performance_schema |
            | sys                |
            | test               |
            +--------------------+

        左侧:
            use test;
            create table tb_user(
                id int(11) primary key not null auto_increment,
                name varchar(50) not null,
                sex varchar(1)
            )engine=innodb default charset=utf8mb4;
            insert into tb_user(id,name,sex) values(null,'Tom', '1'),(null,'Trigger','0'),(null,'Dawn','1');

            select * from tb_user;
            +----+---------+------+
            | id | name    | sex  |
            +----+---------+------+
            |  1 | Tom     | 1    |
            |  2 | Trigger | 0    |
            |  3 | Dawn    | 1    |
            +----+---------+------+

        右侧:
            use test;
            select * from tb_user;
            +----+---------+------+
            | id | name    | sex  |
            +----+---------+------+
            |  1 | Tom     | 1    |
            |  2 | Trigger | 0    |
            |  3 | Dawn    | 1    |
            +----+---------+------+
