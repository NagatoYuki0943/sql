新增数据

1 多数据插入
insert into 表名 [(字段列表)] values(),()...;

    insert into mb_int2 values(null,14),(null,54),(null,85);

    | 11 |  14 |
    | 12 |  54 |
    | 13 |  85 |

2 主键冲突
    在有的表中,使用的是业务主键(字段有业务含义,如学生id),但是往往在进行数据插入的时候,
    又不确定数据表中是不是已经存在对应的主键

        create table mb_students3(
            stu_id varchar(10) primary key comment '主键,id',
            stu_name varchar(10) not null comment '学生姓名'
        )charset utf8;

        insert into mb_students3 values
        ('stu0001','张三'),
        ('stu0002','张四'),
        ('stu0003','张五'),
        ('stu0004','张六');

        +---------+----------+
        | stu_id  | stu_name |
        +---------+----------+
        | stu0001 | 张三     |
        | stu0002 | 张四     |
        | stu0003 | 张五     |
        | stu0004 | 张六     |
        +---------+----------+

        //插不进去,主键重复
        insert into mb_students3 values  ('stu0004','李四');

    解决方式:
        (1) 主键冲突更新
        类似插入数据语法,如果插入的过程中主键冲突,那么采用更新方法
        insert into 表名 [(字段列表)] values(值列表) on duplicate key update 字段 = 新值;
                                                        //重复的键值的时候使用 update

            insert into mb_students3 values ('stu0004','李四') on duplicate key update stu_name="李四";

            //更改成功
            | stu0004 | 李四     |

        (2) 主键冲突替换
            当主键冲突之后,干掉原来的数据,重新插入进去
            replace into 表名 [(列名)] values()...;

            replace into mb_students3 values('stu0004','哈哈哈哈');
            //成功替换
            | stu0004 | 哈哈哈哈 |

3 蠕虫复值
    一分为二,成倍增加.从已有的数据中获取数据,并且将获取到的数据插入到数据表中.
    基本语法:
        insert into 表名 [(列表)] select */字段列表 from 其他数据表;

        (1)创建变
        create table mb_simple(
            name char(1) not null
        )charset utf8;

        insert into mb_simple values('a'),('b'),('c'),('d');

        -- 蠕虫复制
        insert into mb_simple(name) select name from mb_simple;
        //第一次复制4条,第二次复制8条
        +------+
        | name |
        +------+
        | a    |
        | b    |
        | c    |
        | d    |
        | a    |
        | b    |
        | c    |
        | d    |
        +------+

    注意:
        (1) 蠕虫复制的确通常是重复数据,没有太大意义,但可以短期内快速增加表的数据量
        从而可以测试表的压力,还可以通过大量数据来测试表的效率(索引)
        (2) 蠕虫复制虽好,但是要注意主键冲突.

