1 会话变量
    用户自定义变量不需要提前声明,如果没声明就是NULL
    在mysql中因为没有比较符号 == ,有时候在赋值的时候,会报错,mysql为了避免系统分不清
    是赋值还是比较,特定增加了一个变量的赋值符号 :=

    也称为用户变量,会话变量跟mysql客户端是绑定的,设置的变量,只针对当前用户使用的客户端生效.
    语法: set @变量名 = 值; || set @变量名 := 值;

        测试:
        set @name = 'hello world';
        Query OK, 0 rows affected (0.00 sec)
        set @age := 15;
        Query OK, 0 rows affected (0.00 sec)

        set @name = 'hello world', @age := 15;  --可以一次定义多个变量

        select @name;
        +-------------+
        | @name       |
        +-------------+
        | hello world |
        +-------------+

        select @age;
        +------+
        | @age |
        +------+
        |   15 |
        +------+


2 赋值变量
    mysql是专门存储数据的,允许将数据从表中去出存到变量中,要求:查询得到的数据
    必须是一行数据(一个变量对应一个字段值,mysql没有数组)
    (1) 赋值且查看赋值过程
        select @变量1 := 字段[1],@变量2 := 字段[2] from 数据表 where 条件;  //要用 := ,不然出错

            测试:
            select @name=name,@age=age from students1 where id=1;
            +------------+----------+
            | @name=name | @age=age |
            +------------+----------+
            | NULL       | NULL     |  --有问题,全是null
            +------------+----------+
            使用了= 系统会当做比较符号来比较

            //正确语法
            select @name:=name,@age:=age from students1 where id=1;
            +-------------+-----------+
            | @name:=name | @age:=age |
            +-------------+-----------+
            | 赵一        |        15 |
            +-------------+-----------+

            select @name;
            +-------+
            | @name |
            +-------+
            | 赵一  |
            +-------+

            select @age;
            +------+
            | @age |
            +------+
            |   15 |
            +------+


    (2) 只赋值不查看过程
        select 字段1,字段2... from 数据源 where 条件 into @变量1,@变量2,...;
        select 字段1,字段2... into @变量1,@变量2,... from 数据源 where 条件;

            测试:
            select name,age from students1 where id=2 into @name,@age;
            select @name, @age;
            +-------+------+
            | @name | @age |
            +-------+------+
            | 钱二  |   16 |
            +-------+------+


3 查看变量
    select @变量名;

        select @name;
            +-------+
            | @name |
            +-------+
            | 钱二  |
            +-------+

        select @age;
        +------+
        | @age |
        +------+
        |   16 |
        +------+
