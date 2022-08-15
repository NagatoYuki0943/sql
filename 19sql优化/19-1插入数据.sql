1 insert
    如果我们需要一次性往数据库表中插入多条记录，可以从以下三个方面进行优化

        insert into tb_test values(1,'tom');
        insert into tb_test values(2,'cat');
        insert into tb_test values(3,'jerry');
        .....

    1). 优化方案一
        批量插入数据
        Insert into tb_test values(1,'Tom'),(2,'Cat'),(3,'Jerry');

    2). 优化方案二
        手动控制事务

        start transaction;
        insert into tb_test values(1,'Tom'),(2,'Cat'),(3,'Jerry');
        insert into tb_test values(4,'Tom'),(5,'Cat'),(6,'Jerry');
        insert into tb_test values(7,'Tom'),(8,'Cat'),(9,'Jerry');
        commit;

    3). 优化方案三
        主键顺序插入，性能要高于乱序插入。
    主键乱序插入 : 8 1 9 21 88 2 4 15 89 5 7 3
    主键顺序插入 : 1 2 3 4 5 7 8 9 15 21 88 89


2 大批量插入数据
    如果一次性需要插入大批量数据(比如: 几百万的记录)，使用insert语句插入性能较低，此时可以使
    用MySQL数据库提供的load指令进行插入。操作如下：

    可以执行如下指令，将数据脚本文件中的数据加载到表结构中：

        -- 客户端连接服务端时，加上参数 -–local-infile
        mysql –-local-infile -u root -p

        -- 设置全局参数local_infile为1，开启从本地加载文件导入数据的开关
        set global local_infile = 1;

        -- 执行load指令将准备好的数据，加载到表结构中
        load data local infile '/root/sql1.log' into table tb_user fields
        terminated by ',' lines terminated by '\n' ;

    主键顺序插入性能高于乱序插入

    示例演示:
        A. 创建表结构
            CREATE TABLE m_tb_user1 (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `username` VARCHAR(50) NOT NULL,
                `password` VARCHAR(50) NOT NULL,
                `name` VARCHAR(20) NOT NULL,
                `birthday` DATE DEFAULT NULL,
                `sex` CHAR(1) DEFAULT NULL,
                PRIMARY KEY (`id`),
                UNIQUE KEY `unique_user_username` (`username`)
            ) ENGINE=INNODB DEFAULT CHARSET=utf8 ;

        B. 设置参数
            -- 客户端连接服务端时，加上参数 -–local-infile
            mysql –-local-infile -u root -p

            -- 设置全局参数local_infile为1，开启从本地加载文件导入数据的开关
            set global @@local_infile = 1;

        C. load加载数据                                                                             --按照 , 分隔字符       按照 换行 分隔行
            load data local infile './load_user_100w_sort.sql' into table m_tb_user1 fields terminated by ',' lines terminated by '\n' ;

        我们看到，插入100w的记录，17s就完成了，性能很好。

    在load时，主键顺序插入性能高于乱序插入

