1 外键的概念
    如果公共关键字在一个关系中是主关键字,那么这个公共关键字被称为另一个关系的外键.
    由此可见,外键标识了两个关系之间的相关联系.以另一个关系的外键作为主关键字的表
    被称为主表,具有此外键的表被称为主表的从表.外键又称作外关键字.

    foreign key
    一张表(A)有一个字段,保存的值指向另一张表(B)的主键
    B: 主表
    A: 从表


2 增加外键
    注意:外键只能使用 innodb存储引擎,myisam不支持
        ALTER TABLE mb_foreign1 ENGINE=INNODB;

    mysql中提供了两种方式增加外键
        a.再创建表的时候增加外键
            语法:在字段之后增加一条语句
            [constraint `外键名`] 可以自己定义外键名,不给的话系统默认有
            [constraint `外键名`] foreign key(外键字段) references 主表(主键)   ' ` '是反引号,[]代表可写
                测试:
                create table mb_foreign1(
                    id int primary key auto_increment,
                    name varchar(10) not null,
                    -- 关联mb_studnets2
                    class int,
                    -- 增加外键
                    foreign key(class) references mb_students2(class)
                )charset utf8 ENGINE=INNODB;
                    desc mb_foreign1;
                +-------+-------------+------+-----+---------+----------------+
                | Field | Type        | Null | Key | Default | Extra          |
                +-------+-------------+------+-----+---------+----------------+
                | id    | int(11)     | NO   | PRI | NULL    | auto_increment |
                | name  | varchar(10) | NO   |     | NULL    |                |
                | class | int(11)     | YES  | MUL | NULL    |                |
                +-------+-------------+------+-----+---------+----------------+
            MUL 多索引,外键本身是一个索引,外键要求外键字段本身也是一种普通索引

                show create table mb_foreign1;
                | mb_foreign | CREATE TABLE `mb_foreign` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `name` varchar(10) NOT NULL,
                `class` int(11) DEFAULT NULL,
                PRIMARY KEY (`id`),
                KEY `class` (`class`)  //创建外键是自动增加的普通索引
                ) ENGINE=MyISAM DEFAULT CHARSET=utf8 |

        b.在创建表之后增加外键
            alter table 从表 add [constraint `外键名`] foreign key(外键字段) references 主表(主键)

                //测试,将mb_foreign2的class关联到mb_students2的class
                alter table mb_foreign2 add foreign key(class) references mb_students2(class);
                desc mb_foreign2;
                +-------+-------------+------+-----+---------+----------------+
                | Field | Type        | Null | Key | Default | Extra          |
                +-------+-------------+------+-----+---------+----------------+
                | id    | int(11)     | NO   | PRI | NULL    | auto_increment |
                | name  | varchar(10) | NO   |     | NULL    |                |
                | class | int(11)     | YES  | MUL | NULL    |                |
                +-------+-------------+------+-----+---------+----------------+

3 修改&删除外键
    外键不允许修改,只能先删除,后增加
    语法: alter table 从表 drop foreign key '外键名'; //外键名是系统默认的或者自己增加的,反引号可加可不加

            测试:
            alter table mb_foreign2 drop foreign key class;
            desc mb_foreign2;
            +-------+-------------+------+-----+---------+----------------+
            | Field | Type        | Null | Key | Default | Extra          |
            +-------+-------------+------+-----+---------+----------------+
            | id    | int(11)     | NO   | PRI | NULL    | auto_increment |
            | name  | varchar(10) | NO   |     | NULL    |                |
            | class | int(11)     | YES  | MUL | NULL    |                |
            +-------+-------------+------+-----+---------+----------------+
    还有MUL,外键创建会自动增加一层索引,但是外键删除只会删除自己,不会删除普通索引,所以还有MUL
    如果想删除对应的索引:alter table 从表 drop index 索引名字;

            alter table mb_foreign2 drop index class;
            desc mb_foreign2;
            +-------+-------------+------+-----+---------+----------------+
            | Field | Type        | Null | Key | Default | Extra          |
            +-------+-------------+------+-----+---------+----------------+
            | id    | int(11)     | NO   | PRI | NULL    | auto_increment |
            | name  | varchar(10) | NO   |     | NULL    |                |
            | class | int(11)     | YES  |     | NULL    |                |
            +-------+-------------+------+-----+---------+----------------+
            没有MUL了

4 外键的要求
    (1) 外键字段需要保证与关联的主表的字段类型完全一致
    (2) 基本属性也要相同
    (3) 如果是在标后增加外键,对数据还有一定要求(从表数据与主表的关联关系)
    (4) 外键只能使用 innodb存储引擎,myisam不支持

