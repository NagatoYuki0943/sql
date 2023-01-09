1 介绍
        二进制日志（BINLOG）记录了所有的 DDL（数据定义语言）语句和 DML（数据操纵语言）语句，但
        不包括数据查询（SELECT、SHOW）语句。
        作用：①. 灾难时的数据恢复；②. MySQL的主从复制。在MySQL8版本中，默认二进制日志是开启着
        的，涉及到的参数如下：

        show variables like '%log_bin%';
        +---------------------------------+----------------------------------------------------------+
        | Variable_name                   | Value                                                    |
        +---------------------------------+----------------------------------------------------------+
        | log_bin                         | ON                                                       |
        | log_bin_basename                | D:\phpstudy_pro\Extensions\MySQL8.0.12\data\binlog       |
        | log_bin_index                   | D:\phpstudy_pro\Extensions\MySQL8.0.12\data\binlog.index |
        | log_bin_trust_function_creators | OFF                                                      |
        | log_bin_use_v1_row_events       | OFF                                                      |
        | sql_log_bin                     | ON                                                       |
        +---------------------------------+----------------------------------------------------------+

        -- docker mysql1
        show variables like '%log_bin%';
        +---------------------------------+-----------------------------+
        | Variable_name                   | Value                       |
        +---------------------------------+-----------------------------+
        | log_bin                         | ON                          |
        | log_bin_basename                | /var/lib/mysql/binlog       |
        | log_bin_index                   | /var/lib/mysql/binlog.index |
        | log_bin_trust_function_creators | OFF                         |
        | log_bin_use_v1_row_events       | OFF                         |
        | sql_log_bin                     | ON                          |
        +---------------------------------+-----------------------------+

        参数说明：
            log_bin_basename：当前数据库服务器的binlog日志的基础名称(前缀)，具体的binlog文
                              件名需要再该basename的基础上加上编号(编号从000001开始)。
            log_bin_index：   binlog的索引文件，里面记录了当前服务器关联的binlog文件有哪些。


2 格式
    MySQL服务器中提供了多种格式来记录二进制日志，具体格式及特点如下：

    日志格式     含义
    STATEMENT   基于SQL语句的日志记录，记录的是SQL语句，对数据进行修改的SQL都会记录在日志文件中。
    ROW         基于行的日志记录，记录的是每一行的数据变更。（默认）
    MIXED       混合了STATEMENT和ROW两种格式，默认采用STATEMENT，在某些特殊情况下会自动切换为ROW进行记录。

    show variables like '%binlog_format%';
    +---------------+-------+
    | Variable_name | Value |
    +---------------+-------+
    | binlog_format | ROW   |
    +---------------+-------+

    如果我们需要配置二进制日志的格式，只需要在 /etc/my.cnf 中配置 binlog_format 参数即可。


3 查看
    由于日志是以二进制方式存储的，不能直接读取，需要通过二进制日志查询工具 mysqlbinlog 来查看，具体语法：

    mysqlbinlog [ 参数选项 ] logfilename
    参数选项：
        -d 指定数据库名称，只列出指定的数据库相关操作。
        -o 忽略掉日志中的前n行命令。
        -v 将行事件(数据变更)重构为SQL语句
        -vv 将行事件(数据变更)重构为SQL语句，并输出注释信息

    测试:-- docker mysql1
        update students1 set score=score+1;
        Query OK, 2 rows affected (0.03 sec)

        root@25a73727a616:/var/lib/mysql# mysqlbinlog -v binlog.000004
        ...
        ### UPDATE `mb`.`students1`
        ### WHERE
        ###   @1=1
        ###   @2='黄前久美子'
        ###   @3=15
        ###   @4=2
        ###   @5=2
        ###   @6=60
        ### SET
        ###   @1=1
        ###   @2='黄前久美子'
        ###   @3=15
        ###   @4=2
        ###   @5=2
        ###   @6=61
        ### UPDATE `mb`.`students1`
        ### WHERE
        ###   @1=2
        ###   @2='高板奈丽'
        ###   @3=14
        ###   @4=2
        ###   @5=2
        ###   @6=99
        ### SET
        ###   @1=2
        ###   @2='高板奈丽'
        ###   @3=14
        ###   @4=2
        ###   @5=2
        ###   @6=100
        ...;


4 删除
    对于比较繁忙的业务系统，每天生成的binlog数据巨大，如果长时间不清除，将会占用大量磁盘空
    间。可以通过以下几种方式清理日志：

    指令                                                 含义
    reset master                                        删除全部 binlog 日志，删除之后，日志编号，将从 binlog.000001重新开始
    purge master logs to 'binlog.*'                     删除 * 编号之前的所有日志
    purge master logs before 'yyyy-mm-dd hh24:mi:ss'    删除日志为 "yyyy-mm-dd hh24:mi:ss" 之前产生的所有日志

    也可以在mysql的配置文件中配置二进制日志的过期时间，设置了之后，二进制日志过期会自动删除。

    show variables like '%binlog_expire_logs_seconds%';
    +----------------------------+---------+
    | Variable_name              | Value   |
    +----------------------------+---------+
    | binlog_expire_logs_seconds | 2592000 | -- 30 days
    +----------------------------+---------+
