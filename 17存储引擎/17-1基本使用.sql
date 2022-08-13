1 查询当前数据库支持的存储引擎
    show engines;

    +--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
    | Engine             | Support | Comment                                                        | Transactions | XA   | Savepoints |
    +--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
    | MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables      | NO           | NO   | NO         |
    | MRG_MYISAM         | YES     | Collection of identical MyISAM tables                          | NO           | NO   | NO         |
    | CSV                | YES     | CSV storage engine                                             | NO           | NO   | NO         |
    | FEDERATED          | NO      | Federated MySQL storage engine                                 | NULL         | NULL | NULL       |
    | PERFORMANCE_SCHEMA | YES     | Performance Schema                                             | NO           | NO   | NO         |
    | MyISAM             | YES     | MyISAM storage engine                                          | NO           | NO   | NO         |
    | InnoDB             | DEFAULT | Supports transactions, row-level locking, and foreign keys     | YES          | YES  | YES        |
    | BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears) | NO           | NO   | NO         |
    | ARCHIVE            | YES     | Archive storage engine                                         | NO           | NO   | NO         |
    +--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
    9 rows in set (0.05 sec)


2 建表时指定存储引擎
    CREATE TABLE 表名(
        字段1 字段1类型 [ COMMENT 字段1注释 ] ,
        ......
        字段n 字段n类型 [COMMENT 字段n注释 ]
    ) ENGINE = INNODB [ COMMENT 表注释 ] ;


3 示例演示
    查询建表语句 --- 默认存储引擎: InnoDB

    show create table mb_students1;;
