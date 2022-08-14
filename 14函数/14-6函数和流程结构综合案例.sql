1 案例
    需求:从1开始知道用户传入的对应的值位置,自动求和;凡是5的倍数都不要.

2 设计
    (1) 创建函数
    (2) 需要一个形参,确定需要累加到什么位置
    (3) 需要定义一个变量来保存对应的结果: set @ 变量名
        使用局部变量,此结果只在函数内部使用
        declare 变量名 类型 [= 默认值];
    (4) 内部需要一个循环来实现迭代
    (5) 循环内部需要进行条件判断控制:5的倍数
    (6) 函数必须有返回值

3 函数
    //创建自动求和的函数

    -- 修改语句结束符
    delimiter $$    //这一行单独执行
    -- 创建函数
    create function sum(end_value int) returns int
    begin
        -- 声明局部变量 :如果使用declare声明变量,必须在函数体其他语句之前
        declare res int = 0;
        declare i int =1;
        -- 循环处理
        mywhile:while i<=end_value do
            -- 判断当前数据是否是5的倍数
            if i % 5 = 0 then
                -- 5的倍数不要
                set i = i + 1;
                iterate mywhile;
            end if;

            -- 修改变量:累加结果
            set re s = res + i;  --mysql中没有 ++
            set i = i + 1;

        end while mywhile;

        -- 返回值
        return res;
    end
    -- 结束
    $$
    -- 改回语句结束符
    delimiter ;    //这一行单独执行
