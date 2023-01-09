1 介绍
    repeat是有条件的循环控制语句, 当满足until声明的条件的时候，则退出循环。具体语法为：

    -- 先执行一次逻辑，然后判定UNTIL条件是否满足，如果满足，则退出。如果不满足，则继续下一次循环
    REPEAT
        SQL逻辑...
        UNTIL 条件
    END REPEAT;


2  案例
    计算从1累加到n的值，n为传入的参数值。(使用repeat实现

    -- A. 定义局部变量, 记录累加之后的值;
    -- B. 每循环一次, 就会对n进行-1 , 如果n减到0, 则退出循环
    create procedure p8(in n int)
    begin
        declare total int default 0;
        repeat
            set total := total + n;
            set n := n - 1;
        until n <= 0
        end repeat;

        select total;
    end;

    call p8(100);
    +-------+
    | total |
    +-------+
    |  5050 |
    +-------+
