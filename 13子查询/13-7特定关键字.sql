特定关键字(主要用于列子查询)
1 in/not in
    主查询 where 条件 in (列子查询)

        select * from mb_students1 where class in (select class from mb_students1 where score > 200);
        +-----+----------+--------+-----+-------+-------+
        | id  | name     | sex    | age | class | score |
        +-----+----------+--------+-----+-------+-------+
        |  13 | 蒋十三   | female |  13 |     5 |    33 |
        |  16 | 杨十六   | male   |  17 |     5 |    94 |
        |  17 | 朱十七   | female |  19 |     5 |    60 |
        |  19 | 尤十九   | female |  11 |     5 | NULL  |
        |  23 | 施二十三 | male   |  14 |     5 |    86 |
        |  26 | 曹二十六 | female |  15 |     5 |    55 |
        |  94 | 暖羊羊   | female |  17 |     7 |    80 |
        | 107 | 辉夜月1  | female |  15 |     5 |    88 |
        | 113 | 高板奈利 | female |  15 |     5 |   500 |
        | 114 | 静凛     | female |  17 |     7 |   521 |
        | 115 | 凛晨之主 | female |  17 |     8 |   521 |
        | 116 | 猫宫日向 | female |  17 |     8 |   526 |
        | 117 | 通风口   | male   |  14 |     8 |   222 |
        +-----+----------+--------+-----+-------+-------+
        13 rows in set (0.10 sec)


2 all
    全部
    =all (列子全部) 等于里面所有
    <>all (列子查询) 不等于里面所有

        --all
        --找到比一班中所有人分数都高的人,相当于比一班中最高的分还要高
        select id,name,class,score from mb_students1 where score > all(select score from mb_students1 where class=1);
        +-----+----------+-------+-------+
        | id  | name     | class | score |
        +-----+----------+-------+-------+
        | 113 | 高板奈利 |     5 |   500 |
        | 114 | 静凛     |     7 |   521 |
        | 115 | 凛晨之主 |     8 |   521 |
        | 116 | 猫宫日向 |     8 |   526 |
        | 117 | 通风口   |     8 |   222 |
        +-----+----------+-------+-------+
        5 rows in set (0.07 sec)


3 any
    任意一个
    =any(列子查询)  条件在查询结果中有任意一个即可,等价于in
    <>any(列子查询) 条件在查询结果中不等于任意一个(只要有不等于的值就为真)

    1 = any(1,2,3)===true
    1 <>any(1,2,3)===true  1<>2 1<>3 所以为真

        --any
        --找到比一班中任何人分数都高的人,相当于比一班中最低分的人高
        select id,name,class,score from mb_students1 where score > any(select score from mb_students1 where class=1);
        +-----+------------+-------+-------+
        | id  | name       | class | score |
        +-----+------------+-------+-------+
        |   1 | 赵一       |     1 |    58 |
        |   2 | 钱二       |     2 |    55 |
        |   3 | 孙三       |     2 |    88 |
        *
        | 124 | 喵喵2      |     3 |    99 |
        | 125 | 南小鸟     |     4 |   100 |
        +-----+------------+-------+-------+
        46 rows in set (0.13 sec)


4 some
    与any完全一样
    在国外:some和any的正面含义一致,但是否定大不相同
    not any : 一点也不,not all
    not some: 有一些不
    开发者为了让对应的使用者不要在语法上太纠结,就重新设计了some

        --some 正面含义和any相同
        --找到比一班中任何人分数都高的人,相当于比一班中最低分的人高
        select id,name,class,score from mb_students1 where score > some(select score from mb_students1 where class=1);
        +-----+------------+-------+-------+
        | id  | name       | class | score |
        +-----+------------+-------+-------+
        |   1 | 赵一       |     1 |    58 |
        |   2 | 钱二       |     2 |    55 |
        |   3 | 孙三       |     2 |    88 |
        *
        | 124 | 喵喵2      |     3 |    99 |
        | 125 | 南小鸟     |     4 |   100 |
        +-----+------------+-------+-------+
        46 rows in set (0.12 sec)



6 注意:如果查询的结果有null,不参与匹配