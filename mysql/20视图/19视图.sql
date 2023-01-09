视图是虚拟表(不能有重复字段)

1 创建视图
    视图本质是sql指令(select语句)
    语法:
        create [or replace] view 视图名称[(列名列表)] as select语句 [ with [ cascade | local ] check option ];
        --可以使单表数据,也可以是连接查询,联合查询或者子查询


        测试:
        create view stu1 as select *,row_number() over (partition by class order by score desc) ranks from students1;


2 查看视图结构
    视图本身是虚拟表,所以关于表的一些操作都是用于视图
    show create view 视图名称;
    desc 视图名;

        desc stu1;
        +-------+------------------------------+------+-----+---------+-------+
        | Field | Type                         | Null | Key | Default | Extra |
        +-------+------------------------------+------+-----+---------+-------+
        | id    | int(255)                     | NO   |     | 0       |       |
        | name  | varchar(255)                 | YES  |     | NULL    |       |
        | sex   | enum('male','female','futa') | YES  |     | NULL    |       |
        | age   | int(255)                     | YES  |     | NULL    |       |
        | class | int(255)                     | YES  |     | NULL    |       |
        | score | int(255)                     | YES  |     | NULL    |       |
        | ranks | bigint(21) unsigned          | NO   |     | 0       |       |
        +-------+------------------------------+------+-----+---------+-------+


3 查看视图
    视图是一张虚拟表,可以直接把视图当做"表"操作,视图本身没有数据,是临时执行select语句得到对应的结果,
    视图主要用于用户查询操作
    语法: select 字段列表 from 视图名 ...;

        测试:
        select * from stu1;
        +-----+------------+--------+-----+-------+-------+-------+
        | id  | name       | sex    | age | class | score | ranks |
        +-----+------------+--------+-----+-------+-------+-------+
        |  99 | 爱丽丝     | futa   |  18 |     1 |   104 |     1 |
        |   4 | 李四       | male   |  11 |     1 |   100 |     2 |
        |   7 | 郑七       | female |  16 |     1 |   100 |     3 |
        | 110 | 矢泽妮可   | female |  16 |     1 |   100 |     4 |
        |   6 | 吴六       | male   |  16 |     1 |    75 |     5 |
        |   1 | 赵一       | male   |  15 |     1 |    58 |     6 |
        |  98 | 爱丽       | female |  12 |     1 |    50 |     7 |
        |  97 | m444       | female |  12 |     1 |     1 |     8 |
        | 122 | 喵喵       | male   |  14 |     2 |   100 |     1 |
        | 123 | 喵喵1      | female |  14 |     2 |   100 |     2 |
        |   5 | 周五       | female |  15 |     2 |    90 |     3 |
        |   3 | 孙三       | male   |  16 |     2 |    88 |     4 |
        ...
        |  20 | 许二十     | male   |  17 |     6 |    44 |     6 |
        |  93 | 懒羊羊     | male   |  17 |     6 |     0 |     7 |
        | 114 | 静凛       | female |  17 |     7 |   521 |     1 |
        |  94 | 暖羊羊     | female |  17 |     7 |    80 |     2 |
        | 116 | 猫宫日向   | female |  17 |     8 |   526 |     1 |
        | 115 | 凛晨之主   | female |  17 |     8 |   521 |     2 |
        | 117 | 通风口     | male   |  14 |     8 |   222 |     3 |
        +-----+------------+--------+-----+-------+-------+-------+


4 修改视图
    修改视图对应的查询语句
    语法:
        create or replace view 视图名称[(列名列表)] as select语句 [ with [ cascade | local ] check option]; -- 创建语句
        alter view 视图名 as 新select指令;

        测试:
        alter view stu1 as select id,name,class,score,row_number() over (partition by class order by score desc) ranks from students1;
        select * from stu1;
        +-----+------------+-------+-------+-------+
        | id  | name       | class | score | ranks |
        +-----+------------+-------+-------+-------+
        |  99 | 爱丽丝     |     1 |   104 |     1 |
        |   4 | 李四       |     1 |   100 |     2 |
        |   7 | 郑七       |     1 |   100 |     3 |
        | 110 | 矢泽妮可   |     1 |   100 |     4 |
        |   6 | 吴六       |     1 |    75 |     5 |
        |   1 | 赵一       |     1 |    58 |     6 |
        |  98 | 爱丽       |     1 |    50 |     7 |
        |  97 | m444       |     1 |     1 |     8 |
        | 122 | 喵喵       |     2 |   100 |     1 |
        | 123 | 喵喵1      |     2 |   100 |     2 |
        |   5 | 周五       |     2 |    90 |     3 |
        ...
        | 105 | 辉夜月0    |     6 |    88 |     3 |
        |  25 | 孔二十五   |     6 |    80 |     4 |
        |  22 | 吕二十二   |     6 |    59 |     5 |
        |  20 | 许二十     |     6 |    44 |     6 |
        |  93 | 懒羊羊     |     6 |     0 |     7 |
        | 114 | 静凛       |     7 |   521 |     1 |
        |  94 | 暖羊羊     |     7 |    80 |     2 |
        | 116 | 猫宫日向   |     8 |   526 |     1 |
        | 115 | 凛晨之主   |     8 |   521 |     2 |
        | 117 | 通风口     |     8 |   222 |     3 |
        +-----+------------+-------+-------+-------+


