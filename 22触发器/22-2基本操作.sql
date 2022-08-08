1 创建触发器
    create trigger 触发器名字 触发时机 触发事件 on 表 for each row
    begin
    ...
    end

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

        delimiter $$  //这一行单独执行

        create trigger after_insert_order_t after insert on mb_orders for each row
        begin
            -- 更新商品库存
            update mb_goods set inv= inv - 1 where id = 1;
        end
        $$

        delimiter ;  //这一行单独执行


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
        |  1 | 手机   | 999 |   //inv-1
        |  2 | 电脑   | 500 |
        |  3 | 游戏机 | 100 |
        +----+--------+-----+


8 删除触发器
    drop trigger 触发器名字;

        drop trigger after_insert_order_t;
        Query OK, 0 rows affected (0.58 sec)