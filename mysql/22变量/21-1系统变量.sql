1 变量
    MySQL本质是一种编程语言,需要很多变量来保存数据
    MySQL中很多的属性控制都是通过MySQL中固有的变量来实现的.

2 系统变量
    系统内部定义的变量,系统变量针对所有用户(MySQL客户端)有效
    查看系统所有变量:
        show [session | global]  variables [like 'pattern']

        show variables;
        547 rows in set (0.52 sec)

        show session variables like 'auto%';
        +--------------------------+-------+
        | Variable_name            | Value |
        +--------------------------+-------+
        | auto_generate_certs      | ON    |
        | auto_increment_increment | 1     |
        | auto_increment_offset    | 1     |
        | autocommit               | ON    |
        | automatic_sp_privileges  | ON    |
        +--------------------------+-------+

        show global variables like 'auto%';
        +--------------------------+-------+
        | Variable_name            | Value |
        +--------------------------+-------+
        | auto_generate_certs      | ON    |
        | auto_increment_increment | 1     |
        | auto_increment_offset    | 1     |
        | autocommit               | ON    |
        | automatic_sp_privileges  | ON    |
        +--------------------------+-------+


3 查询系统变量
    MySQL允许用户使用select查询变量的数据值(系统变量)
    基本语法:
        select @@ [session | global].变量名;

        select @@autocommit;
        +--------------+
        | @@autocommit |
        +--------------+
        |            1 |
        +--------------+


4 修改系统变量
    set [ session | global ] 系统变量名 = 值 ;
    set @@[session | global] 系统变量名 = 值 ;

    分为两种方式
    (1) 局部修改(会话级别),只针对当前自己客户端当次连接有效(如果没有指定SESSION/GLOBAL，默认是SESSION，会话变量。)
        mysql服务重新启动之后，所设置的全局参数会失效，要想不失效，可以在 /etc/my.cnf 中配置。
        set 变量名 = 新值;

            测试:
            set autocommit=0;     --关闭autocommit,只对自己有效,在另一个客户端还是1
            select @@session.autocommit;
            +----------------------+
            | @@session.autocommit |
            +----------------------+
            |                    0 |
            +----------------------+

            select @@global.autocommit;
            +---------------------+
            | @@global.autocommit |
            +---------------------+
            |                   1 |
            +---------------------+


    (2) 全局修改,针对所有客户端,"所有时刻"都有效
        set global 变量名 = 值; || set @@global.变量名 = 值;

            测试:
            set global autocommit=0;
            set @@global.auto_increment_increment = 2
            修改后查看后没发现修改,全局修改只针对新客户端生效,正在连着的无效
            如果想要本次连接对应的变量修改有效,不能使用全局修改,只能使用会话级别修改(set 变量名 = 新值)

        服务器重启后会重置,要修改配置文件才永久生效
