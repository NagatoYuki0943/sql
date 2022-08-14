1 手动事务
    不管是开始还是过程还是结束,都需要管理员手动的发送事务操作指令来实现.
    不用管 @@autocommit 是0还是1

2 命令
    (1) start transaction;  //开启事务,从这条语句开始,后面的所有语句都不会直接写入到
        数据表(保存在事务日志中)
    (2) 事务处理:多个写指令构成;
    (3) 事务提交:   commit/rollback,直到这个时候,这个事务才算结束

3 开启事务
    start transaction;

4 执行事务
    将多个连续但是整体的sql指令逐一执行

    insert into int1 values(null,0);
    insert into int1 values(null,1);

    //增加回滚点
    savepoint s1;

    insert into int1 values(null,2);
    insert into int1 values(null,3);
    insert into int1 values(null,4);

    这时从另一个客户端是看不到这些新数据的

5 提交事务
    commit;     提交
    rollback;   取消

6 回滚点
    savepoint: 当有一系列事务操作时,其中的步骤如果成功了,
        一部分失败了,没必要重新来过
    可以在某个点(成功),设置一个记号(回滚点),然后如果后面失败,那么可以回到这个记号位置.

    步骤:
        增加回滚点:savepoint 回滚点名字;    //字母数字下划线
        回到回滚点:rollback to 回滚点名字;  //那个记号(回滚点)之后的所有操作没有了

        注意:在一个事务处理中,如果有很多步骤,那么可以设置多个回滚点.
        但是如果回到了前面的回滚点,后面的回滚点失效;

            测试:
            //开启事务
            start transaction;

            insert into int1 values(null,0);
            insert into int1 values(null,1);
            insert into int1 values(null,2);

            //增加回滚点
            savepoint s1;

            //添加错误数据
            insert into int1 values(aa,3);

            //回滚到s1
            rollback to s1;

            //提交
            commit;