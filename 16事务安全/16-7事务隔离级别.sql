1 为了解决并发事务所引发的问题，在数据库中引入了事务隔离级别。主要有以下几种：

    √ 代表会出现
    x 代表不会出现
    隔离级别                脏读    不可重复读   幻读
    Read uncommitted         √        √         √
    Read committed           x        √         √
    Repeatable Read(默认)     x       x         √
    Serializable             x        x         x


2 查看事务隔离级别
    SELECT @@TRANSACTION_ISOLATION;


3 设置事务隔离级别
    SET [ SESSION | GLOBAL ] TRANSACTION ISOLATION LEVEL { READ UNCOMMITTED |
    READ COMMITTED | REPEATABLE READ | SERIALIZABLE }

    SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


4 注意：事务隔离级别越高，数据越安全，但是性能越低。
