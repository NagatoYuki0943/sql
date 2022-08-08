1 自定义函数
    函数本质是实现某种功能的语句块(由多条语句组成)
    (1) 函数内部的每条指令都是一个独立的个体:需要符合语句定义规范,需要语句结束符分号;
    (2) 函数是一个整体,而且函数是在调用的时候才会被执行,那么当设计函数的时候,意味着整体不能被中断;
    (3) MySQL一旦见到语句结束符分号,就开自动开始执行

    解决方案:在定义函数之前,尝试修改临时的语句结束符
    基本语法: delimiter  //界定符
    修改临时语句结束符: delimiter 新符号    //可以使用系统非内置的,如 $$
    中间为正常sql指令;使用分号结束(系统不会执行:不认识分号)
    使用新符号结束
    修改回语句结束符: delimiter ;    delimiter $$ //注意:这一行要单独执行

2 创建函数
    自定义函数包含几个要素: function关键字,函数名,参数(形参和实参[可选]),确认函数返回值类型,函数体,返回值
    基本语法:
        修改语句结束符
        create function 函数名(形参) returns 返回值类型
        begin
            //函数体
            return 返回值数据;  //数据必须与结构中定义的返回值类型一致
        end
        语句结束符
        修改语句结束符(改回来)

            测试:
                //修改语句结束符
                delimiter $$    //这一行单独执行
                create function mb_func1() returns int
                begin
                    return 10;
                end
                $$
                delimiter ;    //这一行单独执行


    注意:并不是所有的函数都需要begin和end,如果函数本身只有一条指令(return),那么可以省略begin和end

    形参:在MySQL中需要为函数的形参执行数据类型(形参本身可以有多个)
    基本语法:
        变量名 字段类型

            测试:
                delimiter $$    //这一行单独执行
                create function mb_func2(int_1 int,int_2 int) returns int
                return int_1+int_2;
                $$
                delimiter ;    //这一行单独执行

3 查看函数
    (1) 可以通过查看function状态查看所有函数
        show function status [like 'pattern'];

    (2) 可以查看函数的创建语句
        show create function 函数名字;


4 调用函数
    自定义函数的调用与内置函数调用相同
    语法: select 函数名(实参列表);

        select mb_func1;
        select mb_func2(1,2);

5 删除函数
    基本语法: drop function 函数名;

        drop function mb_func1;
        drop function mb_func2;

6 注意事项
    (1) 自定义函数是属于用户级别的,只有当前客户端对应的数据库中可以使用
    (2) 可以再不同的数据库下看到对应的函数,但是不可以调用
    (3) 自定义函数:通常是为了将多个代码集合到一起解决一个重复性问题
    (4) 函数因为必须规范返回值,那么在内部不能使用select指令:
        select一旦执行就会得到结果(result set,直接返回),唯一一种可以用的: select 字段 into @变量
