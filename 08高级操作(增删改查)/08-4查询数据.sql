1.完整的查询指令
    select select选项 字段列表 from 数据源 where 条件 group by 分组 having 条件 order by 排序 limit 限制;

        select distinct class,sex,count(*) from students1 where score > 60 and age < 100
        group by class,sex having count(*) > 1 order by class desc,sex asc limit 3;
        +-------+--------+----------+
        | class | sex    | count(*) |
        +-------+--------+----------+
        |     8 | female |        2 |
        |     7 | female |        2 |
        |     6 | female |        3 |
        +-------+--------+----------+

    执行顺序:
        from -> where -> group by -> having -> select -> order by -> limit

2 select选项:
    系统改如何对待查询得到的结果
    all:      默认的,全部数据
    distinct: 去除重复的,所有字段都相同

        select all * from simple; = select * from simple;
        32 rows in set (0.05 sec)

        select distinct * from simple;
        5 rows in set (0.03 sec)

    (2)字段列表:有的时候从多张表获取数据那么获取数据的时候,可能出现相同名字的字段
        需要将同名的字段命名成不同字段,别名 alias
        字段名 [as] 别名
        别名有没有引号都可以,但是数据表的别名不能加 '' ,会报错
        select name as '姓名' from simple as aaa;
        select name as 姓名 from simple as aaa;

3 from 数据源
    from是为前面的查询提供数据,数据源只要是一个复合二维表结果的数据源即可.

    (1) 单表数据
        from 表名

    (2) 多表数据
        多张表
        select * from 表1,表2...;
        得到的结果:两张表的记录相乘,字段数拼接
        本质:从第一张表取出一条记录,去拼接第二张表拼接所有记录
        数学上专业叫法:笛卡尔积
        这个操作除了给数据库造成压力没有其他作用,应该尽量避免出现笛卡尔积

        select * from int1,int2;

        +----+-------+----+-------+
        | id | int_1 | id | int_1 |
        +----+-------+----+-------+
        |  1 |     1 |  4 |    46 |
        |  2 |     2 |  4 |    46 |
        |  3 |     4 |  4 |    46 |
        |  4 |    55 |  4 |    46 |
        |  5 |    51 |  4 |    46 |
        |  6 |     3 |  4 |    46 |
        +----+-------+----+-------+

    (3) 动态数据
        from后面跟的数据不是实体表,而是从表中查询出来得到的二维结果
        基本语法: from (select 字段 from 表名) as 别名;

        select * from (select int_1,int_7 from int3) as int_m;
        +-------+-------+
        | int_1 | int_7 |
        +-------+-------+
        |    10 | NULL  |
        |    10 | NULL  |
        |     1 |   001 |
        +-------+-------+

        select * from (select int_1,int_2,int_7 from int3) as int_m;
        +-------+-------+-------+
        | int_1 | int_2 | int_7 |
        +-------+-------+-------+
        |    10 | 10000 | NULL  |
        |    10 | 10000 | NULL  |
        |     1 |     1 |   001 |
        +-------+-------+-------+

4 where
    where字句:从数据表获取数据的时候,然后进行条件筛选
    数据获取原理:针对表对应的磁盘出获取所有记录(一条条),where作用就是在拿到
    一条结果就开始进行判断,判断是否符合条件,如果符合就保存,不符合就舍弃(不放到内存)

    where通过运算符判断

