1. 索引的查看 db.集合名称.getIndexes()
    默认_id索引：
    MongoDB在创建集合的过程中，在 _id 字段上创建一个唯一的索引，默认名字为 _id_ ，该索引可防止客户端插入两个具有相同值的文 档，您不能在_id字段上删除此索引。
    注意：该索引是唯一索引，因此值不能重复，即 _id 值不能重复的。在分片集群中，通常使用 _id 作为片键。


    数据准备
        test> use articledb
        switched to db articledb
        articledb> db.comment.deleteMany({})
        articledb> db.comment.insert(
                [
                    {"_id":"1","articleid":"100001","content":"我们不应该把清晨浪费在手机上，健康很重要，一杯温水幸福你我他。","userid":"1002","nickname":"相忘于江湖","createdatetime":new Date("2019-08-05T22:08:15.522Z"),"likenum":NumberInt(1000),"state":"1"},
                    {"_id":"2","articleid":"100001","content":"我夏天空腹喝凉开水，冬天喝温开水","userid":"1005","nickname":"伊人憔悴","createdatetime":new Date("2019-08-05T23:58:51.485Z"),"likenum":NumberInt(888),"state":"1"},
                    {"_id":"3","articleid":"100001","content":"我一直喝凉开水，冬天夏天都喝。","userid":"1004","nickname":"杰克船长","createdatetime":new Date("2019-08-06T01:05:06.321Z"),"likenum":NumberInt(666),"state":"1"},
                    {"_id":"4","articleid":"100001","content":"专家说不能空腹吃饭，影响健康。","userid":"1003","nickname":"凯撒","createdatetime":new Date("2019-08-06T08:18:35.288Z"),"likenum":NumberInt(2000),"state":"1"},
                    {"_id":"5","articleid":"100001","content":"研究表明，刚烧开的水千万不能喝，因为烫嘴。","userid":"1003","nickname":"凯撒","createdatetime":new Date("2019-08-06T11:01:02.521Z"),"likenum":NumberInt(3000),"state":"1"}
                ]
            )
        {
        acknowledged: true,
        insertedIds: { '0': '1', '1': '2', '2': '3', '3': '4', '4': '5' }
        }

    articledb> db.comment.getIndexes()
    [ { v: 2, key: { _id: 1 }, name: '_id_' } ]


2. 索引的创建 db.集合名称.createIndex(keys, options)
    - keys 包含字段和值对的文档，其中字段是索引键，值描述该字段的索引类型。对于字段上的升序索引，请指定值 1；对于降序索引，请指定值 -1。
    - keys 可选。包含一组控制索引创建的选项的文档。有关详细信息，请参见选项详情列表。

    # 创建单个索引
        articledb> db.comment.createIndex({userid: 1})
        userid_1
        articledb> db.comment.getIndexes()
        [
        { v: 2, key: { _id: 1 }, name: '_id_' },
        { v: 2, key: { userid: 1 }, name: 'userid_1' }
        ]

    # 创建复合索引
        articledb> db.comment.createIndex({userid: 1, likenum: -1})
        userid_1_likenum_-1
        articledb> db.comment.getIndexes()
        [
        { v: 2, key: { _id: 1 }, name: '_id_' },
        { v: 2, key: { userid: 1 }, name: 'userid_1' },
        {
            v: 2,
            key: { userid: 1, likenum: -1 },
            name: 'userid_1_likenum_-1'
        }
        ]


3. 索引的移除 db.集合名称.dropIndex(index)
    - index: string or document 指定要删除的索引。可以通过索引名称或索引规范文档指定索引。若要删除文本索引，请指定 索引名称。

        articledb> db.comment.getIndexes()
        [
        { v: 2, key: { _id: 1 }, name: '_id_' },
        { v: 2, key: { userid: 1 }, name: 'userid_1' },
        {
            v: 2,
            key: { userid: 1, likenum: -1 },
            name: 'userid_1_likenum_-1'
        }
        ]
        articledb> db.comment.dropIndex({userid: 1, likenum: -1})   # 等同 db.comment.dropIndex("userid_1_likenum_-1")
        { nIndexesWas: 3, ok: 1 }
        articledb> db.comment.getIndexes()
        [
        { v: 2, key: { _id: 1 }, name: '_id_' },
        { v: 2, key: { userid: 1 }, name: 'userid_1' }
        ]
        articledb> db.comment.dropIndex({userid: 1})                # 等同 db.comment.dropIndex("userid_1")
        { nIndexesWas: 2, ok: 1 }
        articledb> db.comment.getIndexes()
        [ { v: 2, key: { _id: 1 }, name: '_id_' } ]


4. 删除所有索引 db.集合名称.dropIndexes()
    _id 的字段的索引是无法删除的，只能删除非 _id 字段的索引。

        articledb> db.comment.getIndexes()
        [
        { v: 2, key: { _id: 1 }, name: '_id_' },
        { v: 2, key: { userid: 1 }, name: 'userid_1' },
        {
            v: 2,
            key: { userid: 1, likenum: -1 },
            name: 'userid_1_likenum_-1'
        }
        ]
        articledb> db.comment.dropIndexes()
        {
        nIndexesWas: 3,
        msg: 'non-_id indexes dropped for collection',
        ok: 1
        }
        articledb> db.comment.getIndexes()
        [ { v: 2, key: { _id: 1 }, name: '_id_' } ]
