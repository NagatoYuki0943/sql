1. 文档的基本查询 db.集合名称.find(<query>, [projection])
    db.集合名称.find(<query>, [projection])
    - 可选。使用查询运算符指定选择筛选器。
    - 可选。指定要在与查询筛选器匹配的文档中返回的字段。


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


    # 查询所有
    db.comment.find() 或 db.comment.find({})

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


    # 选择查询
    db.comment.find({key:value})

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


2. 如果你只需要返回符合条件的第一条数据，我们可以使用findOne命令来实现，语法和find一样。
    db.comment.findOne({key: value})

        articledb> db.comment.findOne({userid:"1003"})
        {
        _id: '4',
        articleid: '100001',
        content: '专家说不能空腹吃饭，影响健康。',
        userid: '1003',
        nickname: '凯撒',
        createdatetime: ISODate("2019-08-06T08:18:35.288Z"),
        likenum: 2000,
        state: '1'
        }

    # 投影查询（Projection Query,返回部分字段）
    如果要查询结果返回部分字段，则需要使用投影查询（不显示所有字段，只显示指定的字段）。
        articledb> db.comment.find({userid:"1003"}, {userid:1, nickname:1})
        [
        { _id: '4', userid: '1003', nickname: '凯撒' },
        { _id: '5', userid: '1003', nickname: '凯撒' }
        ]

    默认 _id 会显示。
    如：查询结果只显示 、userid、nickname ，不显示 _id ：
        articledb> db.comment.find({userid:"1003"}, {userid:1, nickname:1,_id:0})
        [
        { userid: '1003', nickname: '凯撒' },
        { userid: '1003', nickname: '凯撒' }
        ]

    再例如：查询所有数据，但只显示 _id、userid、nickname :
        articledb> db.comment.find({}, {userid:1, nickname:1})
        [
        {
            _id: ObjectId("63d8df3ba977742c956a6b51"),
            userid: '1001',
            nickname: 'Rose'
        },
        { _id: '1', userid: '1002', nickname: '相忘于江湖' },
        { _id: '2', userid: '1005', nickname: '伊人憔悴' },
        { _id: '3', userid: '1004', nickname: '杰克船长' },
        { _id: '4', userid: '1003', nickname: '凯撒' },
        { _id: '5', userid: '1003', nickname: '凯撒' }
        ]


3. 统计 db.文档名称.countDocuments(query, options)
    - query:   查询选择条件。
    - options: 可选。用于修改计数的额外选项。

    db.集合名称.count(query, options) 弃用了

        articledb> db.comment.countDocuments()
        5
        articledb> db.comment.countDocuments({userid:"1003"})
        2


4. db.集合名称.find().skip(int).limit(int)
    skip()  跳过 默认值0
    limit() 限制 默认值20

        articledb> db.comment.find({}, {userid:1}).limit(2)
        [ { _id: '1', userid: '1002' }, { _id: '2', userid: '1005' } ]
        articledb> db.comment.find({}, {userid:1}).skip(2).limit(2)
        [ { _id: '3', userid: '1004' }, { _id: '4', userid: '1003' } ]
        articledb> db.comment.find({}, {userid:1}).skip(4).limit(2)
        [ { _id: '5', userid: '1003' } ]


5. db.集合名称.find().sort(排序方式) 排序操作
    sort() 方法可以通过参数指定排序的字段
    并使用 1 和 -1 来指定排序的方式，其中 1 为升序排列，而 -1 是用 于降序排列。

    skip(), limilt(), sort()三个放在一起执行的时候，执行的顺序是先 sort(), 然后是 skip()，最后是显示的 limit()，和命令编写顺序无关。

        # 对userid降序排列，并对访问量进行升序排列
        articledb> db.comment.find({}, {userid:1, likenum:1}).sort({userid:-1, likenum:1})
        [
        { _id: '2', userid: '1005', likenum: 888 },
        { _id: '3', userid: '1004', likenum: 666 },
        { _id: '4', userid: '1003', likenum: 2000 },
        { _id: '5', userid: '1003', likenum: 3000 },
        { _id: '1', userid: '1002', likenum: 1000 }
        ]


6. 正则的复杂条件查询 db.集合名称.find({字段: /正则表达式/})
    MongoDB的模糊查询是通过正则表达式的方式实现的。
    提示：正则表达式是js的语法，直接量的写法。

    例如，我要查询评论内容包含“开水”的所有文档，代码如下：
        articledb> db.comment.find({content: /开水/})
        [
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
        }
        ]

    如果要查询评论的内容中以“专家”开头的，代码如下：
        articledb> db.comment.find({content: /^专家/})
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
        }
        ]


7. 比较查询
    <, <=, >, >= 这个操作符也是很常用的，格式如下
    db.集合名称.find({ "field": { $gt:  value }})  // 大于: field > value
    db.集合名称.find({ "field": { $lt:  value }})  // 小于: field < value
    db.集合名称.find({ "field": { $gte: value }}) // 大于等于: field >= value
    db.集合名称.find({ "field": { $lte: value }}) // 小于等于: field <= value
    db.集合名称.find({ "field": { $ne:  value }})  // 不等于: field != value

    查询评论点赞数量大于700的记录
        articledb> db.comment.find({likenum: {$gt:1000}})
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


8. 包含查询 $in $nin
    包含使用 $in 操作符
    不包含使用 $nin 操作符
    $in:  []
    $nin: []

        articledb> db.comment.find({userid: {$in: ["1003","1004"]}}, {userid:1})
        [
        { _id: '3', userid: '1004' },
        { _id: '4', userid: '1003' },
        { _id: '5', userid: '1003' }
        ]
        articledb> db.comment.find({userid: {$nin: ["1003","1004"]}}, {userid:1})
        [ { _id: '1', userid: '1002' }, { _id: '2', userid: '1005' } ]


9. 条件连接查询 $and $or
    我们如果需要查询同时满足两个以上条件，需要使用 $and 操作符将条件进行关联
    如果两个以上条件之间是或者的关系，我们使用 $or 操作符进行关联
    $and: [ { },{ },... ]
    $or:  [ { },{ },... ]


        # 查询点赞大于等于1000小于等于3000
        articledb> db.comment.find({$and: [{likenum: {$gte:1000}}, {likenum: {$lte:3000}}]}, {userid:1})
        [
        { _id: '1', userid: '1002' },
        { _id: '4', userid: '1003' },
        { _id: '5', userid: '1003' }
        ]


        # 点赞小于1000或者大于2000
        articledb> db.comment.find({$or: [{likenum: {$lt:1000}}, {likenum: {$gt:2000}}]}, {userid:1})
        [
        { _id: '2', userid: '1005' },
        { _id: '3', userid: '1004' },
        { _id: '5', userid: '1003' }
        ]
