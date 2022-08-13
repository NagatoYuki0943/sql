1 介绍
    条件处理程序（Handler）可以用来定义在流程控制结构执行过程中遇到问题时相应的处理步骤。具体


2 语法
    DECLARE handler_action HANDLER FOR condition_value [, condition_value]... statement ;

    handler_action 的取值：
        CONTINUE: 继续执行当前程序
        EXIT: 终止执行当前程序

    condition_value 的取值：
        SQLSTATE sqlstate_value: 状态码，如 02000
        SQLWARNING: 所有以01开头的SQLSTATE代码的简写
        NOT FOUND: 所有以02开头的SQLSTATE代码的简写
        SQLEXCEPTION: 所有没有被SQLWARNING 或 NOT FOUND捕获的SQLSTATE代码的简写


3 案例
    我们继续来完成在上一小节提出的这个需求，并解决其中的问题。
    根据传入的参数uage，来查询用户表tb_user中，所有的用户年龄小于等于uage的用户姓名
    （name）和专业（profession），并将用户的姓名和专业插入到所创建的一张新表
    (id,name,profession)中。

    A. 通过SQLSTATE指定具体的状态码
    -- 逻辑:
    -- A. 声明游标, 存储查询结果集
    -- B. 准备: 创建表结构
    -- C. 开启游标
    -- D. 获取游标中的记录
    -- E. 插入数据到新表中
    -- F. 关闭游标
    create procedure p11(in uage int)
    begin
        declare uname varchar(100);
        declare upro varchar(100);
        declare u_cursor cursor for select name,profession from tb_user where age <= uage;
        -- 声明条件处理程序 ： 当SQL语句执行抛出的状态码为02000时，将关闭游标u_cursor，并退出
        declare exit handler for SQLSTATE '02000' close u_cursor;
        drop table if exists tb_user_pro;
        create table if not exists tb_user_pro(
            id int primary key auto_increment,
            name varchar(100),
            profession varchar(100)
        );
        open u_cursor;
        while true do
            fetch u_cursor into uname,upro;
            insert into tb_user_pro values (null, uname, upro);
        end while;
        close u_cursor;
    end;

    call p11(30);

    B. 通过SQLSTATE的代码简写方式 NOT FOUND
    02 开头的状态码，代码简写为 NOT FOUND
    create procedure p12(in uage int)
    begin
        declare uname varchar(100);
        declare upro varchar(100);
        declare u_cursor cursor for select name,profession from tb_user where age <= uage;
        -- 声明条件处理程序 ： 当SQL语句执行抛出的状态码为02开头时，将关闭游标u_cursor，并退出
        declare exit handler for not found close u_cursor;
        drop table if exists tb_user_pro;
        create table if not exists tb_user_pro(
            id int primary key auto_increment,
            name varchar(100),
            profession varchar(100)
        );
        open u_cursor;
        while true do
            fetch u_cursor into uname,upro;
            insert into tb_user_pro values (null, uname, upro);
        end while;
        close u_cursor;
    end;

    call p12(30);

    具体的错误状态码，可以参考官方文档：
    https://dev.mysql.com/doc/refman/8.0/en/declare-handler.html
    https://dev.mysql.com/doc/mysql-errors/8.0/en/server-error-reference.html