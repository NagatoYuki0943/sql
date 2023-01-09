删除数据
1.删除数据尽量不要全部删除

2.删除数据可以使用limit来限制具体的删除个数
    delete from int2 limit 3;
    +----+-------+
    | id | int_1 |
    +----+-------+
    |  4 |    46 |  前三条没了
    |  5 |    51 |
    |  6 |     3 |
    |  7 |     3 |
    |  8 |     9 |
    |  9 |    97 |
    | 10 |    66 |
    | 11 |    14 |
    | 12 |    54 |
    | 13 |    85 |
    | 14 |     0 |
    | 15 |     0 |
    | 16 |    99 |
    +----+-------+

3.删除数据可以使用排序和limit来限制
    delete from int2 order by int_1 desc limit 1;
    Query OK, 1 row affected (0.12 sec) 最大的数被删除了

4.delete删除数据无法重置auto_increment

        detele from auto;

        select * from auto;
        Empty set

        insert into auto values(null,'tom','123');

        select * from auto;
        +----+------+------+
        | id | name | pass |
        +----+------+------+
        | 12 | tom  | 123  |
        +----+------+------+
        id从12开始,不是从1开始,期望从1开始

    解决方案:MySQL中有一个能够重置表选项的自增长语法
    truncate 表名; 相当于 drop --> create  先drop再create

    truncate table 表名;        只删除内容          不可恢复  可以重置 auto_increment
    truncate 表名;  和上一行一样

        truncate table auto;

        insert into auto values(null,'tom','123');

        select * from auto;
        +----+------+------+
        | id | name | pass |
        +----+------+------+
        |  1 | tom  | 123  |
        +----+------+------+