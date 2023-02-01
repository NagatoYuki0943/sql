1. 单个文档插入 db.集合名称.inserOne(json)
    注意事项:
        1. comment集合如果不存在，则会隐式创建
        2. mongo中的数字，默认情况下是double类型，如果要存整型，必须使用函数NumberInt(整型数字)，否则取出来就有问题了。
        3. 插入当前日期使用 new Date()
        4. 插入的数据没有指定 _id ，会自动生成主键值
        5. 如果某字段没值，可以赋值为null，或不写该字段。


        test> use articledb
        switched to db articledb
        articledb> db.comment.insertOne( { "articleid": "100000", "content": "今天天气真好，阳光明媚", "userid": "1001", "nickname": "Rose", "createdatetime": new Date(), "likenum": NumberInt(10), "state": null })
        {
        acknowledged: true,
        insertedId: ObjectId("63d90010a977742c956a6b53")            # 返回insertedId
        }
        articledb> db.comment.find()
        [
        {
            _id: ObjectId("63d90000a977742c956a6b52"),
            articleid: '100000',
            content: '今天天气真好，阳光明媚',
            userid: '1001',
            nickname: 'Rose',
            createdatetime: ISODate("2023-01-31T11:48:16.269Z"),
            likenum: 10,
            state: null
        },
        {
            _id: ObjectId("63d90010a977742c956a6b53"),
            articleid: '100000',
            content: '今天天气真好，阳光明媚',
            userid: '1001',
            nickname: 'Rose',
            createdatetime: ISODate("2023-01-31T11:48:32.336Z"),
            likenum: 10,
            state: null
        }
        ]


