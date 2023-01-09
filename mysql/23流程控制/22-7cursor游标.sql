1 介绍
    游标（CURSOR）是用来存储查询结果集的数据类型 , 在存储过程和函数中可以使用游标对结果集进
    行循环的处理。游标的使用包括游标的声明、OPEN、FETCH 和 CLOSE，其语法分别如下。

2 使用
    1) 声明游标
        DECLARE 游标名称 CURSOR FOR 查询语句 ;

    2) 打开游标
        OPEN 游标名称 ;

    3) 获取游标记录
        FETCH 游标名称 INTO 变量 [, 变量 ] ;

    4) 关闭游标
        CLOSE 游标名称 ;


2 案例
    根据传入的参数uage，来查询用户表m_tb_user中，所有的用户年龄小于等于uage的用户姓名
    （name）和专业（profession），并将用户的姓名和专业插入到所创建的一张新表
    (id,name,profession)中。

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
        declare uprofession varchar(100);
        declare u_cursor cursor for select name,profession from m_tb_user where age <= uage;    -- A. 声明游标, 存储查询结果集 (游标声明在变量后面)
        drop table if exists m_tb_user_pro; -- B. 准备: 创建表结构
        create table if not exists m_tb_user_pro(
            id int primary key auto_increment,
            name varchar(100),
            profession varchar(100)
        );
        open u_cursor;  -- C. 开启游标
        while true do
            fetch u_cursor into uname, uprofession; -- D. 获取游标中的记录
            insert into m_tb_user_pro values (null, uname, uprofession);   -- E. 插入数据到新表中
        end while;
        close u_cursor; -- 关闭游标
    end;

    call p11(30);

    drop procedure p11;

    上述的存储过程，最终我们在调用的过程中，会报错，之所以报错是因为上面的while循环中，并没有
    退出条件。当游标的数据集获取完毕之后，再次获取数据，就会报错，从而终止了程序的执行。
    但是此时，m_tb_user_pro表结构及其数据都已经插入成功了，我们可以直接刷新表结构，检查表结构
    中的数据。
    上述的功能，虽然我们实现了，但是逻辑并不完善，而且程序执行完毕，获取不到数据，数据库还报
    错。 接下来，我们就需要来完成这个存储过程，并且解决这个问题。
    要想解决这个问题，就需要通过MySQL中提供的 条件处理程序 Handler 来解决。