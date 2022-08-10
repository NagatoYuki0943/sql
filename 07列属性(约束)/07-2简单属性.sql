列属性(字段属性)

MySQL中一共6个属性:null 默认值 列描述 主键 唯一键 自增长

1 null/not null 字段是否为空
    对应的字段null为yes表示可以为空值
    +-------+----------+------+-----+---------+----------------+
    | Field | Type     | Null | Key | Default | Extra          |
    +-------+----------+------+-----+---------+----------------+
    | id    | int(11)  | NO   | PRI | NULL    | auto_increment |
    | int   | int(255) | YES  |     | NULL    |                |
    +-------+----------+------+-----+---------+----------------+
    注意:
        (1).在设计表的时候,尽量不要为空
        (2).mysql的记录长度为65535个字节,如果一个表中有字段允许为null,
            那么系统会设计保留一个字节来存储null,最终有效存储长度为65534个字节


2 default
    (1).默认值,字段被设计的时候,允许默认条件下用户不进行数据插入,
        那么可以使用时先准备好的数据来填充:通常填充的是null(上面的图片)

        create table mb_default(
            name varchar(10) not null, -- 不能为空
            age int default 18         -- 没有数据插入自动18
        )charset utf8;

        +-------+-------------+------+-----+---------+-------+
        | Field | Type        | Null | Key | Default | Extra |
        +-------+-------------+------+-----+---------+-------+
        | name  | varchar(10) | NO   |     | NULL    |       |
        | age   | int(11)     | YES  |     | 18      |       |
        +-------+-------------+------+-----+---------+-------+

        //只插入一个值前面写出相应的列名
        insert into mb_default(name) values('小明');

        +------+-----+
        | name | age |
        +------+-----+
        | 小明 |  18 |
        +------+-----+

    ****(2).default关键字的另一层使用,显示的告知字段使用默认值,****
        在进行数据插入的时候对字段值直接使用default
        insert into mb_default values('小红',default);

        +------+-----+
        | name | age |
        +------+-----+
        | 小明 |  18 |
        | 小红 |  18 |
        +------+-----+


3.列描述
    comment 专门用于给开发人员维护得注释说明
    语法: comment '字段描述';

    (1).创建表,增加字段描述
        create table mb_comment(
            name varchar(10) not null comment '当前是用户名,且不为空',
            pass varchar(50) not null comment '密码不能为空'
        )charset utf8;

        desc看不到comment
        +-------+-------------+------+-----+---------+-------+
        | Field | Type        | Null | Key | Default | Extra |
        +-------+-------------+------+-----+---------+-------+
        | name  | varchar(10) | NO   |     | NULL    |       |
        | pass  | varchar(50) | NO   |     | NULL    |       |
        +-------+-------------+------+-----+---------+-------+

    (2).使用表创建语句才能看到
        show create table mb_comment;
        | mb_comment | CREATE TABLE `mb_comment` (
        `name` varchar(10) NOT NULL COMMENT '当前是用户名,且不为空',
        `pass` varchar(50) NOT NULL COMMENT '密码不能为空'
        ) ENGINE=MyISAM DEFAULT CHARSET=utf8 |
