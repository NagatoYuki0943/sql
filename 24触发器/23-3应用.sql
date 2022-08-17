触发器应用
1 记录关键字:new old
    触发器针对的是数据表中对应的每条记录(每行),每行在数据操作前后都有一个对应的状态,
    触发器在执行之前就将对应的状态取到了,将没有操作之前的状态(数据)都保存到old关键字
    中,而操作后的状态都放到new中.

    再触发器中可以通过old和new来获取绑定表中对应的记录数据.
    语法: 关键字.字段名

    注意: old 和 new 并不是所有触发器都有,
    insert: 插入前全为空,没有 old
    delete: 清空,没有 new


2 商品自动扣除库存

        delimiter $$  //这一行单独执行

        create trigger  after_insert_order_t after insert on orders for each row
        begin
           -- 更新商品库存:new代表新增的订单
           update goods set inv = inv - new.goods_num  where id = new.goods_id;
        end
        $$
        Query OK, 0 rows affected (0.51 sec)

        delimiter ;  //这一行单独执行

    验证
        insert into orders values(null,2,5),(null,3,10);

        mysql> select * from goods;
        +----+--------+-----+
        | id | name   | inv |
        +----+--------+-----+
        |  1 | 手机   | 999 |
        |  2 | 电脑   | 495 |  // -5 成功
        |  3 | 游戏机 |  90 |  // -10 成功
        +----+--------+-----+

    如果库存没有商品订单多怎么办?
        操作目标依然是目标表,操作时间是下单前;事件:插入事件;

        判断库存
        delimiter $$  //这一行单独执行

        create trigger before_insert_order_t before insert on orders for each row
        begin
            -- 取出库存数据进行判断
            select inv from goods where id = new.goods_id into @inv;

            -- 判断
            if @inv < new.goods_num then
                -- 中断操作:暴力解决,主动操作
                insert into xx values('xx');
            end if;
        end
        $$

        delimiter ;  //这一行单独执行

        insert into orders values(null,3,9999); //报错停止执行


        select * from orders;
        +----+----------+-----------+
        | id | goods_id | goods_num |
        +----+----------+-----------+
        |  1 |        1 |         1 |
        |  2 |        2 |         5 |
        |  3 |        3 |        10 |
        +----+----------+-----------+
        3 rows in set (0.04 sec)

        mysql> select * from goods;
        +----+--------+-----+
        | id | name   | inv |
        +----+--------+-----+
        |  1 | 手机   | 999 |
        |  2 | 电脑   | 495 |
        |  3 | 游戏机 |  90 |
        +----+--------+-----+
