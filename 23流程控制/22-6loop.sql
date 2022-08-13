1 介绍
    LOOP 实现简单的循环，如果不在SQL逻辑中增加退出循环的条件，可以用其来实现简单的死循环。
    LOOP可以配合一下两个语句使用：
        LEAVE ：配合循环使用，退出循环。
        ITERATE：必须用在循环中，作用是跳过当前循环剩下的语句，直接进入下一次循环。

    [begin_label:] LOOP
    SQL逻辑...
    END LOOP [end_label];

    LEAVE label; -- 退出指定标记的循环体
    ITERATE label; -- 直接进入下一次循环

    上述语法中出现的 begin_label，end_label，label 指的都是我们所自定义的标记。


2 案例
    1) 案例一
    计算从1累加到n的值，n为传入的参数值。

    -- A. 定义局部变量, 记录累加之后的值;
    -- B. 每循环一次, 就会对n进行-1 , 如果n减到0, 则退出循环 ----> leave xx
    create procedure p9(in n int)
    begin
        declare total int default 0;
        sum:loop
            if n<=0 then
                leave sum;
            end if;

            set total := total + n;
            set n := n - 1;
        end loop sum;

        select total;
    end;

    call p9(100);


    2) 案例二
    计算从1到n之间的偶数累加的值，n为传入的参数值。

    -- A. 定义局部变量, 记录累加之后的值;
    -- B. 每循环一次, 就会对n进行-1 , 如果n减到0, 则退出循环 ----> leave xx
    -- C. 如果当次累加的数据是奇数, 则直接进入下一次循环. --------> iterate xx
    create procedure p10(in n int)
    begin
        declare total int default 0;
        sum:loop
            if n<=0 then
                leave sum;
            end if;

            if n%2 = 1 then
                set n := n - 1;
                iterate sum;
            end if;

            set total := total + n;
            set n := n - 1;
        end loop sum;
        select total;
    end;

    call p10(100);
