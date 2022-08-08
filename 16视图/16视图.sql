视图是虚拟表(不能有重复字段)

1 创建视图
    视图本质是sql指令(select语句)
    语法 create view 视图名字 as select 指令;   //可以使单表数据,也可以是连接查询,联合查询或者子查询

        测试:
        create view student_v as                            //这样有重复字段
        select s1.id,s1.name,s2.id,s2.name from mb_students1 as s1
        left join mb_students2 as s2 on s1.id=s2.id;

        create view student_v as
        select * from mb_students1;
        Query OK, 0 rows affected (0.70 sec)

2 查看视图结构
    视图本身是虚拟表,所以关于表的一些操作都是用于视图
    show tables;
    show create/view 视图名;
    desc 视图名;

        desc student_v;
        +-------+--------------+------+-----+---------+-------+
        | Field | Type         | Null | Key | Default | Extra |
        +-------+--------------+------+-----+---------+-------+
        | id    | int(255)     | NO   |     | 0       |       |
        | name  | varchar(255) | YES  |     | NULL    |       |
        | sex   | varchar(255) | YES  |     | NULL    |       |
        | age   | int(255)     | YES  |     | NULL    |       |
        | class | int(255)     | YES  |     | NULL    |       |
        | score | int(255)     | YES  |     | NULL    |       |
        +-------+--------------+------+-----+---------+-------+
        6 rows in set (0.04 sec)

3 使用视图
    视图是一张虚拟表,可以直接把视图当做"表"操作,视图本身没有数据,是临时执行select语句得到对应的结果,
    视图主要用于用户查询操作
    语法: select 字段列表 from 视图名 ...;

        测试:
        select * from student_v;
        +----+----------+---------+-----+-------+-------+
        | id | name     | sex     | age | class | score |
        +----+----------+---------+-----+-------+-------+
        |  1 | 赵一     | male    |  15 |     1 |    58 |
        |  2 | 钱二     | female  |  16 |     2 |    55 |
        |  3 | 孙三     | male    |  16 |     2 |    88 |
        | 88 | 李四     | male    |  11 |     1 |   100 |
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
        +----+----------+---------+-----+-------+-------+
        26 rows in set (0.09 sec)

4 修改视图
    修改视图对应的查询语句
    语法: alter view 视图名 as 新select指令;

        测试:
        alter view student_v as select id,name from mb_students2;
        Query OK, 0 rows affected (0.75 sec)
        select * from student_v;
        +----+----------+
        | id | name     |
        +----+----------+
        |  1 | 赵一     |
        |  2 | 钱二     |
        |  3 | 孙三     |
        |  4 | 李四     |
        |  5 | 周五     |
        |  6 | 吴六     |
        |  7 | 郑七     |
        |  8 | 王八     |
        |  9 | 冯九     |
        | 10 | 陈十     |
        | 11 | 褚十一   |
        | 13 | 蒋十三   |
        | 14 | 沈十四   |
        | 15 | 韩十五   |
        | 16 | 杨十六   |
        | 17 | 朱十七   |
        | 18 | 秦十八   |
        | 19 | 尤十九   |
        | 30 | 许二十   |
        | 31 | 何二十一 |
        | 32 | 吕二十二 |
        | 33 | 施二十三 |
        | 34 | 张二十四 |
        | 35 | 孔二十五 |
        | 36 | 曹二十六 |
        | 55 | 卫十二   |
        +----+----------+
        26 rows in set (0.09 sec)

5 删除视图
    语法: drop view 视图名;
        drop view student_v;
        Query OK, 0 rows affected (0.79 sec)