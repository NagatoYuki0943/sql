1 查询日志
    查询日志中记录了客户端的所有操作语句，而二进制日志不包含查询数据的SQL语句。默认情况下，查询日志是未开启的。
    (DML增删改和DDL如create,drop,alter,DQL查)

    show variables like '%general%';
    +------------------+---------------------------------+
    | Variable_name    | Value                           |
    +------------------+---------------------------------+
    | general_log      | OFF                             |
    | general_log_file | /var/lib/mysql/25a73727a616.log |
    +------------------+---------------------------------+

    如果需要开启查询日志，可以修改MySQL的配置文件 /etc/my.cnf 文件，添加如下内容：

        #该选项用来开启查询日志 ， 可选值 ： 0 或者 1 ； 0 代表关闭， 1 代表开启
        general_log=1
        #设置日志的文件名 ， 如果没有指定， 默认的文件名为 host_name.log
        general_log_file=mysql_query.log

        开启了查询日志之后，在MySQL的数据存放目录，也就是 /var/lib/mysql/ 目录下就会出现
        mysql_query.log 文件。之后所有的客户端的增删改查操作都会记录在该日志文件之中，长时间运
        行后，该日志文件将会非常大。