5 删除视图
    语法: drop view [if exists] 视图名;

        drop view stu1;
        Query OK, 0 rows affected (0.79 sec)


6 演示
    上述我们演示了，视图应该如何创建、查询、修改、删除，那么我们能不能通过视图来插入、更新数据呢？ 接下来，做一个测试。

    create view stu2 as select id,name from students1 where id < 10;

    select * from stu1;
    +----+------+
    | id | name |
    +----+------+
    |  1 | 赵一 |
    |  2 | 钱二 |
    |  3 | 孙三 |
    |  4 | 李四 |
    |  5 | 周五 |
    |  6 | 吴六 |
    |  7 | 郑七 |
    |  8 | 王八 |
    |  9 | 冯九 |
    +----+------+

    update stu2 set name='Tom' where id = 6;     --都修改进了原表
    Rows matched: 1  Changed: 1  Warnings: 0

    update stu2 set name='Jerry' where id = 17;
    Rows matched: 1  Changed: 1  Warnings: 0

    select * from stu1;
    +----+------+
    | id | name |
    +----+------+
    |  1 | 赵一 |
    |  2 | 钱二 |
    |  3 | 孙三 |
    |  4 | 李四 |
    |  5 | 周五 |
    |  6 | Tom  |   --修改了
    |  7 | 郑七 |
    |  8 | 王八 |
    |  9 | 冯九 |
    +----+------+

    执行上述的SQL，我们会发现，id为6和17的数据都是可以成功插入的。 但是我们执行查询，查询出来的数据，却没有id为17的记录。

    因为我们在创建视图的时候，指定的条件为 id<=10, id为17的数据，是不符合条件的，所以没有查
    询出来，但是这条数据确实是已经成功的插入到了基表中。
    如果我们定义视图时，如果指定了条件，然后我们在插入、修改、删除数据时，是否可以做到必须满足
    条件才能操作，否则不能够操作呢？ 答案是可以的，这就需要借助于视图的检查选项了。


7 检查选项
    当使用 with [cascade | local] check option 子句创建视图时，MySQL会通过视图检查正在更改的每个行，例如:
    插入，更新，删除，以使其符合视图的定义。 MySQL允许基于另一个视图创建视图，它还会检查依赖视图中的规则以保
    持一致性。为了确定检查的范围，mysql提供了两个选项： cascade 和 local，默认值为 cascade 。

    1). cascade
    级联。  检查自己的条件,还会检查级联的条件
    比如，v2视图是基于v1视图的，如果在v2视图创建的时候指定了检查选项为 cascaded，但是v1视图
    创建时未指定检查选项。 则在执行检查时，不仅会检查v2，还会级联检查v2的关联视图v1。

        create view stu2 as select id,name from students1 where id < 10 with cascaded check option;
            在stu2中修改数据时会检查 id < 10 条件,必须在这个范围内才能修改,否则修改无效
        create view stu3 as select id,name from stu2 where id > 20 with cascaded check option;
            在stu3中修改数据不仅会检查 id > 20 还会检查级联的 id < 10 条件
        create view stu4 as select id,name from stu3 where id < 25;
            在stu4中修改数据不会检查 id < 25 但会检查级联的 id > 20 和 id < 10 条件


    2). local
    本地。
    比如，v2视图是基于v1视图的，如果在v2视图创建的时候指定了检查选项为 local ，但是v1视图创
    建时未指定检查选项。 则在执行检查时，只会检查v2，不会检查v2的关联视图v1

        create view stu2 as select id,name from students1 where id < 10 with lcoal check option;
            在stu2中修改数据时会检查 id < 10 条件,必须在这个范围内才能修改,否则修改无效
        create view stu3 as select id,name from stu2 where id > 20 with lcoal check option;

        create view stu4 as select id,name from stu3 where id < 25;

