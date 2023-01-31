1. 选择和创建数据库 如果数据库不存在则自动创建
    use 数据库名称

    test> use articledb;
    switched to db articledb
    articledb> show articledb
    articledb> show databases # 看不到新创建的库，use创建实在内存中创建,所以看不到,有集合才会持久化
    admin   40.00 KiB
    config  72.00 KiB
    local   72.00 KiB


2. 查看有权限查看的所有的数据库命令
    show dbs
    或
    show databases

        test> show databases
        admin   40.00 KiB
        config  60.00 KiB
        local   72.00 KiB


3. 查看当前正在使用的数据库命令
    db

        articledb> db
        articledb

4. 数据库的删除
    // 在数据库中执行
    db.dropDatabase()

        articledb> db.dropDatabase()
        { ok: 1, dropped: 'articledb' }
