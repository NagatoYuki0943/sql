特定关键字(主要用于列子查询)
1 in
    主查询 where 条件 in (列子查询)

2 any
    任意一个
    =any(列子查询)  条件在查询结果中有任意一个即可,等价于in
    <>any(列子查询) 条件在查询结果中不等于任意一个(只要有不等于的值就为真)

    1 = any(1,2,3)===true
    1 <>any(1,2,3)===true  1<>2 1<>3 所以为真

3 some
    与any完全一样
    在国外:some和any的正面含义一致,但是否定大不相同
    not any : 一点也不,not all
    not some: 有一些不
    开发者为了让对应的使用者不要在语法上太纠结,就重新设计了some

4 all
    全部
    =all (列子全部) 等于里面所有
    <>all (列子查询) 不等于里面所有

5 测试
    in
    select * from mb_students1 where id in (select id from mb_students2 where sex="female") order by id;
    +----+--------+---------+-----+-------+-------+
    | id | name   | sex     | age | class | score |
    +----+--------+---------+-----+-------+-------+
    |  2 | 钱二   | female  |  16 |     2 |    55 |
    |  5 | 周五   | female  |  15 |     2 |    88 |
    |  7 | 郑七   | female  |  16 |     1 |    87 |
    | 10 | 陈十   | female  |  14 |     4 |    85 |
    | 11 | 褚十一 | female  |  16 |     3 |    85 |
    | 13 | 蒋十三 | female  |  13 |     5 |    33 |
    | 15 | 韩十五 | female  |  14 |     3 |    49 |
    | 17 | 朱十七 | female  |  19 |     5 |    60 |
    | 19 | 尤十九 | female  |  11 |     5 | NULL  |
    +----+--------+---------+-----+-------+-------+
    9 rows in set (0.08 sec)

    //any
    //在正面情况和上面一样
    select * from mb_students1 where id =any (select id from mb_students2 where sex="female") order by id;
    +----+--------+---------+-----+-------+-------+
    | id | name   | sex     | age | class | score |
    +----+--------+---------+-----+-------+-------+
    |  2 | 钱二   | female  |  16 |     2 |    55 |
    |  5 | 周五   | female  |  15 |     2 |    88 |
    |  7 | 郑七   | female  |  16 |     1 |    87 |
    | 10 | 陈十   | female  |  14 |     4 |    85 |
    | 11 | 褚十一 | female  |  16 |     3 |    85 |
    | 13 | 蒋十三 | female  |  13 |     5 |    33 |
    | 15 | 韩十五 | female  |  14 |     3 |    49 |
    | 17 | 朱十七 | female  |  19 |     5 |    60 |
    | 19 | 尤十九 | female  |  11 |     5 | NULL  |
    +----+--------+---------+-----+-------+-------+
    9 rows in set (0.08 sec)

    any
    // <> 取反
    select * from mb_students1 where id <>any (select id from mb_students2 where sex="female") order by id;
    //全部都出来了,因为里面只要有不等于的值就可以
    +----+----------+---------+-----+-------+-------+
    | id | name     | sex     | age | class | score |
    +----+----------+---------+-----+-------+-------+
    |  1 | 赵一     | male    |  15 |     1 |    58 |
    |  2 | 钱二     | female  |  16 |     2 |    55 |
    |  3 | 孙三     | male    |  16 |     2 |    88 |
    |  5 | 周五     | female  |  15 |     2 |    88 |
    |  6 | 吴六     | male    |  16 |     1 |    75 |
    |  7 | 郑七     | female  |  16 |     1 |    87 |
    |  8 | 王八     | male    |  16 |     3 |    88 |
    |  9 | 冯九     | male    |  14 |     3 |    45 |
    | 10 | 陈十     | female  |  14 |     4 |    85 |
    | 11 | 褚十一   | female  |  16 |     3 |    85 |
    | 12 | 卫十二   | male    |  17 |     4 |    85 |
    | 13 | 蒋十三   | female  |  13 |     5 |    33 |
    | 14 | 沈十四   | male    |  16 |     4 |    11 |
    | 15 | 韩十五   | female  |  14 |     3 |    49 |
    | 16 | 杨十六   | male    |  17 |     5 |    94 |
    | 17 | 朱十七   | female  |  19 |     5 |    60 |
    | 18 | 秦十八   | male    |  17 |     4 |    11 |
    | 19 | 尤十九   | female  |  11 |     5 | NULL  |
    | 20 | 许二十   | male    |  17 |     6 |    44 |
    | 21 | 何二十一 | male    |  16 |     3 |    58 |
    | 22 | 吕二十二 | female  |  15 |     6 |    59 |
    | 23 | 施二十三 | male    |  14 |     5 |    86 |
    | 24 | 张二十四 | female  |  18 |     6 |    88 |
    | 25 | 孔二十五 | male    |  14 |     6 |    80 |
    | 26 | 曹二十六 | female  |  15 |     5 |    55 |
    | 88 | 李四     | male    |  11 |     1 |   100 |
    +----+----------+---------+-----+-------+-------+
    26 rows in set (0.12 sec)

    //==all 等于全部
    select * from mb_students1 where id =all (select id from mb_students2 where sex="female") order by id;
    Empty set

    //<>all 不等于全部
    select * from mb_students1 where id <>all (select id from mb_students2 where sex="female") order by id;
    +----+----------+--------+-----+-------+-------+
    | id | name     | sex    | age | class | score |
    +----+----------+--------+-----+-------+-------+
    |  1 | 赵一     | male   |  15 |     1 |    58 |
    |  3 | 孙三     | male   |  16 |     2 |    88 |
    |  6 | 吴六     | male   |  16 |     1 |    75 |
    |  8 | 王八     | male   |  16 |     3 |    88 |
    |  9 | 冯九     | male   |  14 |     3 |    45 |
    | 12 | 卫十二   | male   |  17 |     4 |    85 |
    | 14 | 沈十四   | male   |  16 |     4 |    11 |
    | 16 | 杨十六   | male   |  17 |     5 |    94 |
    | 18 | 秦十八   | male   |  17 |     4 |    11 |
    | 20 | 许二十   | male   |  17 |     6 |    44 |
    | 21 | 何二十一 | male   |  16 |     3 |    58 |
    | 22 | 吕二十二 | female |  15 |     6 |    59 |
    | 23 | 施二十三 | male   |  14 |     5 |    86 |
    | 24 | 张二十四 | female |  18 |     6 |    88 |
    | 25 | 孔二十五 | male   |  14 |     6 |    80 |
    | 26 | 曹二十六 | female |  15 |     5 |    55 |
    | 88 | 李四     | male   |  11 |     1 |   100 |
    +----+----------+--------+-----+-------+-------+
    17 rows in set (0.10 sec)

6 注意:如果查询的结果有null,不参与匹配