8 视图的更新
    要使视图可更新，视图中的行与基础表中的行之间必须存在一对一的关系。如果视图包含以下任何一项，则该视图不可更新：
        A. 聚合函数或窗口函数（SUM()、 MIN()、 MAX()、 COUNT()等）
        B. DISTINCT
        C. GROUP BY
        D. HAVING
        E. UNION 或者 UNION ALL

    示例演示:
        create view stu_v_count as select count(*) from students1;
        Query OK, 0 rows affected (0.18 sec)

        上述的视图中，就只有一个单行单列的数据，如果我们对这个视图进行更新或插入的，将会报错。
        insert into stu_v_count values(10);
        1471 - The target table stu_v_count of the INSERT is not insertable-into


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
        create view tb_user_view as select id,name,profession,age,gender,status,createtime from m_tb_user;
        Query OK, 0 rows affected (0.35 sec)

        select * from tb_user_view;
        +----+--------+--------------------+-----+--------+--------+---------------------+
        | id | name   | profession         | age | gender | status | createtime          |
        +----+--------+--------------------+-----+--------+--------+---------------------+
        |  1 | 吕布   | 软件工程           |  23 | 1      | 6      | 2001-02-02 00:00:00 |
        |  2 | 曹操   | 通讯工程           |  33 | 1      | 0      | 2001-03-05 00:00:00 |
        |  3 | 赵云   | 英语               |  34 | 1      | 2      | 2002-03-02 00:00:00 |
        |  4 | 孙悟空 | 工程造价           |  54 | 1      | 0      | 2001-07-02 00:00:00 |
        |  5 | 花木兰 | 软件工程           |  23 | 2      | 1      | 2001-04-22 00:00:00 |
        |  6 | 大乔   | 舞蹈               |  22 | 2      | 0      | 2001-02-07 00:00:00 |
        |  7 | 露娜   | 应用数学           |  24 | 2      | 0      | 2001-02-08 00:00:00 |
        |  8 | 程咬金 | 化工               |  38 | 1      | 5      | 2001-05-23 00:00:00 |
        |  9 | 项羽   | 金属材料           |  43 | 1      | 0      | 2001-09-18 00:00:00 |
        | 10 | 白起   | 机械工程及其自动化 |  27 | 1      | 2      | 2001-08-16 00:00:00 |
        | 11 | 韩信   | 无机非金属材料工程 |  27 | 1      | 0      | 2001-06-12 00:00:00 |
        | 12 | 荆轲   | 会计               |  29 | 1      | 0      | 2001-05-11 00:00:00 |
        | 13 | 兰陵王 | 工程造价           |  44 | 1      | 1      | 2001-04-09 00:00:00 |
        | 14 | 狂铁   | 应用数学           |  43 | 1      | 2      | 2001-04-10 00:00:00 |
        | 15 | 貂蝉   | 软件工程           |  40 | 2      | 3      | 2001-02-12 00:00:00 |
        | 16 | 妲己   | 软件工程           |  31 | 2      | 0      | 2001-01-30 00:00:00 |
        | 17 | 芈月   | 工业经济           |  35 | 2      | 0      | 2000-05-03 00:00:00 |
        | 18 | 嬴政   | 化工               |  38 | 1      | 1      | 2001-08-08 00:00:00 |
        | 19 | 狄仁杰 | 国际贸易           |  30 | 1      | 0      | 2007-03-12 00:00:00 |
        | 20 | 安琪拉 | 城市规划           |  51 | 2      | 0      | 2001-08-15 00:00:00 |
        | 21 | 典韦   | 城市规划           |  52 | 1      | 2      | 2000-04-12 00:00:00 |
        | 22 | 廉颇   | 土木工程           |  19 | 1      | 3      | 2002-07-18 00:00:00 |
        | 23 | 后羿   | 城市园林           |  20 | 1      | 0      | 2002-03-10 00:00:00 |
        | 24 | 姜子牙 | 工程造价           |  29 | 1      | 4      | 2003-05-26 00:00:00 |
        +----+--------+--------------------+-----+--------+--------+---------------------+

    2). 查询每个学生所选修的课程（三张表联查），这个功能在很多的业务中都有使用到，为了简化操
        作，定义一个视图。
        create view tb_stu_course_view as select s.name student_name, s.no student_no, c.name course_name from
        m_student s, m_student_course sc , m_course c where s.id = sc.studentid and sc.courseid = c.id;
        Query OK, 0 rows affected (0.28 sec)

        select * from tb_stu_course_view;
        +--------------+------------+-------------+
        | student_name | student_no | course_name |
        +--------------+------------+-------------+
        | 黛绮丝       | 2000100101 | Java        |
        | 黛绮丝       | 2000100101 | PHP         |
        | 黛绮丝       | 2000100101 | MySQL       |
        | 谢逊         | 2000100102 | PHP         |
        | 谢逊         | 2000100102 | MySQL       |
        | 殷天正       | 2000100103 | Hadoop      |
        +--------------+------------+-------------+
