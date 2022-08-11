1 用户权限管理
    在不同的项目中给不同的角色(开发者)不同的操作权限,为了保证数据库数据的安全
    通常:一个用户的密码不会长期不变,所以需要经常性变更数据库密码,确保用户本身安全(MySQL客户端用户)

2 用户管理
    (1) mysql需要客户端进行连接认证才能进行服务器操作:需要用户信息.
        MySQL中所有的用户信息都是保存在mysql数据库下的user表中

        select * from mysql.user
        *************************** 1. row ***************************
                        Host: localhost             主机地址
                        User: root                  用户名
                        Password: *48SF4E354SE1FG   密码
                        *
                        *
                        *

        默认的:在安装mysql的时候,如果不选择创建匿名用户,那么意味着所有的用户只有一个,root超级用户

        在mysql中,对用的用户管理中,是由对应的host和user共同组成主键来区分用户
            user: 代表用户名
            host: 代表本质是允许访问的客户端(ip或主机地址),如果host使用*代表所有的用户(客户端)都可以访问

        desc mysql.user;
        里面全是枚举
        +------------------------+-----------------------------------+------+-----+-----------------------+-------+
        | Field                  | Type                              | Null | Key | Default               | Extra |
        +------------------------+-----------------------------------+------+-----+-----------------------+-------+
        | Host                   | char(60)                          | NO   | PRI |                       |       |
        | User                   | char(32)                          | NO   | PRI |                       |       |
        | Select_priv            | enum('N','Y')                     | NO   |     | N                     |       |
        | Insert_priv            | enum('N','Y')                     | NO   |     | N                     |       |
        | Update_priv            | enum('N','Y')                     | NO   |     | N                     |       |
        | Delete_priv            | enum('N','Y')                     | NO   |     | N                     |       |
        | Create_priv            | enum('N','Y')                     | NO   |     | N                     |       |
        | Drop_priv              | enum('N','Y')                     | NO   |     | N                     |       |
        | Reload_priv            | enum('N','Y')                     | NO   |     | N                     |       |
        | Shutdown_priv          | enum('N','Y')                     | NO   |     | N                     |       |
        | Process_priv           | enum('N','Y')                     | NO   |     | N                     |       |
        *
        *
        *
        +------------------------+-----------------------------------+------+-----+-----------------------+-------+

    (2) 创建用户
        理论上可以采用两种方式创建用户
            a.直接使用root用户在mysql.user表中添加数据
            b.专门创建用户的sql指令
                基本语法:
                    create user '用户名'@'主机名' identified by '密码'

                    创建的用户没有任何权限
                    主机地址:
                        localhost 本地访问
                        '' (空) 或者 '%'(百分号匹配) 任何地方可以访问

                        测试:
                            create user 'user1'@'localhost' identified by '123456';
                            Query OK, 0 rows affected (0.38 sec)
                            在mysql.user表中可以查看新建用户

                        简化版创建用户
                            create user2; //这样也能执行,没有限定客户端ip,没有密码,谁都可以访问

                        检测用户是否可以使用:
                            mysql -uuser1 -p123456
                            mysql: [Warning] Using a password on the command line interface can be insecure.
                            Welcome to the MySQL monitor.  Commands end with ; or \g.
                            Your MySQL connection id is 23
                            Server version: 8.0.12 MySQL Community Server - GPL

                            Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

                            Oracle is a registered trademark of Oracle Corporation and/or its
                            affiliates. Other names may be trademarks of their respective
                            owners.

                            Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    (3) 删除用户
        注意:mysql中user是带着host本身的(具有唯一性)
        基本语法:
            drop user '用户名'@'主机名'
            用户名不用加 ''

                测试:
                    drop user 'user1'@'%';
                    Query OK, 0 rows affected (0.52 sec)

    (4) 修改用户密码
        mysql中提供了多种修改的方式,基本上都必须使用提供的系统函数:password
        需要靠该函数对密码进行加密处理

        a.使用专门的修改密码的指令
            set password for '用户名'@'主机名' = password('新的明文密码');

                测试:
                    set password for 'user1'@'localhost' = password('654321');

        b.修改用户表
            alter user '用户名'@'主机名' identified with mysql_native_password by '新密码'

        c.使用更新语句update来修改表
            update mysql.user set password = password("新的明文密码") where user = '' and host = '';
