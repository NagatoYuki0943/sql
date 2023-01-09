1.创建数据表
    (1).普通创建表
        a.之前选择数据库
        create table 表名(
            字段名1 字段类型1 [字段属性1],   //只写一行后面不用 , 否则报错
            字段名2 字段类型2 [字段属性2] comment "描述",
            ...
            )charset utf8mb4;

        create table students6(
            id int not null auto_increment primary key,
            name varchar(50) comment '姓名',
            age int comment '年龄',
            gender enum('male','female','futa') default 'futa' comment '性别'
        )engine=innodb,charset=utf8mb4,comment='学生表';

        b.不用选择数据库
        create table 数据库.数据表(
        )

        create table mb.students6(
            id int not null auto_increment primary key,
            name varchar(50) comment '姓名',
            age int comment '年龄',
            gender enum('male','female','futa') default 'futa' comment '性别'
        )engine=innodb,charset=utf8mb4,comment='学生表';


    (2).表选项,写在)后面,分号前面
        Engine:存储引擎,mysql提供的具体存储数据的方式,默认有一个 innodb(5.5以前默认myisam)
        Charset:字符集,只对自己当前表有效,级别比数据库高
        Collate:校对集

        create table class(
            id int not null auto_increment primary key,
            name varchar(10)
        )charset utf8;

    (3).复制已有的表结构
        create table 新表 like 旧表; 旧表不仅限于这个数据库,使用其他数据库的表直接使用 . 就可以
        create table int4 like int3;

2.显示数据表
    显示所有表
        show tables;
    显示匹配表
        show tables like ""  使用 % 和 _

3.显示创建表语句
    show create table tables;
    查看数据表创建时的语句,此语句看到的结构不是用户当时自己输入的,是系统加工过的

    tips
    MySQL中有多种语句结束符
    ;与\g效果一样,都是字段在上排横着,下面跟对应的数据
    \G 字段在左侧竖着,数据在右侧横着
    show create table int1\G

4.显示表结构
    describe 表名;
    desc     表名;
    show columns from 表名;

