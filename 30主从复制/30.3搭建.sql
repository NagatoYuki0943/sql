1 准备
    (PDF)

    准备好两台服务器之后，在上述的两台服务器中分别安装好MySQL，并完成基础的初始化准备(安装、密码配置等操作)工作。 其中：
    192.168.200.200 作为主服务器master
    192.168.200.201 作为从服务器slave


2 主库配置
    1. 修改配置文件 /etc/my.cnf
        #mysql 服务ID，保证整个集群环境中唯一，取值范围：1 – 232-1，默认为1
        server-id=1
        #是否只读,1 代表只读, 0 代表读写
        read-only=0
        #忽略的数据, 指不需要同步的数据库
        #binlog-ignore-db=mysql
        #指定同步的数据库
        #binlog-do-db=db01

    2. 重启MySQL服务器
        systemctl restart mysqld

    3. 登录mysql，创建远程连接的账号，并授予主从复制权限
        #创建itcast用户，并设置密码，该用户可在任意主机连接该MySQL服务
        CREATE USER 'itcast'@'%' IDENTIFIED WITH mysql_native_password BY 'Root@123456';
        #为 'itcast'@'%' 用户分配主从复制权限
        GRANT REPLICATION SLAVE ON *.* TO 'itcast'@'%';

    4. 通过指令，查看二进制日志坐标
        show master status ;

        字段含义说明：
            file : 从哪个日志文件开始推送日志文件
            position ： 从哪个位置开始推送日志
            binlog_ignore_db : 指定不需要同步的数据库


3 从库配置
    1. 修改配置文件 /etc/my.cnf
        #mysql 服务ID，保证整个集群环境中唯一，取值范围：1 – 2^32-1，和主库不一样即可
        server-id=2
        #是否只读,1 代表只读, 0 代表读写
        read-only=1

    2. 重新启动MySQL服务
        systemctl restart mysqld

    3. 登录mysql，设置主库配置
        CHANGE REPLICATION SOURCE TO SOURCE_HOST='192.168.200.200', SOURCE_USER='itcast',
        SOURCE_PASSWORD='Root@123456', SOURCE_LOG_FILE='binlog.000004',
        SOURCE_LOG_POS=663;

        上述是 8.0.23 中的语法。如果mysql是 8.0.23 之前的版本，执行如下SQL：
        CHANGE MASTER TO MASTER_HOST='192.168.200.200', MASTER_USER='itcast',
        MASTER_PASSWORD='Root@123456', MASTER_LOG_FILE='binlog.000004',
        MASTER_LOG_POS=663;

        参数名           含义               8.0.23之前
        SOURCE_HOST     主库IP地址          MASTER_HOST
        SOURCE_USER     连接主库的用户名     MASTER_USER
        SOURCE_PASSWORD 连接主库的密码       MASTER_PASSWORD
        SOURCE_LOG_FILE binlog日志文件名     MASTER_LOG_FILE
        SOURCE_LOG_POS  binlog日志文件位置   MASTER_LOG_POS

    4. 开启同步操作
        start replica ; #8.0.22之后
        start slave ;   #8.0.22之前

    5. 查看主从同步状态
        show replica status ; #8.0.22之后
        show slave status ; #8.0.22之前


4 测试
    1. 在主库 192.168.200.200 上创建数据库、表，并插入数据
        create database db01;
            use db01;
            create table tb_user(
            id int(11) primary key not null auto_increment,
            name varchar(50) not null,
            sex varchar(1)
        )engine=innodb default charset=utf8mb4;
        insert into tb_user(id,name,sex) values(null,'Tom', '1'),(null,'Trigger','0'),(null,'Dawn','1');

    2. 在从库 192.168.200.201 中查询数据，验证主从是否同步


