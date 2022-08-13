1 介绍
    case结构及作用，和我们在基础篇中所讲解的流程控制函数很类似。有两种语法格式：


2 语法
    注意：如果判定条件有多个，多个条件之间，可以使用 and 或 or 进行连接。

    语法1：
        -- 含义： 当case_value的值为 when_value1时，执行statement_list1，当值为 when_value2时，
        执行statement_list2， 否则就执行 statement_list
        CASE case_value
            WHEN when_value1 THEN statement_list1
            [ WHEN when_value2 THEN statement_list2] ...
            [ ELSE statement_list ]
        END CASE;

    语法2：
        -- 含义： 当条件search_condition1成立时，执行statement_list1，当条件search_condition2成
        立时，执行statement_list2， 否则就执行 statement_list
        CASE
            WHEN search_condition1 THEN statement_list1
            [WHEN search_condition2 THEN statement_list2] ...
            [ELSE statement_list]
        END CASE;


3 案例
    根据传入的月份，判定月份所属的季节（要求采用case结构）。
    1-3月份，为第一季度
    4-6月份，为第二季度
    7-9月份，为第三季度
    10-12月份，为第四季度

    create procedure p6(in month int)
    begin
        declare result varchar(10);
        case
            when month >= 1 and month <= 3 then
                set result := '第一季度';
            when month >= 4 and month <= 6 then
                set result := '第二季度';
            when month >= 7 and month <= 9 then
                set result := '第三季度';
            when month >= 10 and month <= 12 then
                set result := '第四季度';
            else
                set result := '非法参数';
        end case ;

        select concat('您输入的月份为: ',month, ', 所属的季度为: ',result);
    end;

    call p6(16);
