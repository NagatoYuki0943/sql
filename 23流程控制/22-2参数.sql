1 介绍
    参数的类型，主要分为以下三种：IN、OUT、INOUT。 具体的含义如下：


    类型    含义 备                                        注
    IN      该类参数作为输入，也就是需要调用时传入值         默认
    OUT     该类参数作为输出，也就是该参数可以作为返回值
    INOUT   既可以作为输入参数，也可以作为输出参数


2 用法
    CREATE PROCEDURE 存储过程名称 ([ IN/OUT/INOUT 参数名 参数类型 ])
    BEGIN
    -- SQL语句
    END ;


3 案例
    1) 案例一
    根据传入参数score，判定当前分数对应的分数等级，并返回。
        score >= 85分，等级为优秀。
        score >= 60分 且 score < 85分，等级为及格。
        score < 60分，等级为不及格。

        create procedure p4(in score int, out result varchar(10))
        begin
            if score >= 85 then
                set result := '优秀';
            elseif score >= 60 then
                set result := '及格';
            else
                set result := '不及格';
            end if;
        end;

        -- 定义用户变量 @result来接收返回的数据, 用户变量可以不用声明
        call p4(80, @result);
        select @result;
        +---------+
        | @result |
        +---------+
        | 及格    |
        +---------+

    drop procedure p4;


    2) 案例二
    将传入的200分制的分数，进行换算，换算成百分制，然后返回。
        create procedure p5(inout score double)
        begin
            set score := score * 0.5;
        end;
        set @score := 198;
        call p5(@score);

        select @score;
        +--------+
        | @score |
        +--------+
        |     99 |
        +--------+

    drop procedure p5;
