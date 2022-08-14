1自动增长:auto_increment,当给定某个字段该属性之后,
该列的属性在没有提供确定数据的时候,系统会根据之前已经存在的属性进行自动增加后,填充数据

    通常用语逻辑主键


2.原理
    (1) 系统中有维护一组数据,用来保存当前使用了自动增长属性的字段,
    记住当前对应的数据值,在给定一个指定的步长
    (2) 当用户进行数据插入的时候,如果没有给定值,系统在原始值上再加上步长变成新的数据
    (3) 自动增长的触发:给定的属性字段没有提供值
    (4) 自动增长只适用数值


3 使用
    在字段之后加上 auto_increment

    (1)创建表
        create table auto(
            id int primary key auto_increment,
            name varchar(10) not null comment '用户名',
            pass varchar(50) not null comment '密码'
        )charset utf8;

        +-------+-------------+------+-----+---------+----------------+
        | Field | Type        | Null | Key | Default | Extra          |
        +-------+-------------+------+-----+---------+----------------+
        | id    | int(11)     | NO   | PRI | NULL    | auto_increment |
        | name  | varchar(10) | NO   |     | NULL    |                |
        | pass  | varchar(50) | NO   |     | NULL    |                |
        +-------+-------------+------+-----+---------+----------------+

    (2)插入
        insert into auto values(null,'mike','password');

        第一个默认是1
        +----+------+----------+
        | id | name | pass     |
        +----+------+----------+
        |  1 | mike | password |
        +----+------+----------+


4 自增长修改
    (1) 查看自增长:自增长一旦触发使用之后,会自动在表选项中增加一个选项(一张表最多只能拥有一个自增长)
        show create table auto;
        | auto | CREATE TABLE `auto` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `name` varchar(10) NOT NULL COMMENT '用户名',
        `pass` varchar(50) NOT NULL COMMENT '密码',
        PRIMARY KEY (`id`)
        ) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 |
        最后一行会有 AUTO_INCREMENT=2

    (2) 表选项可以通过修改表结构来实现
        alter table auto AUTO_INCREMENT=10;
        //更改成功 2 --->>> 10
        ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8


5 删除自增长
    删除自增长在字段属性之后不再保留 auto_increment;
    alter table auto modify id int; //不用在增加主键了,不会丢失

    +-------+-------------+------+-----+---------+-------+
    | Field | Type        | Null | Key | Default | Extra |
    +-------+-------------+------+-----+---------+-------+
    | id    | int(11)     | NO   | PRI | NULL    |       |
    | name  | varchar(10) | NO   |     | NULL    |       |
    | pass  | varchar(50) | NO   |     | NULL    |       |
    +-------+-------------+------+-----+---------+-------+


6 初始设置
    在系统中有一组变量用来维护自增长的初始值和步长
    查看自增长初始变量
    show variables like 'auto_increment%';
    +--------------------------+-------+
    | Variable_name            | Value |
    +--------------------------+-------+
    | auto_increment_increment | 1     |  //步长
    | auto_increment_offset    | 1     |  //初始值
    +--------------------------+-------+


7 细节问题
    (1) 一张表只有一个自增长:自增长会上升到表选项中
    (2) 如果数据插入没有触发自增长(给定了数据),那么自增长不会表现
        insert into auto values(3,'tom','pass');
        +----+------+----------+
        | id | name | pass     |
        +----+------+----------+
        |  1 | mike | password |
        |  3 | tom  | pass     |
        +----+------+----------+

        show create table auto;
        ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8
        AUTO_INCREMENT=4 下一次自动为4
        自增长会根据用户设定的值进行初始化(+1)
    (3) 自增长在修改的时候,值可以比较大,但是不能比较小
        AUTO_INCREMENT的值可以调大,不能调小
