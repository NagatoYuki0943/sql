更新数据
1.在更新数据的时候通常一定跟随条件更新
    update 表名 set 字段名=新值,[字段名1=新值] where 判断条件

2.如果没有条件,是全表更新,可以使用limit来限制更新的数量
    update 表名 set 字段名 = 新值 where 判断条件 limit 限制数量;

    (1) simple有32条数据
    select * from simple;
    +------+
    | name |
    +------+
    | a    |
    | b    |
    | c    |
    | d    |
    | a    |
    | b    |
    | c    |
    | d    |
    | a    |
    | b    |
    | c    |
    | d    |
    | a    |
    | b    |
    | c    |
    | d    |
    | a    |
    | b    |
    | c    |
    | d    |
    | a    |
    | b    |
    | c    |
    | d    |
    | a    |
    | b    |
    | c    |
    | d    |
    | a    |
    | b    |
    | c    |
    | d    |
    +------+
    32 rows in set (0.04 sec)

    (2) 改变4个a变成e
    update simple set name='e' where name='a' limit 4; //只更改4条,不然a全部变为e

    +------+
    | name |
    +------+
    | e    |    1
    | b    |
    | c    |
    | d    |
    | e    |    1
    | b    |
    | c    |
    | d    |
    | e    |    1
    | b    |
    | c    |
    | d    |
    | e    |    1
    | b    |
    | c    |
    | d    |
    | a    |    0
    | b    |
    | c    |
    | d    |
    | a    |    0
    | b    |
    | c    |
    | d    |
    | a    |    0
    | b    |
    | c    |
    | d    |
    | a    |    0
    | b    |
    | c    |
    | d    |
    +------+