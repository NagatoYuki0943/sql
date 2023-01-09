1 创建过程
    基本语法:
        create procedure 过程名字([参数列表])
        begin
            -- SQL语句
        end;


        注意:
            (1) 如果过程体重只有一条指令,那么可以省略 begin 和 end
            (2) 过程基本上可以完成函数的功能

            测试:
                create procedure p1()
                begin
                    select * from students1;
                end;



                创建复杂过程  设置分隔符是因为terminal中中间使用 ; 会报错,可以使用其他的高级方式创建
                delimiter $$    -- 将 $$ 设置为结束符
                create procedure p2()
                begin
                    -- 求1到100之间的和
                    declare i int default 1;
                    -- declare sum int default 0;
                    set @sum = 0; -- 这个是会话变量,在外部可以访问,但是上面的局部变量不行

                    -- 开始循环
                    while i <= 100 do
                        set @sum = @sum + i;
                        set i = i + 1;
                    end while;

                    -- 显示结果
                    select @sum;
                end
                &&
                delimiter ;    -- 将 ; 设置为结束符


2 查看过程
    查看指定数据库的存储过程
    select * from information_schema.routines where routine_schema = 'xxx'; -- 查询指定数据库的存储过程及状态信息

        select * from information_schema.routines where routine_schema = 'mb';


    查看全部存储过程: show procedure status [like 'pattern'];

        show procedure status;
        ...
        27 rows in set (0.73 sec)


    查看过程创建语句: show create procedure 存储过程名称;

        show create procedure p1;
        +-----------+-----------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------+----------------------+----------------------+--------------------+
        | Procedure | sql_mode                                                                                                              | Create Procedure                                                                  | character_set_client | collation_connection | Database Collation |
        +-----------+-----------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------+----------------------+----------------------+--------------------+
        | pro1   | ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION | CREATE DEFINER=`root`@`localhost` PROCEDURE `pro1`()
        select * from studnets1 | utf8mb4              | utf8mb4_0900_ai_ci   | utf8_unicode_ci    |
        +-----------+-----------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------+----------------------+----------------------+--------------------+


3 调用过程
    过程没有返回值,select不能使用
    过程有专用语法: call 过程名([实参列表])

        call p1();
        +----+----------+---------+-----+-------+-------+
        | id | name     | sex     | age | class | score |
        +----+----------+---------+-----+-------+-------+
        |  1 | 赵一     | male    |  15 |     1 |    58 |
        |  2 | 钱二     | female  |  16 |     2 |    55 |
        *
        *
        *
        | 26 | 曹二十六 | female  |  15 |     5 |    55 |
        +----+----------+---------+-----+-------+-------+


4 删除过程
    drop procedure 过程名;

        drop procedure p1;
        Query OK, 0 rows affected (0.31 sec)


5 修改
    没法修改,只能先删除再创建