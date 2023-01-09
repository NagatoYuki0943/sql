1 数据准备

drop table if exists m_account;

create table m_account(
    id int primary key AUTO_INCREMENT comment 'ID',
    name varchar(10) comment '姓名',
    money double(10,2) comment '余额'
) comment '账户表';


2 未控制事务
    1). 测试正常情况
        -- 1. 查询张三余额
        select * from m_account where name = '张三';
        -- 2. 张三的余额减少1000
        update m_account set money = money - 1000 where name = '张三';
        -- 3. 李四的余额增加1000
        update m_account set money = money + 1000 where name = '李四';

    2). 测试异常情况
        -- 1. 查询张三余额
        select * from m_account where name = '张三';
        -- 2. 张三的余额减少1000
        update m_account set money = money - 1000 where name = '张三';
        出错了....
        -- 3. 李四的余额增加1000
        update m_account set money = money + 1000 where name = '李四';


3 控制事务一
    1). 查看/设置事务提交方式
        SELECT @@autocommit ;
        +--------------+
        | @@autocommit |
        +--------------+
        |            1 |
        +--------------+

        show variables like 'autocommit';
        +---------------+-------+
        | Variable_name | Value |
        +---------------+-------+
        | autocommit    | ON    |
        +---------------+-------+

        --关闭事务
        set autocommit = 0/off;
        set @@autocommit = 0/off;
        --开启事务
        set autocommit = 1/on;
        set @@autocommit = 1/on;



    2). 提交事务
        COMMIT;

    3). 回滚事务
    注意：上述的这种方式，我们是修改了事务的自动提交行为, 把默认的自动提交修改为了手动提
    交, 此时我们执行的DML语句都不会提交, 需要手动的执行commit进行提交。
        ROLLBACK;

    注意：上述的这种方式，我们是修改了事务的自动提交行为, 把默认的自动提交修改为了手动提
    交, 此时我们执行的DML语句都不会提交, 需要手动的执行commit进行提交。


4 控制事务二
    1). 开启事务
        START TRANSACTION 或 BEGIN ;

    2). 提交事务
        COMMIT;

    3). 回滚事务
        ROLLBACK;


5 转账案例:
    -- 开启事务
    start transaction
    -- 1. 查询张三余额
    select * from m_account where name = '张三';
    -- 2. 张三的余额减少1000
    update m_account set money = money - 1000 where name = '张三';
    -- 3. 李四的余额增加1000
    update m_account set money = money + 1000 where name = '李四';
    -- 如果正常执行完毕, 则提交事务
    commit;
    -- 如果执行过程中报错, 则回滚事务
    -- rollback;

