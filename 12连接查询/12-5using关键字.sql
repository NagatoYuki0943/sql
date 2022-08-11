1 using关键字
    用来在连接查询中用来代替on关键字

2 原理
    (1) 在连接查询时,使用on的地方用using代替
    (2) 使用using关键字的前提是对应的两张表连接的字段是同名(类似自然连接自动匹配)
    (3) 如果使用using关键字,那么对应的同名字段,那么结果中只会保留一个

语法
    表1 [inner,left,right] 表2 using(同名字段列表); //连接字段

    select * from mb_students1 as s1 left join mb_students2 as s2 using(id);
    //id只会出现一次
    +----+----------+---------+-----+-------+-------+--------+---------+------+-------+-------+
    | id | name     | sex     | age | class | score | name   | sex     | age  | class | score |
    +----+----------+---------+-----+-------+-------+--------+---------+------+-------+-------+
    |  1 | 赵一     | male    |  15 |     1 |    58 | 赵一   | male    |   15 |     1 |    58 |
    |  2 | 钱二     | female  |  16 |     2 |    55 | 钱二   | female  |   16 |     2 |    55 |
    |  3 | 孙三     | male    |  16 |     2 |    88 | 孙三   | male    |   16 |     2 |    88 |
    | 88 | 李四     | male    |  11 |     1 |   100 | NULL   | NULL    | NULL | NULL  | NULL  |
    |  5 | 周五     | female  |  15 |     2 |    88 | 周五   | female  |   15 |     2 |    88 |
    |  6 | 吴六     | male    |  16 |     1 |    75 | 吴六   | male    |   16 |     1 |    75 |
    |  7 | 郑七     | female  |  16 |     1 |    87 | 郑七   | female  |   16 |     1 |    87 |
    |  8 | 王八     | male    |  16 |     3 |    88 | 王八   | male    |   16 |     3 |    88 |
    |  9 | 冯九     | male    |  14 |     3 |    45 | 冯九   | male    |   14 |     3 |    45 |
    | 10 | 陈十     | female  |  14 |     4 |    85 | 陈十   | female  |   14 |     4 |    85 |
    | 11 | 褚十一   | female  |  16 |     3 |    85 | 褚十一 | female  |   16 |     3 |    85 |
    | 12 | 卫十二   | male    |  17 |     4 |    85 | NULL   | NULL    | NULL | NULL  | NULL  |
    | 13 | 蒋十三   | female  |  13 |     5 |    33 | 蒋十三 | female  |   13 |     5 |    33 |
    | 14 | 沈十四   | male    |  16 |     4 |    11 | 沈十四 | male    |   16 |     4 |    11 |
    | 15 | 韩十五   | female  |  14 |     3 |    49 | 韩十五 | female  |   14 |     3 |    49 |
    | 16 | 杨十六   | male    |  17 |     5 |    94 | 杨十六 | male    |   17 |     5 |    94 |
    | 17 | 朱十七   | female  |  19 |     5 |    60 | 朱十七 | female  |   19 |     5 |    60 |
    | 18 | 秦十八   | male    |  17 |     4 |    11 | 秦十八 | male    |   17 |     4 |    11 |
    | 19 | 尤十九   | female  |  11 |     5 | NULL  | 尤十九 | female  |   11 |     5 |     0 |
    | 20 | 许二十   | male    |  17 |     6 |    44 | NULL   | NULL    | NULL | NULL  | NULL  |
    | 21 | 何二十一 | male    |  16 |     3 |    58 | NULL   | NULL    | NULL | NULL  | NULL  |
    | 22 | 吕二十二 | female  |  15 |     6 |    59 | NULL   | NULL    | NULL | NULL  | NULL  |
    | 23 | 施二十三 | male    |  14 |     5 |    86 | NULL   | NULL    | NULL | NULL  | NULL  |
    | 24 | 张二十四 | female  |  18 |     6 |    88 | NULL   | NULL    | NULL | NULL  | NULL  |
    | 25 | 孔二十五 | male    |  14 |     6 |    80 | NULL   | NULL    | NULL | NULL  | NULL  |
    | 26 | 曹二十六 | female  |  15 |     5 |    55 | NULL   | NULL    | NULL | NULL  | NULL  |
    +----+----------+---------+-----+-------+-------+--------+---------+------+-------+-------+