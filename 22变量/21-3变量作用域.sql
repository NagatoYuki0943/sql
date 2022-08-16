1 变量作用于
    变量能够使用的区域范围


2 局部作用域
    作用范围在begin到end语句块之间.在该语句块里设置的变量,declare语句专门用于定义局部变量
        (1) 局部变量使用declare关键字声明
        (2) 局部变量declare语句一定出现在begin和end之间(begin end是在大型语句块中使用:函数/存储过程/触发器)
        (3) 声明语法:declare 变量名 数据类型 [属性]; 属性指的是default等

    1). 声明
        declare 变量名 变量类型 [default ... ] ;
        变量类型就是数据库字段类型：INT、BIGINT、CHAR、VARCHAR、DATE、TIME等。

    2). 赋值
        set 变量名 = 值 ;
        set 变量名 := 值 ;
        select 字段名 into 变量名 from 表名 ... ;

    演示示例:
        -- 声明局部变量 - declare
        -- 赋值
        create procedure p2()
            begin
                declare stu_count int default 0; --声明局部变量
                set stu_count := 2;	--两种赋值方式
                select count(*) into stu_count from students1;
                select stu_count;
            end;
        call p2();
        +-----------+
        | stu_count |
        +-----------+
        |        49 |
        +-----------+


3 会话作用域
    用户定义的使用 @ 符号定义的变量,使用set关键字
    会话作用域:当前用户当次连接有效,只要在本次连接中,任何地方都可以使用(可以再结构内部,也可以跨库)
        set @name='小明';
        select @name;
        +-------+
        | @name |
        +-------+
        | 小明  |
        +-------+

        create function func3() returns char(4)
        return @name;

        select func3;
        +------------+
        | func3() |
        +------------+
        | 小明       |
        +------------+

4 全局作用域
    所有的客户端所有的连接都有效,需要使用全局符号来定义
    set global 变量名 = 值;
    set @@global.变量名 = 值;

    通常:在sql编程的时候,不会使用自定义变量来控制全局,一般都是定义会话变量或者
    在结构中使用局部变量来解决问题