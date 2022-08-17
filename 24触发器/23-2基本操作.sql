1 创建触发器
    create trigger trigger_name
    before/after  insert/update/delete
    on tbl_name for each row    -- 行级触发器
    begin
        trigger_stmt ;
    end;

    触发对象: on 表 for each row ,触发器绑定的是指是表中的所有行,因此当每一行发生
    指定的改变的时候,就发触发触发器


2 查看触发器
    (1) 查看全部触发器
        show triggers [like 'pattern'];

    (2) 查看触发器的创建语句
        show create trigger 触发器名字;
        show create trigger after_insert_order_t;



3 删除触发器
    drop trigger 触发器名字;


4 触发时机
    触发时机,每张表中对应的行都会有不同的状态,当sql指令发生的时候,都会令行中数据
    发生改变,每一行都会有两种状态:数据操作前和操作后
    before: 在表中数据发生改变前的状态
    after:  在表中数据已经发生改变后的状态


5 触发器类型
    MySQL中触发器针对的目标是数据发生改变,对应的操作只有写操作(增删改)

    触发器类型          NEW 和 OLD
    insert 型触发器     NEW 表示将要或者已经新增的数据
    update 型触发器     OLD 表示修改之前的数据, NEW 表示将要或已经修改后的数据
    delete 型触发器     OLD 表示将要或者已经删除的数据


6 注意事项
    一张表中,每一个触发时机绑定的触发事件对应的触发器类型只能有一个:如一张表中一个after insert 触发器
    因此,一张表中最多的触发器只有6个:
            before insert | before update | before delete
            after insert  | after update  |  after delete


7 案例
    通过触发器记录 m_tb_user 表的数据变更日志，将变更日志插入到日志表m_user_logs中, 包含增加,
    修改 , 删除 ;

    表结构准备:
        -- 准备工作 : 日志表 m_user_logs
        create table m_user_logs(
            id int(11) not null auto_increment,
            operation varchar(20) not null comment '操作类型, insert/update/delete',
            operate_time datetime not null comment '操作时间',
            operate_id int(11) not null comment '操作的ID',
            operate_params varchar(500) comment '操作参数',
            primary key(`id`)
        )engine=innodb default charset=utf8;


    A. 插入数据触发器
        create trigger m_tb_user_insert_trigger
            after insert on m_tb_user for each row
        begin
            insert into m_user_logs(id, operation, operate_time, operate_id, operate_params)
            VALUES
            -- new 指的是新数据
            (null, 'insert', now(), new.id, concat('插入的数据内容为:
            id=',new.id,',name=',new.name, ', phone=', new.phone, ', email=', new.email, ',profession=', new.profession));
        end;

    测试:
        -- 查看
        show triggers;

        -- 插入数据到m_tb_user
        insert into m_tb_user(id, name, phone, email, profession, age, gender, status, createtime)
        VALUES (26,'三皇子','18809091212','erhuangzi@163.com','软件工程',23,'1','1',now());

        -- 测试完毕之后，检查日志表中的数据是否可以正常插入，以及插入数据的正确性。

        drop trigger m_tb_user_insert_trigger;


    B. 修改数据触发器
        create trigger m_tb_user_update_trigger
            after update on m_tb_user for each row
        begin
            insert into m_user_logs(id, operation, operate_time, operate_id, operate_params)
            VALUES
            -- new 指的是新数据 old 指的是旧数据
            (null, 'update', now(), new.id,
            concat('更新之前的数据: id=',old.id,',name=',old.name, ', phone=',
            old.phone, ', email=', old.email, ', profession=', old.profession,
            ' | 更新之后的数据: id=',new.id,',name=',new.name, ', phone=',
            new.phone, ', email=', new.email, ', profession=', new.profession));
        end;
    测试:
        -- 查看
        show triggers;
        -- 更新
        update m_tb_user set profession = '会计' where id = 23;
        update m_tb_user set profession = '会计' where id <= 5; -- 一次更改多条数据,会触发多个触发器
        测试完毕之后，检查日志表中的数据是否可以正常插入，以及插入数据的正确性。

        drop trigger m_tb_user_update_trigger;


    C. 删除数据触发器
        create trigger m_tb_user_delete_trigger
            after delete on m_tb_user for each row
        begin
            insert into m_user_logs(id, operation, operate_time, operate_id, operate_params)
            VALUES
            -- old是旧数据
            (null, 'delete', now(), old.id,
            concat('删除之前的数据: id=',old.id,',name=',old.name, ', phone=',
            old.phone, ', email=', old.email, ', profession=', old.profession));
        end;
    测试:
        -- 查看
        show triggers;
        -- 删除数据
        delete from m_tb_user where id = 26;
        -- 测试完毕之后，检查日志表中的数据是否可以正常插入，以及插入数据的正确性。

        drop trigger m_tb_user_delete_trigger;
