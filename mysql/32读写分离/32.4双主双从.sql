1 介绍
    一个主机 Master1 用于处理所有写请求，它的从机 Slave1 和另一台主机 Master2 还有它的从
    机 Slave2 负责所有读请求。当 Master1 主机宕机后，Master2 主机负责写请求，Master1 、
    Master2 互为备机。架构图如下:
    (PDF)


2 准备
    我们需要准备5台服务器，具体的服务器及软件安装情况如下：

        编号 IP             预装软件        角色
        1   192.168.200.210 MyCat、MySQL    MyCat中间件服务器
        2   192.168.200.211 MySQL           M1
        3   192.168.200.212 MySQL           S1
        4   192.168.200.213 MySQL           M2
        5   192.168.200.214 MySQL           S2

    关闭以上所有服务器的防火墙：
        systemctl stop firewalld
        systemctl disable firewalld


3 搭建
    1 主库配置
        1). Master1(192.168.200.211)
            (PDF)
            A. 修改配置文件 /etc/my.cnf
                #mysql 服务ID，保证整个集群环境中唯一，取值范围：1 – 2^32-1，默认为1
                server-id=1
                #指定同步的数据库
                binlog-do-db=db01
                binlog-do-db=db02
                binlog-do-db=db03
                # 在作为从数据库的时候，有写入操作也要更新二进制日志文件
                log-slave-updates

            B. 重启MySQL服务器
                systemctl restart mysqld

            C. 创建账户并授权
                #创建itcast用户，并设置密码，该用户可在任意主机连接该MySQL服务
                CREATE USER 'itcast'@'%' IDENTIFIED WITH mysql_native_password BY 'Root@123456';
                #为 'itcast'@'%' 用户分配主从复制权限
                GRANT REPLICATION SLAVE ON *.* TO 'itcast'@'%';

            通过指令，查看两台主库的二进制日志坐标
                show master status;
                (PDF)

        2). Master2(192.168.200.213)
            (PDF)
            A. 修改配置文件 /etc/my.cnf
                #mysql 服务ID，保证整个集群环境中唯一，取值范围：1 – 2^32-1，默认为1
                server-id=3
                #指定同步的数据库
                binlog-do-db=db01
                binlog-do-db=db02
                binlog-do-db=db03
                # 在作为从数据库的时候，有写入操作也要更新二进制日志文件
                log-slave-updates
            B. 重启MySQL服务器
                systemctl restart mysqld
            C. 创建账户并授权
                #创建itcast用户，并设置密码，该用户可在任意主机连接该MySQL服务
                CREATE USER 'itcast'@'%' IDENTIFIED WITH mysql_native_password BY 'Root@123456';
                #为 'itcast'@'%' 用户分配主从复制权限
                GRANT REPLICATION SLAVE ON *.* TO 'itcast'@'%';
            通过指令，查看两台主库的二进制日志坐标
                show master status;

    2 从库配置
        1). Slave1(192.168.200.212)
            (PDF)
            A. 修改配置文件 /etc/my.cnf
                #mysql 服务ID，保证整个集群环境中唯一，取值范围：1 – 232-1，默认为1
                server-id=2
            B. 重新启动MySQL服务器
                systemctl restart mysqld

        2). Slave2(192.168.200.214)
            (PDF)
            A. 修改配置文件 /etc/my.cnf
                #mysql 服务ID，保证整个集群环境中唯一，取值范围：1 – 232-1，默认为1
                server-id=4
            B. 重新启动MySQL服务器
                systemctl restart mysqld

    3 从库关联主库
        1). 两台从库配置关联的主库
            (PDF)
            需要注意slave1对应的是master1，slave2对应的是master2。
            A. 在 slave1(192.168.200.212)上执行
                CHANGE MASTER TO MASTER_HOST='192.168.200.211', MASTER_USER='itcast',
                MASTER_PASSWORD='Root@123456', MASTER_LOG_FILE='binlog.000002',
                MASTER_LOG_POS=663;
            B. 在 slave2(192.168.200.214)上执行
                CHANGE MASTER TO MASTER_HOST='192.168.200.213', MASTER_USER='itcast',
                MASTER_PASSWORD='Root@123456', MASTER_LOG_FILE='binlog.000002',
                MASTER_LOG_POS=663;
            C. 启动两台从库主从复制，查看从库状态
                start slave;
                show slave status \G;
                (PDF)

        2). 两台主库相互复制
            (PDF)
            Master2 复制 Master1，Master1 复制 Master2。
            A. 在 Master1(192.168.200.211)上执行
                CHANGE MASTER TO MASTER_HOST='192.168.200.213', MASTER_USER='itcast',
                MASTER_PASSWORD='Root@123456', MASTER_LOG_FILE='binlog.000002',
                MASTER_LOG_POS=663;
            B. 在 Master2(192.168.200.213)上执行
                CHANGE MASTER TO MASTER_HOST='192.168.200.211', MASTER_USER='itcast',
                MASTER_PASSWORD='Root@123456', MASTER_LOG_FILE='binlog.000002',
                MASTER_LOG_POS=663;
            C. 启动两台从库主从复制，查看从库状态
                start slave;
                show slave status \G;
                (PDF)
            经过上述的三步配置之后，双主双从的复制结构就已经搭建完成了。 接下来，我们可以来测试验证一下。

    4 测试
        分别在两台主库Master1、Master2上执行DDL、DML语句，查看涉及到的数据库服务器的数据同步情况。
        create database db01;
            use db01;
            create table tb_user(
            id int(11) not null primary key ,
            name varchar(50) not null,
            sex varchar(1)
        )engine=innodb default charset=utf8mb4;
        insert into tb_user(id,name,sex) values(1,'Tom','1');
        insert into tb_user(id,name,sex) values(2,'Trigger','0');
        insert into tb_user(id,name,sex) values(3,'Dawn','1');
        insert into tb_user(id,name,sex) values(4,'Jack Ma','1');
        insert into tb_user(id,name,sex) values(5,'Coco','0');
        insert into tb_user(id,name,sex) values(6,'Jerry','1');

        - 在Master1中执行DML、DDL操作，看看数据是否可以同步到另外的三台数据库中。
        - 在Master2中执行DML、DDL操作，看看数据是否可以同步到另外的三台数据库中。

    完成了上述双主双从的结构搭建之后，接下来，我们再来看看如何完成这种双主双从的读写分离。


