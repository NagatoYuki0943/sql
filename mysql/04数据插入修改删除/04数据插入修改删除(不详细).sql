1.插入操作
    insert into 表名 [(列名)] values(多个值),()...;
    后面(values中)对应的值的列表只需要与前面的字段列表相对应即可(不一定与表结构完全一致)

    insert into int4 values(1,"aaa"); //不写字段列表也可以
    insert into int4(id,name) values(2,"bbb");
    insert into int4(name,id) values("bbb",2); //这样可以,前后一致即可
    insert into int4(name) values("bbb");      //不全写也可以

2.删除数据
    delete from 表名 [where];           只删除内容          可以恢复         不会重置 auto_increment
    delete from int2 limit n; //删除n条
    truncate table 表名;        只删除内容          不可恢复  可以重置 auto_increment
    truncate 表名;  和上一行一样

3.更新数据
    update 表名 set 列名1=新值2,列名2=新值2 where...;
    update 表名 set 列名1=新值2,列名2=新值2 where... limit 限制数量;

4.查询操作
    注意:如果查询的列名有空格就必须加引号,不然没法识别

    (1) 查询全部
        select * from 表名;

    (2) 查询指定列
        select id,name from 表名;

    (3) 高级查询
        select sex,age+1 from students1; //年龄+1显示

    (4) 一次查询多个表
        select * from 表1,表2...;
        得到的结果:两张表的记录相乘,字段数拼接
        本质:从第一张表取出一条记录,去拼接第二张表拼接所有记录
        数学上专业叫法:笛卡尔积
        这个操作除了给数据库造成压力没有其他作用,应该尽量避免出现笛卡尔积

        select * from int1,int2;


    (5) group by 分组查询
        可以配合函数使用
        group by 一般和函数连用
        count(): 总数,如果统计的目标是字段,则不统计null字段,如果为count(*)代表统计记录,count(1)结果和count(*)一样,但是count(1)效率更高
        avg():   平均,
        sum():   求和
        max():   最大值
        min():   最小值
        group_concat():为了将分组中指定的字段进行合并(字符串拼接)

        select sex,count(*) from students1 group by sex;
        select class,count(*),max(score),min(score),avg(score) from students1 group by class;

    注意:a.前面输出的不能比group by 多,函数除外
         b.前面显示的内容必须分类

    (6) 回溯统计
            当分组进行多分组之后,往上统计的过程中,需要进行层层上报,
            将这种层层上报统计的过程称为回溯统计,每一次分组向上统计
            的过程都会产生一次新的统计数据,而且当前数据对应的分组字段为null.

            分几次类,统计几次

            with rollup
            基本语法: group by 字段 [asc | desc] with rollup;

            select class,cout(*) from students1 group by class with rollup;
            class count(*)
            1     4
            2     5
            3     4
            null  13  这一行是with rollup的效果

    (7) 排序
        select * from students1 order by score;  默认升序
                                         by score desc; 降序
                                         by score asc;  升序

    (8) where
        select * from students1 where score = 60; mysql中没有 == 号,用 = 就可以
        select * from students1 where score > 59;

    (9) having
        select * from students1 having score > 59; //这一行和上面的where效果相同

    注意:having和where在不分组时效果相同,可互换,但是有了分组就不相同了
         where  先筛选数据在进行数据处理                              
         having 先处理数据再筛选
        where ... group by              where写在 group by 前面
                  group by having ...   having写在group by 后面

    (10) 模糊查询 like _ %
        _ 表示一个字符
        % 表示0或者多个字符
        select * form students1 where name like "李%";

    (11) limit 限制
        select * from students1 limit a,b; 从第a+1条开始,显示b条
        select * from students1 limit b;   从第1条开始,显示b条

        offset 关键字
        select * from students1 a offset b; 从b+1条开始,输出a条

    (12) distinct 不显示重复项
        select distinct age from students1; 只显示单个的age
        select id,distinct age ... //这样写是错误的

    (13) in在where中规定多个值
        select * from students1 where class in(1,2); 显示1班和2班的同学

    (14) [not] between and 在where中规定范围
        select * from students1 where score between 60 and 100; 60~100之间,包括这两个数字
        select * from students1 where score not between 60 and 100; 不在60~100之间

    (15) and  or
        select * from students1 where class in (1,2) and score between 60 and 100;
        select * from students1 where class in (1,2) or score between 60 and 100;
    (16)is / is not
        is是专门判断结果是否为null的运算符
        语法: is null / is not null

            select * from students2 where score is null;
            +----+--------+---------+-----+-------+-------+
            | id | name   | sex     | age | class | score |
            +----+--------+---------+-----+-------+-------+
            | 19 | 尤十九 | female  |  11 |     5 | NULL  |
            +----+--------+---------+-----+-------+-------+

    (17) as别名 as关键字可以省略
        select id as "学号" , name as "姓名" from students1 as 班级表; 最后的表的别名不能加引号
        学号  姓名
        1     张三
        2     李四
        ...

        as可以简化书写
        select s1.id,s1.name,s2.id,s2.name from students1 as s1 inner join students2 as s2 on s1.id=s2.id;

    (18) concat concat_ws 连接前后
        select id,concat(name,',',sex,',',age) as "基本信息" from students1 ;
                        (name,',',sex,',',age) ','的作用是在下面输入的时候当做分隔符
        select id,concat_ws(':',name,sex,age) as "基本信息" from students1 ;
                           (':',name,sex,age)  ':' 就是下面输入的分隔符

    (19)union unionall 联合两个表显示
        union不会显示重复的
        unionall会全部显示
        select id,name from students1 union select id ,name from students2;
        select id,name from students1 union all select id ,name from students2;  //后面的id,name顺序可以互换,但是不建议

    (20) inner join 两个表的交集
         left join  左边全显示,右边没有的显示null
         right join 右边全显示,左边没有的显示null
         select s1.id,s1.name,s2.id,s2.name from students1 as s1 inner join students2 as s2 on s1.id=s2.id;
         select s1.id,s1.name,s2.id,s2.name from students1 as s1 left join students2 as s2 on s1.id=s2.id;
         select s1.id,s1.name,s2.id,s2.name from students1 as s1 right join students2 as s2 on s1.id=s2.id;

    (21) ***
        先筛选class<10,在按class,sex分组,再按class大小排列
        select class,sex,count(*) from students1 where class < 10 group by class,sex order by class;