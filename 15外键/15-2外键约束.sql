1 外键约束
    通过建立外键关系之后,对主表和从表有一定的数据约束效率

    注意:外键只能使用 innodb存储引擎,myisam不支持
        ALTER TABLE mb_foreign1 ENGINE=INNODB;
2 约束的基本概念
    (1) 当一个外键产生时:外键所在的表(从表)会受制于主表数据的存在而导致数据不能进行
        某些不符合规范的操作(不能插入主表不存在的数据);
        主表 mb_students2
        从表 mb_foreign1/2;

            desc mb_students2;
            +-------+--------------+------+-----+---------+----------------+
            | Field | Type         | Null | Key | Default | Extra          |
            +-------+--------------+------+-----+---------+----------------+
            | id    | int(255)     | NO   | PRI | NULL    | auto_increment |
            | name  | varchar(255) | YES  |     | NULL    |                |
            | sex   | varchar(255) | YES  |     | NULL    |                |
            | age   | int(255)     | YES  |     | NULL    |                |
            | class | int(255)     | YES  |     | NULL    |                |
            | score | int(255)     | YES  |     | NULL    |                |
            +-------+--------------+------+-----+---------+----------------+
            desc mb_foreign1;
            +-------+-------------+------+-----+---------+----------------+
            | Field | Type        | Null | Key | Default | Extra          |
            +-------+-------------+------+-----+---------+----------------+
            | id    | int(11)     | NO   | PRI | NULL    | auto_increment |
            | name  | varchar(10) | NO   |     | NULL    |                |
            | class | int(11)     | YES  | MUL | NULL    |                |
            +-------+-------------+------+-----+---------+----------------+
            select distinct class from mb_students2 order by class;
            +-------+
            | class |
            +-------+
            |     1 |
            |     2 |
            |     3 |
            |     4 |
            |     5 |
            |     6 |
            +-------+
            insert into mb_foreign1 values(null,'小明',1); //正确
            insert into mb_foreign1 values(null,'小红',7); //不正确,主表没有7
            detele from mb_students2 where class=1;        //失败,因为class=1已经被使用了

    (2) 如果一张表被其他表外键引入,那么该表的数据操作就不能随意,必须保证从表数据的
        有效性(不能随便删除一个被从表引入的记录);

3 外键约束的概念
    可以再创建外键的时候,对外建约束进行选择性操作
    语法: add foreign key(外键字段) references 主表(主键) on 约束模式

    约束模式有三种:
        (1) distinct:   严格模式,默认的     不允许操作
        (2) cascade:    级联模式,一起操作   主表变化,从表变化,从表数据跟着变化
        (3) set null:   置空模式            主表变化(删除),从表记录设置为空,
                                            前提是从表中对应的外键字段允许为空(不然这个外键不能设定)

    外键约束主要约束对象是主表,从表不能插入主表不存在的数据

    通常在进行约束指定的时候,需要指定操作:update和delete
    常用的约束模式: on update cascade on detele set null 更新级联,删除置空

        alter table mb_foreign2 add foreign key(class) references mb_students2(class)
        on update cascade on detele set null;

4 约束作用
    保证数据完整性,主表和从表数据要一致
    正是因为外键有非常强大的数据约束作用,而可能导致数据在后台变化的不可控,
    导致程序在设计开发逻辑的时候,没有办法很好的把握数据(业务),
    外键比较少使用