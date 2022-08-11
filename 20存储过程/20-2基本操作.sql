1 创建过程
    基本语法:
        create procedure 过程名字([]参数列表])
        begin
            过程体
        end
        结束符

        注意: (1) 如果过程体重只有一条指令,那么可以省略 begin 和 end
              (2) 过程基本上可以完成函数的功能

            测试:
                create procedure mb_pro1()
                select * from mb_students1;
                Query OK, 0 rows affected (0.23 sec)

                创建复杂过程
                delimiter $$    //这一行单独执行
                create procedure mb_pro2()
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
                delimiter ;    //这一行单独执行

2 查看过程
    查看过程和查看函数完全一样,除了关键字
    查看全部存储过程: show procedure status [like 'pattern'];

        show procedure status;
        ...
        27 rows in set (0.73 sec)

    查看过程创建语句: show create procedure 过程名字;

        show create procedure mb_pro1;
        +-----------+-----------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------+----------------------+----------------------+--------------------+
        | Procedure | sql_mode                                                                                                              | Create Procedure                                                                  | character_set_client | collation_connection | Database Collation |
        +-----------+-----------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------+----------------------+----------------------+--------------------+
        | mb_pro1   | ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION | CREATE DEFINER=`root`@`localhost` PROCEDURE `mb_pro1`()
        select * from mb_studnets1 | utf8mb4              | utf8mb4_0900_ai_ci   | utf8_unicode_ci    |
        +-----------+-----------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------+----------------------+----------------------+--------------------+


3 调用过程
    过程没有返回值,select不能使用
    过程有专用语法: call 过程名([实参列表])

        call mb_pro1;
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

        drop procedure mb_pro1;
        Query OK, 0 rows affected (0.31 sec)

5 修改
    没法修改,只能先删除再创建