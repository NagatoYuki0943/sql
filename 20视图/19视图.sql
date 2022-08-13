视图是虚拟表(不能有重复字段)

1 创建视图
    视图本质是sql指令(select语句)
    语法:
        create [or replace] view 视图名称[(列名列表)] as select语句 [ with [ cascade | local ] check option ];
        --可以使单表数据,也可以是连接查询,联合查询或者子查询


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
    SHOW create view 视图名称;
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


3 查看视图
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
    语法:
        create [or replace] view 视图名称[(列名列表)] as select语句 [ with [ cascade | local ] check option]; -- 创建语句
        alter view 视图名 as 新select指令;

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
    语法: drop view [if exists] 视图名;

        drop view student_v;
        Query OK, 0 rows affected (0.79 sec)


6 演示

    -- 创建视图
    create or replace view stu_v_1 as select id,name from mb_mm_student where id <= 10;

    -- 查询视图
    show create view stu_v_1;
    select * from stu_v_1;
    select * from stu_v_1 where id < 3;

    -- 修改视图
    create or replace view stu_v_1 as select id,name,no from mb_mm_student where id <= 10;
    alter view stu_v_1 as select id,name from student where id <= 10;

    -- 删除视图
    drop view if exists stu_v_1;

    上述我们演示了，视图应该如何创建、查询、修改、删除，那么我们能不能通过视图来插入、更新数据
    呢？ 接下来，做一个测试。

    create or replace view stu_v_1 as select id,name from student where id <= 10 ;

    select * from stu_v_1;
    insert into stu_v_1 values(6,'Tom');
    insert into stu_v_1 values(17,'Tom22')

    执行上述的SQL，我们会发现，id为6和17的数据都是可以成功插入的。 但是我们执行查询，查询出来的数据，却没有id为17的记录。

    因为我们在创建视图的时候，指定的条件为 id<=10, id为17的数据，是不符合条件的，所以没有查
    询出来，但是这条数据确实是已经成功的插入到了基表中。
    如果我们定义视图时，如果指定了条件，然后我们在插入、修改、删除数据时，是否可以做到必须满足
    条件才能操作，否则不能够操作呢？ 答案是可以的，这就需要借助于视图的检查选项了。


7 检查选项
    当使用 with check option 子句创建视图时，MySQL会通过视图检查正在更改的每个行，例如 插
    入，更新，删除，以使其符合视图的定义。 MySQL允许基于另一个视图创建视图，它还会检查依赖视
    图中的规则以保持一致性。为了确定检查的范围，mysql提供了两个选项： cascade 和 local
    ，默认值为 cascade 。

    1). cascade
    级联。
    比如，v2视图是基于v1视图的，如果在v2视图创建的时候指定了检查选项为 cascaded，但是v1视图
    创建时未指定检查选项。 则在执行检查时，不仅会检查v2，还会级联检查v2的关联视图v1。

    2). local
    本地。
    比如，v2视图是基于v1视图的，如果在v2视图创建的时候指定了检查选项为 local ，但是v1视图创
    建时未指定检查选项。 则在执行检查时，只会检查v2，不会检查v2的关联视图v1


8 视图的更新
    要使视图可更新，视图中的行与基础表中的行之间必须存在一对一的关系。如果视图包含以下任何一项，则该视图不可更新：
        A. 聚合函数或窗口函数（SUM()、 MIN()、 MAX()、 COUNT()等）
        B. DISTINCT
        C. GROUP BY
        D. HAVING
        E. UNION 或者 UNION ALL

    示例演示:
        create view stu_v_count as select count(*) from student;
        上述的视图中，就只有一个单行单列的数据，如果我们对这个视图进行更新或插入的，将会报错。
        insert into stu_v_count values(10)


9 视图作用
    1). 简单
        视图不仅可以简化用户对数据的理解，也可以简化他们的操作。那些被经常使用的查询可以被定义为视
        图，从而使得用户不必为以后的操作每次指定全部的条件。
    2). 安全
        数据库可以授权，但不能授权到数据库特定行和特定的列上。通过视图用户只能查询和修改他们所能见
        到的数据
    3). 数据独立
        视图可帮助用户屏蔽真实表结构变化带来的影响。


10 案例
    1). 为了保证数据库表的安全性，开发人员在操作tb_user表时，只能看到的用户的基本字段，屏蔽
        手机号和邮箱两个字段。
        create view tb_user_view as select id,name,profession,age,gender,status,createtime from tb_user;
        select * from tb_user_view;

    2). 查询每个学生所选修的课程（三张表联查），这个功能在很多的业务中都有使用到，为了简化操
        作，定义一个视图。
        create view tb_stu_course_view as select s.name student_name , s.no student_no ,
        c.name course_name from student s, student_course sc , course c where s.id =
        sc.studentid and sc.courseid = c.id;
        select * from tb_stu_course_view;