5 group by
    窍门: group by 谁,前面就取谁
    group by 学号 就能选这个人的所有信息了

    分组:根据指定的字段,对数据进行分组,分组的目的是为了统计
    注意:group by 分组后只会保留每组的第一条记录
    语法: group by 字段名

        (1)group by 一般和函数连用
            //函数可以独自使用
            count(): 总数,如果统计的目标是字段,则不统计null字段,如果为count(*)代表统计记录,count(1)结果和count(*)一样,但是count(1)效率更高
            avg():   平均
            sum():   求和
            max():   最大值
            min():   最小值
            group_concat():为了将分组中指定的字段进行合并(字符串拼接)

        (2)测试
            //按班级分组,查询总人数,最高分,最低分,平均分
            select class,count(*),max(score),min(score),avg(score) from students1 group by class;
            +-------+----------+------------+------------+------------+
            | class | count(*) | max(score) | min(score) | avg(score) |
            +-------+----------+------------+------------+------------+
            |     1 |        4 |        100 |         58 | 80.0000    |
            |     2 |        3 |         88 |         55 | 77.0000    |
            |     3 |        5 |         88 |         45 | 65.0000    |
            |     4 |        4 |         85 |         11 | 48.0000    |
            |     5 |        6 |         94 |          0 | 54.6667    |
            |     6 |        4 |         88 |         44 | 67.7500    |
            +-------+----------+------------+------------+------------+

            select class,count(*),group_concat(name),max(score),min(score),avg(score)
            from students1 group by class;
            +-------+----------+-----------------------------------------------+------------+------------+------------+
            | class | count(*) | group_concat(name)                            | max(score) | min(score) | avg(score) |
            +-------+----------+-----------------------------------------------+------------+------------+------------+
            |     1 |        4 | 赵一,李四,吴六,郑七                            |        100 |         58 | 80.0000    |
            |     2 |        3 | 钱二,孙三,周五                                 |         88 |         55 | 77.0000    |
            |     3 |        5 | 王八,冯九,褚十一,韩十五,何二十一                |         88 |         45 | 65.0000    |
            |     4 |        4 | 陈十,卫十二,沈十四,秦十八                       |         85 |         11 | 48.0000    |
            |     5 |        6 | 蒋十三,杨十六,朱十七,尤十九,施二十三,曹二十六    |         94 |          0 | 54.6667    |
            |     6 |        4 | 许二十,吕二十二,张二十四,孔二十五                |         88 |         44 | 67.7500    |
            +-------+----------+-----------------------------------------------+------------+------------+---------------+

        (3) 多分组
            将数据按照某个字段进行分组之后,在进行分组
            group by 字段1,字段2 //先按照字段1分组,再按照字段2分组

            select class,sex,count(*),group_concat(name) from students1 group by class,sex;
            +-------+--------+----------+-------------------------------+
            | class | sex    | count(*) | group_concat(name)            |
            +-------+--------+----------+-------------------------------+
            |     1 | female |        1 | 郑七                          |
            |     1 | male   |        3 | 赵一,李四,吴六                |
            |     2 | female |        2 | 钱二,周五                     |
            |     2 | male   |        1 | 孙三                          |
            |     3 | female |        2 | 褚十一,韩十五                 |
            |     3 | male   |        3 | 王八,冯九,何二十一            |
            |     4 | female |        1 | 陈十                          |
            |     4 | male   |        3 | 卫十二,沈十四,秦十八          |
            |     5 | female |        4 | 蒋十三,朱十七,尤十九,曹二十六 |
            |     5 | male   |        2 | 杨十六,施二十三               |
            |     6 | female |        2 | 吕二十二,张二十四             |
            |     6 | male   |        2 | 许二十,孔二十五               |
            +-------+--------+----------+-------------------------------+

        (4) 分组排序
            就不用 order by了
            mysql中,分组默认有排序功能:按照分组字段进行排序,默认是升序
            基本语法: group by 字段1 [asc | desc],字段2 [asc | desc] //默认asc

            //班级降序,性别升序
            select class,sex,count(*) from students1 group by class desc,sex asc;
            +-------+--------+----------+
            | class | sex    | count(*) |
            +-------+--------+----------+
            |     8 | male   |        1 |
            |     8 | female |        2 |
            |     7 | female |        2 |
            |     6 | male   |        3 |
            |     6 | female |        4 |
            |     5 | male   |        2 |
            |     5 | female |        6 |
            |     4 | male   |        3 |
            |     4 | female |        3 |
            |     3 | male   |        7 |
            |     3 | female |        3 |
            |     2 | male   |        2 |
            |     2 | female |        3 |
            |     1 | male   |        3 |
            |     1 | female |        4 |
            |     1 | futa   |        1 |
            +-------+--------+----------+

        (5) 回溯统计
            当分组进行多分组之后,往上统计的过程中,需要进行层层上报,
            将这种层层上报统计的过程称为回溯统计,每一次分组向上统计
            的过程都会产生一次新的统计数据,而且当前数据对应的分组字段为null.

            分几次类,统计几次

            with rollup
            基本语法: group by 字段 [asc | desc] with rollup;

                select class,count(*) from students1 group by class with rollup;
                +-------+----------+
                | class | count(*) |
                +-------+----------+
                |     1 |        4 |
                |     2 |        3 |
                |     3 |        5 |
                |     4 |        4 |
                |     5 |        6 |
                |     6 |        4 |
                | NULL  |       26 |   rollup 统计总和
                +-------+----------+

                select class,sex,count(*) from students1 group by class,sex with rollup;
                +-------+--------+----------+
                | class | sex    | count(*) |
                +-------+--------+----------+
                |     1 | female |        1 |
                |     1 | male   |        3 |
                |     1 | NULL   |        4 |
                |     2 | female |        2 |
                |     2 | male   |        1 |
                |     2 | NULL   |        3 |
                |     3 | female |        2 |
                |     3 | male   |        3 |
                |     3 | NULL   |        5 |
                |     4 | female |        1 |
                |     4 | male   |        3 |
                |     4 | NULL   |        4 |
                |     5 | female |        4 |
                |     5 | male   |        2 |
                |     5 | NULL   |        6 |
                |     6 | female |        2 |
                |     6 | male   |        2 |
                |     6 | NULL   |        4 |   rollup 统计总和,分几次类,统计几次
                | NULL  | NULL   |       26 |   rollup 统计总和
                +-------+--------+----------+

