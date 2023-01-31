文档更新 db.集合名称.updateOne(query, update) db.集合名称.updateMany(query, update) db.集合名称.replaceOne(query, update)
    - query:    更新的选择条件。可以使用与find（）方法中相同的查询选择器，类似sql update查询内where后面的。
    - update:   要应用的修改。该值可以是：包含更新运算符表达式的文档，或仅包含：对的替换文档，

    db.集合名称.update() 弃用了


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


    局部修改 updateOne()
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
        articledb> db.comment.updateOne({_id:"1"}, {likenum:NumberInt(1001)})            # 这里报错,必须包含原来的字符
        MongoInvalidArgumentError: Update document requires atomic operators
        articledb> db.comment.updateOne({_id:"1"}, {$set:{likenum:NumberInt(1001)}})     # {$set:{key:new_value}}
        {
        acknowledged: true,
        insertedId: null,
        matchedCount: 1,
        modifiedCount: 1,
        upsertedCount: 0
        }
        articledb> db.comment.find({_id:"1"})
        [
        {
            _id: '1',
            articleid: '100001',
            content: '我们不应该把清晨浪费在手机上，健康很重要，一杯温水幸福你我他。',
            userid: '1002',
            nickname: '相忘于江湖',
            createdatetime: ISODate("2019-08-05T22:08:15.522Z"),
            likenum: 1001,
            state: '1'
        }
        ]


    批量的局部修改 updateMany()
        articledb> db.comment.find({userid:"1003"})
        [
        {
            _id: '4',
            articleid: '100001',
            content: '专家说不能空腹吃饭，影响健康。',
            userid: '1003',
            nickname: '凯撒',
            createdatetime: ISODate("2019-08-06T08:18:35.288Z"),
            likenum: 2000,
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
        articledb> db.comment.updateOne({userid:"1003"},{$set:{nickname:"凯撒2"}})
        {
        acknowledged: true,
        insertedId: null,
        matchedCount: 1,
        modifiedCount: 1,   # 修改1条
        upsertedCount: 0
        }
        articledb> db.comment.find({userid:"1003"})
        [
        {
            _id: '4',
            articleid: '100001',
            content: '专家说不能空腹吃饭，影响健康。',
            userid: '1003',
            nickname: '凯撒2',                                      # 修改了一条数据
            createdatetime: ISODate("2019-08-06T08:18:35.288Z"),
            likenum: 2000,
            state: '1'
        },
        {
            _id: '5',
            articleid: '100001',
            content: '研究表明，刚烧开的水千万不能喝，因为烫嘴。',
            userid: '1003',
            nickname: '凯撒',                                       # 这一条数据没有修改
            createdatetime: ISODate("2019-08-06T11:01:02.521Z"),
            likenum: 3000,
            state: '1'
        }
        ]
        articledb> db.comment.updateMany({userid:"1003"},{$set:{nickname:"凯撒3"}})
        {
        acknowledged: true,
        insertedId: null,
        matchedCount: 2,
        modifiedCount: 2,   # 修改2条
        upsertedCount: 0
        }
        articledb> db.comment.find({userid:"1003"})
        [
        {
            _id: '4',
            articleid: '100001',
            content: '专家说不能空腹吃饭，影响健康。',
            userid: '1003',
            nickname: '凯撒3',                                      # 2条数据都被更新
            createdatetime: ISODate("2019-08-06T08:18:35.288Z"),
            likenum: 2000,
            state: '1'
        },
        {
            _id: '5',
            articleid: '100001',
            content: '研究表明，刚烧开的水千万不能喝，因为烫嘴。',
            userid: '1003',
            nickname: '凯撒3',                                      # 2条数据都被更新
            createdatetime: ISODate("2019-08-06T11:01:02.521Z"),
            likenum: 3000,
            state: '1'
        }
        ]


    覆盖原数据 replaceOne() 没有replaceMany()
        articledb> db.comment.find({_id:"1"})
        [
        {
            _id: '1',
            articleid: '100001',
            content: '我们不应该把清晨浪费在手机上，健康很重要，一杯温水幸福你我他。',
            userid: '1002',
            nickname: '相忘于江湖',
            createdatetime: ISODate("2019-08-05T22:08:15.522Z"),
            likenum: 1001,
            state: '1'
        }
        ]
        articledb> db.comment.replaceOne({_id:"1"},{likenum:NumberInt(2000)})
        {
        acknowledged: true,
        insertedId: null,
        matchedCount: 1,
        modifiedCount: 1,
        upsertedCount: 0
        }
        articledb> db.comment.find({_id:"1"})
        [ { _id: '1', likenum: 2000 } ]


    列值增长的修改
    如果我们想实现对某列值在原有值的基础上进行增加或减少，可以使用 $inc 运算符来实现。

        # 修改1个
        articledb> db.comment.find({_id:"1"})
        [ { _id: '1', likenum: 2000 } ]
        articledb> db.comment.update({_id:"1"}, {$inc:{likenum:NumberInt(1)}})      # +1
        {
        acknowledged: true,
        insertedId: null,
        matchedCount: 1,
        modifiedCount: 1,
        upsertedCount: 0
        }
        articledb> db.comment.find({_id:"1"})
        [ { _id: '1', likenum: 2001 } ]
        articledb> db.comment.updateOne({_id:"1"}, {$inc:{likenum:NumberInt(-2)}})  # -1
        {
        acknowledged: true,
        insertedId: null,
        matchedCount: 1,
        modifiedCount: 1,
        upsertedCount: 0
        }
        articledb> db.comment.find({_id:"1"})
        [ { _id: '1', likenum: 1999 } ]

        # 修改多个
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
        articledb> db.comment.updateMany({userid:"1003"}, {$inc:{likenum:NumberInt(1)}})
        {
        acknowledged: true,
        insertedId: null,
        matchedCount: 2,
        modifiedCount: 2,
        upsertedCount: 0
        }
        articledb> db.comment.find({userid:"1003"})
        [
        {
            _id: '4',
            articleid: '100001',
            content: '专家说不能空腹吃饭，影响健康。',
            userid: '1003',
            nickname: '凯撒4',
            createdatetime: ISODate("2019-08-06T08:18:35.288Z"),
            likenum: 2001,
            state: '1'
        },
        {
            _id: '5',
            articleid: '100001',
            content: '研究表明，刚烧开的水千万不能喝，因为烫嘴。',
            userid: '1003',
            nickname: '凯撒3',
            createdatetime: ISODate("2019-08-06T11:01:02.521Z"),
            likenum: 3001,
            state: '1'
        }
        ]
