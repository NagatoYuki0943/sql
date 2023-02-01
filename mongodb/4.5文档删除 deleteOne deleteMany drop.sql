删除文档 db.集合名称.deleteOne(query) db.集合名称.deleteMany(query)
    db.集合名称.remove() 弃用了

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


删除单条 db.集合名称.deleteOne(query)
    articledb> db.comment.find({_id:"1"})
    [
    {
        _id: '1',
        articleid: '100001',
        content: '我们不应该把清晨浪费在手机上，健康很重要，一杯温水幸福你我他。',
        userid: '1002',
        nickname: '相忘于江湖',
        createdatetime: ISODate("2019-08-05T22:08:15.522Z"),
        likenum: 1000,
        state: '1'
    }
    ]
    articledb> db.comment.deleteOne({_id:"1"})
    { acknowledged: true, deletedCount: 1 }
    articledb> db.comment.find({_id:"1"})

    articledb> db.comment.find({userid:"1003"})
    [
    {
        _id: '4',
        articleid: '100001',
        content: '专家说不能空腹吃饭，影响健康。',
        userid: '1003',
        nickname: '凯撒',
        createdatetime: ISODate("2019-08-06T08:18:35.288Z"),
        state: '1'
    },
    {
        _id: '5',
        articleid: '100001',
        content: '研究表明，刚烧开的水千万不能喝，因为烫嘴。',
        userid: '1003',
        nickname: '凯撒',
        createdatetime: ISODate("2019-08-06T11:01:02.521Z"),
        likenum: 3000,
        state: '1'
    }
    ]
    articledb> db.comment.deleteOne({userid:"1003"})        # 2条数据还剩下1条
    { acknowledged: true, deletedCount: 1 }
    articledb> db.comment.find({userid:"1003"})             # 还剩1条
    [
    {
        _id: '5',
        articleid: '100001',
        content: '研究表明，刚烧开的水千万不能喝，因为烫嘴。',
        userid: '1003',
        nickname: '凯撒',
        createdatetime: ISODate("2019-08-06T11:01:02.521Z"),
        likenum: 3000,
        state: '1'
    }
    ]


删除多条 db.集合名称.deleteMany(query)
    db.集合名称.deleteMany({}) # 查询为空删除全部数据

    articledb> db.comment.find({userid:"1003"})
    [
    {
        _id: '4',
        articleid: '100001',
        content: '专家说不能空腹吃饭，影响健康。',
        userid: '1003',
        nickname: '凯撒4',
        createdatetime: ISODate("2019-08-06T08:18:35.288Z"),
        likenum: 2000,
        state: '1'
    },
    {
        _id: '5',
        articleid: '100001',
        content: '研究表明，刚烧开的水千万不能喝，因为烫嘴。',
        userid: '1003',
        nickname: '凯撒3',
        createdatetime: ISODate("2019-08-06T11:01:02.521Z"),
        likenum: 3000,
        state: '1'
    }
    ]
    articledb> db.comment.deleteMany({userid:"1003"})
    { acknowledged: true, deletedCount: 2 }
    articledb> db.comment.find({userid:"1003"})
    articledb> db.comment.deleteMany({})        # 删除全部
    { acknowledged: true, deletedCount: 3 }
    articledb> db.comment.find({})


删除整个集合 db.集合名称.drop()
    articledb> show collections;
    comment
    comment1
    articledb> db.comment1.drop()
    true
    articledb> show collections;
    comment