6 having

    having的本质和where一样,用来筛选数据
    (1)having是在group by之后,可以针对分组数据进行筛选,但是where不行
        (where是从表中取出数据,别名是在数据进入到内存之后才有的)
        where不能使用聚合函数,聚合函数是在group by分组的时候,where已经运行完毕,要用having
        having可以使用聚合函数

    (2)查询班级人数大于等于5人的班级(先分组再筛选)
    select class,count(*) from students1 group by class having count(*) >= 5;
    select class,count(*) as num from students1 group by class having num >= 5;
    +-------+-----+
    | class | num |
    +-------+-----+
    |     3 |   5 |
    |     5 |   6 |
    +-------+-----+


    查询1班总成绩
    select class,sum(score) from students1 group by class having class=1;
    +-------+------------+
    | class | sum(score) |
    +-------+------------+
    |     1 | 588        |
    +-------+------------+


    查询每个班最高分和最低分
    select class,max(score),min(score) from students1 group by class;
    +-------+------------+------------+
    | class | max(score) | min(score) |
    +-------+------------+------------+
    |     1 |        104 |          1 |
    |     2 |         90 |         55 |
    |     3 |        101 |         40 |
    |     4 |         96 |         11 |
    |     5 |        500 |         33 |
    |     6 |         89 |          0 |
    |     7 |        521 |         80 |
    |     8 |        526 |        222 |
    +-------+------------+------------+


    查询最低分大于100分的班的全部学生
    select * from students1 where class in (select class from students1 group by class having min(score) > 100);
    +-----+----------+--------+-----+-------+-------+-------------+-------------+-------------+
    | id  | name     | sex    | age | class | score | create_time | update_time | delete_time |
    +-----+----------+--------+-----+-------+-------+-------------+-------------+-------------+
    | 115 | 凛晨之主 | female |  17 |     8 |   521 | NULL        | NULL        | NULL        |
    | 116 | 猫宫日向 | female |  17 |     8 |   526 | NULL        | NULL        | NULL        |
    | 117 | 通风口   | male   |  14 |     8 |   222 | NULL        | NULL        | NULL        |
    +-----+----------+--------+-----+-------+-------+-------------+-------------+-------------+


    查询没有学全所有课的学生的学号、姓名
    select id,name from score where id in (select id from score group by id having count(课程号) < (select count(课程号) from course));


    查询1990年出生的学生名单
    select 学号 from student where year(出生日期)=1990；


    强调:having在group by之后,group by是在where之后,where的时候表示将数据从磁盘拿到内存,
    where之后的所有操作都是内存操作.

7 order by
    (1)排序:根据校对规则对数据进行排序
        语法: order by 字段 [asc | desc] //asc是默认的

        测试
        select * from students1 order by score;
        +----+----------+---------+-----+-------+-------+
        | id | name     | sex     | age | class | score |
        +----+----------+---------+-----+-------+-------+
        | 19 | 尤十九   | female  |  11 |     5 |     0 |
        | 14 | 沈十四   | male    |  16 |     4 |    11 |
        | 18 | 秦十八   | male    |  17 |     4 |    11 |
        | 13 | 蒋十三   | female  |  13 |     5 |    33 |
        | 20 | 许二十   | male    |  17 |     6 |    44 |
        |  9 | 冯九     | male    |  14 |     3 |    45 |
        +----+----------+---------+-----+-------+-------+

    (2)order by 也可以像group by 一样多字段排序,先按照第一个字段进行排序,再按照第二个字段排序
        语法: order by 字段1 [asc | desc], 字段2 [asc | desc]

        测试
        select * from students1 order by class desc,score desc;
        +----+----------+---------+-----+-------+-------+
        | id | name     | sex     | age | class | score |
        +----+----------+---------+-----+-------+-------+
        | 15 | 韩十五   | female  |  14 |     3 |    49 |
        |  9 | 冯九     | male    |  14 |     3 |    45 |
        |  3 | 孙三     | male    |  16 |     2 |    88 |
        |  5 | 周五     | female  |  15 |     2 |    88 |
        |  2 | 钱二     | female  |  16 |     2 |    55 |
        |  4 | 李四     | male    |  11 |     1 |   100 |
        |  1 | 赵一     | male    |  15 |     1 |    58 |
        +----+----------+---------+-----+-------+-------+

