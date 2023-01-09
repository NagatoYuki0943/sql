主键: primary key 在表中有一个字段,里面的值具有唯一性,不允许为空(自动),一个表可以有多个主键
1 随表创建主键
    系统提供了两种方式
    (1) 直接在在需要当做主键的字段之后,增加primary key属性
        create table pri1(
            username varchar(10) primary key
        )charset utf8;

        +----------+-------------+------+-----+---------+-------+
        | Field    | Type        | Null | Key | Default | Extra |
        +----------+-------------+------+-----+---------+-------+
        | username | varchar(10) | NO   | PRI | NULL    |       |
        +----------+-------------+------+-----+---------+-------+

    (2) 在所有字段之后增加primary key 选项: primary key(字段信息)
        create table pri2(
            username varchar(10),
            primary key(username)
        )charset utf8;

        +----------+-------------+------+-----+---------+-------+
        | Field    | Type        | Null | Key | Default | Extra |
        +----------+-------------+------+-----+---------+-------+
        | username | varchar(10) | NO   | PRI | NULL    |       |
        +----------+-------------+------+-----+---------+-------+

2 表后增加
    alter table 表名 add primary key(id);

        create table pri3(
            username varchar(10)
        )charset utf8;
        alter table pri3 add primary key(username);

3 查看主键
    (1) 查看表结构
        desc pri1;
        +----------+-------------+------+-----+---------+-------+
        | Field    | Type        | Null | Key | Default | Extra |
        +----------+-------------+------+-----+---------+-------+
        | username | varchar(10) | NO   | PRI | NULL    |       |
        +----------+-------------+------+-----+---------+-------+

    (2) 查看一个表的创建语句
     //即使是后期加上去的也能看出来
        show create table pri3;
        | pri3 | CREATE TABLE `pri3` (
        `username` varchar(10) NOT NULL,
        PRIMARY KEY (`username`)
        ) ENGINE=MyISAM DEFAULT CHARSET=utf8 |

4 删除主键
    alter table 表名 drop primary key;
        alter table pri3 drop primary key;
        //依然不能为null
        +----------+-------------+------+-----+---------+-------+
        | Field    | Type        | Null | Key | Default | Extra |
        +----------+-------------+------+-----+---------+-------+
        | username | varchar(10) | NO   |     | NULL    |       |
        +----------+-------------+------+-----+---------+-------+


5 复合主键(相当于一个主键,MySQL只允许一个表一个主键)
    primary key(列名1,列名2)
    对于两个主键来说,有一个值重复是可以的,但是两个不能同时重复

    案例:一张学生选秀表,一个学生可以选多个选修课,一个选修课可以让很多学生来选
    但是一个学生在一个选修课之后只有一个成绩

    create table score(
        student_no char(10),
        course_no char(10),
        score tinyint not null,
        primary key(student_no,course_no)  -- 两个共同为主键
    )charset utf8;
    //这样写也可以
    alter table score add primary key(student_no,course_no);

    //两个主键
    +------------+------------+------+-----+---------+-------+
    | Field      | Type       | Null | Key | Default | Extra |
    +------------+------------+------+-----+---------+-------+
    | student_no | char(10)   | NO   | PRI | NULL    |       |
    | course_no  | char(10)   | NO   | PRI | NULL    |       |
    | score      | tinyint(4) | NO   |     | NULL    |       |
    +------------+------------+------+-----+---------+-------+

    //删除的时候会把两个主键一次都删除
    alter table score drop primary key;

    +------------+------------+------+-----+---------+-------+
    | Field      | Type       | Null | Key | Default | Extra |
    +------------+------------+------+-----+---------+-------+
    | student_no | char(10)   | NO   |     | NULL    |       |
    | course_no  | char(10)   | NO   |     | NULL    |       |
    | score      | tinyint(4) | NO   |     | NULL    |       |
    +------------+------------+------+-----+---------+-------+


6 主键约束
    主键一旦增加,那么对对应的字段有要求
    (1) 不能为空
    (2) 对应数据不能重复

        //对于两个主键来说,有一个值重复是可以的,但是两个不能同时重复
        insert into score values('00000001','course001',100);
        insert into score values('00000002','course001',100);
        insert into score values('00000001','course002',100);


        insert into score values('00000001','course002',50);
        //重复
        Duplicate entry '00000001-course002' for key 'PRIMARY'

7 主键分类
    主键分类采用的是对应的字段的义务意义分类
    业务主键:主键所在的字段,具有业务意义(学生id,课程id)
    逻辑主键:自然增长的整形(应用广泛)


