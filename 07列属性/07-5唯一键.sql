1 唯一键 : unique key 保证对应的字段中的数据是唯一的
主键也可以用来保证字段数据唯一性,但是一张表只有一个主键
    (1) 唯一键可以有多个
    (2) 唯一键允许字段数据位null,null可以有多个(null不参与比较)

2 创建唯一键
    (1) 直接在字段表字段后增加唯一键标识符:unique / unique key
            create table mb_unique1(
                id int primary key auto_increment,
                username varchar(10) unique
            )charset utf8;

    (2) 可以再所有字段之后 unique key(字段列表)
             create table mb_unique2(
                id int primary key auto_increment,
                username varchar(10),
                unique(username) -- key 有没有都可以
            )charset utf8;

    (3) 创建完之后也可以添加
        alter table 表名 add unique(列名);
        alter table 表名 add unique key(列名);
                create table mb_unique3(
                    id int primary key auto_increment,
                    username varchar(10)
                )charset utf8;

            alter table mb_unique3 add unique(username);
            //可以一次添加多个
            alter table mb_unique1 add unique(username,pass);

3 查看唯一键
    唯一键是属性,可以通过查看结构查看 允许为空
    desc mb_unique1;
    | username | varchar(10) | YES  | UNI | NULL    |        |

    在不为空的条件下不允许重复
        insert into mb_unique1 values(null,default);
        insert into mb_unique1 values(null,default);
        insert into mb_unique1 values(null,default);

        +----+----------+
        | id | username |
        +----+----------+
        |  1 | NULL     |
        |  2 | NULL     |
        |  3 | NULL     |
        +----+----------+

        insert into mb_unique1 values(null,'amy');
        insert into mb_unique1 values(null,'amy');
        第一行成功,第二行失败
        Duplicate entry 'amy' for key 'username'

        +----+----------+
        | id | username |
        +----+----------+
        |  1 | NULL     |
        |  2 | NULL     |
        |  3 | NULL     |
        |  4 | amy      |
        +----+----------+

    在查看表创建语句的时候,会看到和主键不同的一点,多出一个名字
    UNIQUE KEY `username` (`username`) 系统会为唯一键自动创建一个名字(默认是字段名)

4 删除唯一键
    一个表中允许存在多个唯一键,假设命令与主键一样 alter table 表名 drop key; //错误的
    基本语法: alter table 表名 drop index 唯一键名字;
    index 关键字:索引,唯一键是索引的一种

    alter table mb_unique2 drop index username; //删除成功
    | username | varchar(10) | YES  |     | NULL    |          |

5 修改唯一键:先删除后增加

6 复合唯一键
    和主键一样
    unique(key1,key2...);

    一般主键使用单一字段(逻辑主键),其他唯一性的内容使用unique



        
