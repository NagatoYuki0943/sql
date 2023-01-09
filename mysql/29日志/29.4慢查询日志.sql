1 慢查询日志
    慢查询日志记录了所有执行时间超过参数 long_query_time 设置值并且扫描记录数不小于
    min_examined_row_limit 的所有的SQL语句的日志，默认未开启。long_query_time 默认为
    10 秒，最小为 0， 精度可以到微秒。
    如果需要开启慢查询日志，需要在MySQL的配置文件 /etc/my.cnf 中配置如下参数：

        #慢查询日志
        slow_query_log=1
        #执行时间参数
        long_query_time=2

    默认情况下，不会记录管理语句，也不会记录不使用索引进行查找的查询。可以使用
    log_slow_admin_statements和 更改此行为 log_queries_not_using_indexes，如下所述。

        #记录执行较慢的管理语句
        log_slow_admin_statements =1
        #记录执行较慢的未使用索引的语句
        log_queries_not_using_indexes = 1

    上述所有的参数配置完成之后，都需要重新启动MySQL服务器才可以生效。
