1. 查看当前库中的表
    show collections
    或
    show tables


2. 集合的显式创建（了解）
    db.createCollection(集合名称)

        articledb> db.createCollection("mycollect1")
        { ok: 1 }
        articledb> show collections;
        mycollect1
        articledb> show tables;
        mycollect1


3. 集合的隐式创建
    当向一个集合中插入一个文档的时候，如果集合不存在，则会自动创建集合。

    提示：通常我们使用隐式创建文档即可。


4. 集合的删除
    db.集合名称.drop()

        articledb> db.mycollect1.drop()
        true
        articledb> show collections;


