1 创建触发器
    create trigger trigger_name
    before/after insert/update/delete
    on tbl_name for each row -- 行级触发器
    begin
        trigger_stmt ;
    end;

    触发对象: on 表 for each row ,触发器绑定的是指是表中的所有行,因此当每一行发生
    指定的改变的时候,就发触发触发器


2 触发时机
    触发时机,每张表中对应的行都会有不同的状态,当sql指令发生的时候,都会令行中数据
    发生改变,每一行都会有两种状态:数据操作前和操作后
    before: 在表中数据发生改变前的状态
    after:  在表中数据已经发生改变后的状态


3 触发事件
    MySQL中触发器针对的目标是数据发生改变,对应的操作只有写操作(增删改)

    insert: 插入
    update: 更新
    delete: 删除


4 注意事项
    一张表中,每一个触发时机绑定的触发事件对应的触发器类型只能有一个:如一张表中一个after insert 触发器
    因此,一张表中最多的触发器只有6个:
            before insert | before update | before delete
            after insert  | after update  | after delete


5 测试
    有两张表:一张是商品表,一张是订单表(订单中保留商品id),每次订单生成,商品表中对应的库存发生变化
    (1)创键商品表和订单表
        create table mb_goods(
            id int primary key auto_increment,
            name varchar(20) not null,
            inv int
        )charset utf8;
        Query OK, 0 rows affected (0.52 sec)
        create table mb_orders(
            id int primary key auto_increment,
            goods_id int not null,
            goods_num int not null
        )charset utf8;
        Query OK, 0 rows affected (0.07 sec)

        insert into mb_goods values(null,'手机',1000),(null,'电脑',500),(null,'游戏机',100);
    (2) 创建触发器:如果商品表发生数据插入,那么对应的商品就应该减少库存

        delimiter $$  --设置 $$ 为换行符

        create trigger after_insert_order_t after insert on mb_orders for each row
        begin
            -- 更新商品库存
            update mb_goods set inv= inv - 1 where id = 1;
        end
        $$

        delimiter ;  --设置 ; 为换行符


6 查看触发器
    (1) 查看全部触发器
        show triggers [like 'pattern'];

    (2) 查看触发器的创建语句
        show create trigger 触发器名字;
        show create trigger after_insert_order_t;


7 想办法触发触发器,让触发器对应的表发生对应的操作即可
    (1) 表为 mb_goods,
    (2) 在插入之后
    (3) 事件:insert操作

        insert into mb_orders values(null,1,1);

        mysql> select * from mb_orders;
        +----+----------+-----------+
        | id | goods_id | goods_num |
        +----+----------+-----------+
        |  1 |        1 |         1 |
        +----+----------+-----------+
        1 row in set (0.03 sec)

        mysql> select * from mb_goods;
        +----+--------+-----+
        | id | name   | inv |
        +----+--------+-----+
        |  1 | 手机   | 999 |   --inv-1
        |  2 | 电脑   | 500 |
        |  3 | 游戏机 | 100 |
        +----+--------+-----+


8 删除触发器
    drop trigger 触发器名字;

        drop trigger after_insert_order_t;
        Query OK, 0 rows affected (0.58 sec)


9 案例
    通过触发器记录 tb_user 表的数据变更日志，将变更日志插入到日志表user_logs中, 包含增加,
    修改 , 删除 ;

    表结构准备:
        -- 准备工作 : 日志表 user_logs
        create table user_logs(
            id int(11) not null auto_increment,
            operation varchar(20) not null comment '操作类型, insert/update/delete',
            operate_time datetime not null comment '操作时间',
            operate_id int(11) not null comment '操作的ID',
            operate_params varchar(500) comment '操作参数',
            primary key(`id`)
        )engine=innodb default charset=utf8;


    A. 插入数据触发器
        create trigger tb_user_insert_trigger
            after insert on tb_user for each row
        begin
            insert into user_logs(id, operation, operate_time, operate_id, operate_params)
            VALUES
            (null, 'insert', now(), new.id, concat('插入的数据内容为:
            id=',new.id,',name=',new.name, ', phone=', NEW.phone, ', email=', NEW.email, ',
            profession=', NEW.profession));
        end;

    测试:
        -- 查看
        show triggers ;
        -- 插入数据到tb_user
        insert into tb_user(id, name, phone, email, profession, age, gender, status,
        createtime) VALUES (26,'三皇子','18809091212','erhuangzi@163.com','软件工程',23,'1','1',now());
        -- 测试完毕之后，检查日志表中的数据是否可以正常插入，以及插入数据的正确性。


    B. 修改数据触发器
        create trigger tb_user_update_trigger
            after update on tb_user for each row
        begin
            insert into user_logs(id, operation, operate_time, operate_id, operate_params)
            VALUES
            (null, 'update', now(), new.id,
            concat('更新之前的数据: id=',old.id,',name=',old.name, ', phone=',
            old.phone, ', email=', old.email, ', profession=', old.profession,
            ' | 更新之后的数据: id=',new.id,',name=',new.name, ', phone=',
            NEW.phone, ', email=', NEW.email, ', profession=', NEW.profession));
        end;
    测试:
        -- 查看
        show triggers ;
        -- 更新
        update tb_user set profession = '会计' where id = 23;
        update tb_user set profession = '会计' where id <= 5
        测试完毕之后，检查日志表中的数据是否可以正常插入，以及插入数据的正确性。


    C. 删除数据触发器
        create trigger tb_user_delete_trigger
            after delete on tb_user for each row
        begin
            insert into user_logs(id, operation, operate_time, operate_id, operate_params)
            VALUES
            (null, 'delete', now(), old.id,
            concat('删除之前的数据: id=',old.id,',name=',old.name, ', phone=',
            old.phone, ', email=', old.email, ', profession=', old.profession));
        end;
    测试:
        -- 查看
        show triggers ;
        -- 删除数据
        delete from tb_user where id = 26;
        -- 测试完毕之后，检查日志表中的数据是否可以正常插入，以及插入数据的正确性。