8 limit  在 order by 之后
    限制字句:主要用来限制记录数量获取

    (1)记录数限制:从第一条到指定数量
        limit 数量;
        limit通常在查询的时候如果限定为一条记录的时候,使用的比较多,
        有时候获取多条记录并不能解决业务问题,会增加数据库负担

            测试
            select * from students1 limit 3;
            +----+------+--------+-----+-------+-------+
            | id | name | sex    | age | class | score |
            +----+------+--------+-----+-------+-------+
            |  1 | 赵一 | male   |  15 |     1 |    58 |
            |  2 | 钱二 | female |  16 |     2 |    55 |
            |  3 | 孙三 | male   |  16 |     2 |    88 |
            +----+------+--------+-----+-------+-------+

    (2)分页
        利用limit来限制获取指定区间的数据
        语法 limit offset,length;从offset+1开始,length条
        mysql中记录的数量从开始
        limit 0,2;获取前两条

        注意:后面的length表示获取最多数量,如果数量不够,不会强求

            测试
            select * from students1 limit 0,2;
            +----+------+--------+-----+-------+-------+
            | id | name | sex    | age | class | score |
            +----+------+--------+-----+-------+-------+
            |  1 | 赵一 | male   |  15 |     1 |    58 |
            |  2 | 钱二 | female |  16 |     2 |    55 |
            +----+------+--------+-----+-------+-------+

            select * from students1 limit 2,2;
            +----+------+------+-----+-------+-------+
            | id | name | sex  | age | class | score |
            +----+------+------+-----+-------+-------+
            |  3 | 孙三 | male |  16 |     2 |    88 |
            |  4 | 李四 | male |  11 |     1 |   100 |
            +----+------+------+-----+-------+-------+

    (3)分页查询计算方法
        limit 页码-1)*每页数量,每页数量

            测试
            select * from students1 limit 0,10;
            +----+------+--------+-----+-------+-------+
            | id | name | sex    | age | class | score |
            +----+------+--------+-----+-------+-------+
            |  1 | 赵一 | male   |  15 |     1 |    58 |
            |  2 | 钱二 | female |  16 |     2 |    55 |
            |  3 | 孙三 | male   |  16 |     2 |    88 |
            |  4 | 李四 | male   |  11 |     1 |   100 |
            |  5 | 周五 | female |  15 |     2 |    90 |
            |  6 | 吴六 | male   |  16 |     1 |    75 |
            |  7 | 郑七 | female |  16 |     1 |   100 |
            |  8 | 王八 | male   |  16 |     3 |    88 |
            |  9 | 冯九 | male   |  14 |     3 |    45 |
            | 10 | 陈十 | female |  14 |     4 |    96 |
            +----+------+--------+-----+-------+-------+

            select * from students1 limit 10,10;
            +----+--------+--------+-----+-------+-------+
            | id | name   | sex    | age | class | score |
            +----+--------+--------+-----+-------+-------+
            | 11 | 褚十一 | female |  16 |     3 |    85 |
            | 12 | 卫十二 | male   |  17 |     4 |    85 |
            | 13 | 蒋十三 | female |  13 |     5 |    33 |
            | 14 | 沈十四 | male   |  16 |     4 |    11 |
            | 15 | 韩十五 | female |  14 |     3 |    49 |
            | 16 | 杨十六 | male   |  17 |     5 |    94 |
            | 17 | 朱十七 | female |  19 |     5 |    60 |
            | 18 | 秦十八 | male   |  17 |     4 |    11 |
            | 19 | 尤十九 | female |  11 |     5 | NULL  |
            | 20 | 许二十 | male   |  17 |     6 |    44 |
            +----+--------+--------+-----+-------+-------+
