先查看当前的休眠时间
    show global variables like 'wait_timeout';
    +---------------+-------+
    | Variable_name | Value |
    +---------------+-------+
    | wait_timeout  | 120   |
    +---------------+-------+

    show session variables like 'wait_timeout';
    +---------------+-------+
    | Variable_name | Value |
    +---------------+-------+
    | wait_timeout  | 120   |
    +---------------+-------+


设置 MySQL 数据库的休眠时间
    mysql> set global wait_timeout = 28800;
    mysql> set session wait_timeout = 28800;

    mysql> show session variables like 'wait_timeout';
    +---------------+-------+
    | Variable_name | Value |
    +---------------+-------+
    | wait_timeout  | 28800 |
    +---------------+-------+

    show session variables like 'wait_timeout';
    +---------------+-------+
    | Variable_name | Value |
    +---------------+-------+
    | wait_timeout  | 28800 |
    +---------------+-------+