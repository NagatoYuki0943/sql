1 联合查询是可合并多个相似的选择查询的结果集.等同于讲一个表追加到另一个表,而是实现将两个表的
查询组合到一起 union
    注意:
        (1) 合并到一起是纵向合并,字段数不变,但是多个查询的记录数合并.
        (2) union理论上只要保证字段数一样,不需要每次拿到的数据对应的字段类型一致,
            永远只保留第一个select语句对应的字段名字(不要这样用)
        (3) 两张表选择的字段列数必须一致


2 应用场景
    (1) 将同一张表中不同的结果(需要针对多条查询语句来实现),合并到一起展示数据
        测试:男生年龄升序排序,女生身高年龄排序
        (select * from students1 where sex='male' order by age asc)
        union
        (select * from students1 where sex='female' order by age desc);

    (2) 最常见,在数据量大的情况下,会对表进行分表操作,需要对每张表进行部分数据统计,
        使用联合查询来将数据放到一起
        测试:两个学生表合并显示


3 基本语法
    select 语句
    union [选项]
    select 语句
    union选项 distinct(默认),all


4 order by 的使用
    (1) 在联合查询中,如果要使用 order by,必须使用括号括起来
    (2) order by 要想生效,必须配合limit,而limit后面必须更对应的限制数量(可使用一个对应的值,大于记录数)

        (select * from students1 where sex='male' order by age asc)
        union
        (select * from students1 where sex='female' order by age desc);
        //order by没有生效
        +----+----------+---------+-----+-------+-------+
        | id | name     | sex     | age | class | score |
        +----+----------+---------+-----+-------+-------+
        |  1 | 赵一     | male    |  15 |     1 |    58 |
        |  3 | 孙三     | male    |  16 |     2 |    88 |
        |  4 | 李四     | male    |  11 |     1 |   100 |
        |  6 | 吴六     | male    |  16 |     1 |    75 |
        |  8 | 王八     | male    |  16 |     3 |    88 |
        |  9 | 冯九     | male    |  14 |     3 |    45 |
        | 12 | 卫十二   | male    |  17 |     4 |    85 |
        | 14 | 沈十四   | male    |  16 |     4 |    11 |
        | 16 | 杨十六   | male    |  17 |     5 |    94 |
        | 18 | 秦十八   | male    |  17 |     4 |    11 |
        | 20 | 许二十   | male    |  17 |     6 |    44 |
        | 21 | 何二十一 | male    |  16 |     3 |    58 |
        | 23 | 施二十三 | male    |  14 |     5 |    86 |
        | 25 | 孔二十五 | male    |  14 |     6 |    80 |
        |  2 | 钱二     | female  |  16 |     2 |    55 |
        |  5 | 周五     | female  |  15 |     2 |    88 |
        |  7 | 郑七     | female  |  16 |     1 |    87 |
        | 10 | 陈十     | female  |  14 |     4 |    85 |
        | 11 | 褚十一   | female  |  16 |     3 |    85 |
        | 13 | 蒋十三   | female  |  13 |     5 |    33 |
        | 15 | 韩十五   | female  |  14 |     3 |    49 |
        | 17 | 朱十七   | female  |  19 |     5 |    60 |
        | 19 | 尤十九   | female  |  11 |     5 | NULL  |
        | 22 | 吕二十二 | female  |  15 |     6 |    59 |
        | 24 | 张二十四 | female  |  18 |     6 |    88 |
        | 26 | 曹二十六 | female  |  15 |     5 |    55 |
        +----+----------+---------+-----+-------+-------+

        (select * from students1 where sex='male' order by age asc limit 100)
        union
        (select * from students1 where sex='female' order by age desc limit 100);
        //加了limit可以正常使用了
        +----+----------+---------+-----+-------+-------+
        | id | name     | sex     | age | class | score |
        +----+----------+---------+-----+-------+-------+
        |  4 | 李四     | male    |  11 |     1 |   100 |
        |  9 | 冯九     | male    |  14 |     3 |    45 |
        | 23 | 施二十三 | male    |  14 |     5 |    86 |
        | 25 | 孔二十五 | male    |  14 |     6 |    80 |
        |  1 | 赵一     | male    |  15 |     1 |    58 |
        |  3 | 孙三     | male    |  16 |     2 |    88 |
        |  6 | 吴六     | male    |  16 |     1 |    75 |
        |  8 | 王八     | male    |  16 |     3 |    88 |
        | 14 | 沈十四   | male    |  16 |     4 |    11 |
        | 21 | 何二十一 | male    |  16 |     3 |    58 |
        | 12 | 卫十二   | male    |  17 |     4 |    85 |
        | 16 | 杨十六   | male    |  17 |     5 |    94 |
        | 18 | 秦十八   | male    |  17 |     4 |    11 |
        | 20 | 许二十   | male    |  17 |     6 |    44 |
        | 17 | 朱十七   | female  |  19 |     5 |    60 |
        | 24 | 张二十四 | female  |  18 |     6 |    88 |
        |  2 | 钱二     | female  |  16 |     2 |    55 |
        |  7 | 郑七     | female  |  16 |     1 |    87 |
        | 11 | 褚十一   | female  |  16 |     3 |    85 |
        |  5 | 周五     | female  |  15 |     2 |    88 |
        | 22 | 吕二十二 | female  |  15 |     6 |    59 |
        | 26 | 曹二十六 | female  |  15 |     5 |    55 |
        | 10 | 陈十     | female  |  14 |     4 |    85 |
        | 15 | 韩十五   | female  |  14 |     3 |    49 |
        | 13 | 蒋十三   | female  |  13 |     5 |    33 |
        | 19 | 尤十九   | female  |  11 |     5 | NULL  |
        +----+----------+---------+-----+-------+-------+


    查询各科成绩前两名的记录
    (select  from score where 课程号 = '0001' order by 成绩 desc limit 2)
    union all
    (select * from score where 课程号 = '0002' order by 成绩 desc limit 2)
    union all
    (select * from score where 课程号 = '0003' order by 成绩 desc limit 2)