2. 批量插入 db.集合名称.insertMany([json...])
    db.集合名称.insertMany(
        [ <document 1> , <document 2>, ... ],
        {
            writeConcern: <document>,
            ordered: <boolean>
        }
    )

        articledb> db.comment.insertMany(
                            [
                                {"_id":"1","articleid":"100001","content":"我们不应该把清晨浪费在手机上，健康很重要，一杯温水幸福你我他 。","userid":"1002","nickname":"相忘于江湖","createdatetime":new Date("2019-08-05T22:08:15.522Z"),"likenum":NumberInt(1000),"state":"1"},
                                {"_id":"2","articleid":"100001","content":"我夏天空腹喝凉开水，冬天喝温开水","userid":"1005","nickname":"伊人憔悴","createdatetime":new Date("2019-08-05T23:58:51.485Z"),"likenum":NumberInt(888),"state":"1"},
                                {"_id":"3","articleid":"100001","content":"我一直喝凉开水，冬天夏天都喝。","userid":"1004","nickname":"杰克船长","createdatetime":new Date("2019-08-06T01:05:06.321Z"),"likenum":NumberInt(666),"state":"1"},
                                {"_id":"4","articleid":"100001","content":"专家说不能空腹吃饭，影响健康。","userid":"1003","nickname":"凯撒","createdatetime":new Date("2019-08-06T08:18:35.288Z"),"likenum":NumberInt(2000),"state":"1"},
                                {"_id":"5","articleid":"100001","content":"研究表明，刚烧开的水千万不能喝，因为烫嘴。","userid":"1003","nickname":"凯撒","createdatetime":new Date("2019-08-06T11:01:02.521Z"),"likenum":NumberInt(3000),"state":"1"}
                            ]
                        )
        { acknowledged: true, insertedIds: { '0': '1', '1': '2', '2': '3', '3': '4', '4': '5' } }
        articledb> db.comment.find()
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
        },
        {
            _id: '2',
            articleid: '100001',
            content: '我夏天空腹喝凉开水，冬天喝温开水',
            userid: '1005',
            nickname: '伊人憔悴',
            createdatetime: ISODate("2019-08-05T23:58:51.485Z"),
            likenum: 888,
            state: '1'
        },
        {
            _id: '3',
            articleid: '100001',
            content: '我一直喝凉开水，冬天夏天都喝。',
            userid: '1004',
            nickname: '杰克船长',
            createdatetime: ISODate("2019-08-06T01:05:06.321Z"),
            likenum: 666,
            state: '1'
        },
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


        如果某条数据插入失败，将会终止插入，但已经插入成功的数据不会回滚掉。
        因为批量插入由于数据较多容易出现失败，因此，可以使用try catch进行异常捕捉处理，测试的时候可以不处理。如（了解）：

            articledb> try {
            ...     db.comment.insertMany(
            ...         [
            ...             {"_id":"1","articleid":"100001","content":"我们不应该把清晨浪费在手机上，健康很重要，一杯温水幸福你我他。","userid":"1002","nickname":"相忘于江湖","createdatetime":new Date("2019-08-05T22:08:15.522Z"),"likenum":NumberInt(1000),"state":"1"},
            ...             {"_id":"2","articleid":"100001","content":"我夏天空腹喝凉开水，冬天喝温开水","userid":"1005","nickname":"伊人憔
            悴","createdatetime":new Date("2019-08-05T23:58:51.485Z"),"likenum":NumberInt(888),"state":"1"},
            ...             {"_id":"3","articleid":"100001","content":"我一直喝凉开水，冬天夏天都喝。","userid":"1004","nickname":"杰克船长","createdatetime":new Date("2019-08-06T01:05:06.321Z"),"likenum":NumberInt(666),"state":"1"},
            ...             {"_id":"4","articleid":"100001","content":"专家说不能空腹吃饭，影响健康。","userid":"1003","nickname":"凯撒","createdatetime":new Date("2019-08-06T08:18:35.288Z"),"likenum":NumberInt(2000),"state":"1"},
            ...             {"_id":"5","articleid":"100001","content":"研究表明，刚烧开的水千万不能喝，因为烫嘴。","userid":"1003","nickname":"凯撒","createdatetime":new Date("2019-08-06T11:01:02.521Z"),"likenum":NumberInt(3000),"state":"1"}
            ...         ]
            ...     );
            ... } catch (e) {
            ...     print (e);
            ... }
            MongoBulkWriteError: E11000 duplicate key error collection: articledb.comment index: _id_ dup key: { _id: "1" }
                at OrderedBulkOperation.handleWriteError (D:\sql\mongosh\bin\mongosh.exe:3902:3212749)
                at u (D:\sql\mongosh\bin\mongosh.exe:3902:3204130)
                at D:\sql\mongosh\bin\mongosh.exe:3902:3522697
                at processTicksAndRejections (node:internal/process/task_queues:96:5) {
            code: 11000,
            writeErrors: [
                WriteError {
                err: {
                    index: 0,
                    code: 11000,
                    errmsg: 'E11000 duplicate key error collection: articledb.comment index: _id_ dup key: { _id: "1" }',
                    errInfo: undefined,
                    op: {
                    _id: '1',
                    articleid: '100001',
                    content: '我们不应该把清晨浪费在手机上，健康很重要，一杯温水幸福你我他。',
                    userid: '1002',
                    nickname: '相忘于江湖',
                    createdatetime: ISODate("2019-08-05T22:08:15.522Z"),
                    likenum: Int32(1000),
                    state: '1'
                    }
                }
                }
            ],
            result: BulkWriteResult {
                result: {
                ok: 1,
                writeErrors: [
                    WriteError {
                    err: {
                        index: 0,
                        code: 11000,
                        errmsg: 'E11000 duplicate key error collection: articledb.comment index: _id_ dup key: { _id: "1" }',
                        errInfo: undefined,
                        op: {
                        _id: '1',
                        articleid: '100001',
                        content: '我们不应该把清晨浪费在手机上，健康很重要，一杯温水幸福你我他。',
                        userid: '1002',
                        nickname: '相忘于江湖',
                        createdatetime: ISODate("2019-08-05T22:08:15.522Z"),
                        likenum: Int32(1000),
                        state: '1'
                        }
                    }
                    }
                ],
                writeConcernErrors: [],
                insertedIds: [
                    { index: 0, _id: '1' },
                    { index: 1, _id: '2' },
                    { index: 2, _id: '3' },
                    { index: 3, _id: '4' },
                    { index: 4, _id: '5' }
                ],
                nInserted: 0,
                nUpserted: 0,
                nMatched: 0,
                nModified: 0,
                nRemoved: 0,
                upserted: []
                }
            },
            [Symbol(errorLabels)]: Set(0) {}
            }
