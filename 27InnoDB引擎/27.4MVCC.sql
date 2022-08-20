1 基本概念
    1). 当前读
    读取的是记录的最新版本，读取时还要保证其他并发事务不能修改当前记录，会对读取的记录进行加
    锁。对于我们日常的操作，如：select ... lock in share mode(共享锁)，select ...
    for update、update、insert、delete(排他锁)都是一种当前读。

    测试：

    在测试中我们可以看到，即使是在默认的RR隔离级别下，事务A中依然可以读取到事务B最新提交的内
    容，因为在查询语句后面加上了 lock in share mode 共享锁，此时是当前读操作。当然，当我们
    加排他锁的时候，也是当前读操作。


    2). 快照读
        简单的select（不加锁）就是快照读，快照读，读取的是记录数据的可见版本，有可能是历史数据，
        不加锁，是非阻塞读。
            • Read Committed：每次select，都生成一个快照读。
            • Repeatable Read：开启事务后第一个select语句才是快照读的地方。
            • Serializable：快照读会退化为当前读。

        测试:

        在测试中,我们看到即使事务B提交了数据,事务A中也查询不到。 原因就是因为普通的select是快照
        读，而在当前默认的RR隔离级别下，开启事务后第一个select语句才是快照读的地方，后面执行相同
        的select语句都是从快照中获取数据，可能不是当前的最新数据，这样也就保证了可重复读。


    3). MVCC
        全称 Multi-Version Concurrency Control，多版本并发控制。指维护一个数据的多个版本，
        使得读写操作没有冲突，快照读为MySQL实现MVCC提供了一个非阻塞读功能。MVCC的具体实现，还需
        要依赖于数据库记录中的三个隐式字段、undo log日志、readView。

    接下来，我们再来介绍一下InnoDB引擎的表中涉及到的隐藏字段 、undolog 以及 readview，从
    而来介绍一下MVCC的原理。


2 隐藏字段
    1 介绍
        id age ts_name
        1    1 tom
        3    3 cat

        当我们创建了上面的这张表，我们在查看表结构的时候，就可以显式的看到这三个字段。 实际上除了
        这三个字段以外，InnoDB还会自动的给我们添加三个隐藏字段及其含义分别是：

        隐藏字段 含义
        DB_TRX_ID       最近修改事务ID，记录插入这条记录或最后一次修改该记录的事务ID。
        DB_ROLL_PTR     回滚指针，指向这条记录的上一个版本，用于配合undo log，指向上一个版本。
        DB_ROW_ID       隐藏主键，如果表结构没有指定主键，将会生成该隐藏字段。

        而上述的前两个字段是肯定会添加的， 是否添加最后一个字段DB_ROW_ID，得看当前表有没有主键，
        如果有主键，则不会添加该隐藏字段。

    2 测试
        1). 查看有主键的表 stu  (PDF)
            进入服务器中的 /var/lib/mysql/itcast/ , 查看stu的表结构信息, 通过如下指令:
                ibd2sdi stu.ibd
            查看到的表结构信息中，有一栏 columns，在其中我们会看到处理我们建表时指定的字段以外，还有
            额外的两个字段 分别是：DB_TRX_ID 、 DB_ROLL_PTR ，因为该表有主键，所以没有DB_ROW_ID
            隐藏字段。

        2). 查看没有主键的表 employee
            建表语句：
                create table employee (id int , name varchar(10));
            此时，我们再通过以下指令来查看表结构及其其中的字段信息：
                ibd2sdi employee.ibd
            查看到的表结构信息中，有一栏 columns，在其中我们会看到处理我们建表时指定的字段以外，还有
            额外的三个字段 分别是：DB_TRX_ID 、 DB_ROLL_PTR 、DB_ROW_ID，因为employee表是没有
            指定主键的。


3 undolog
    1 介绍
        回滚日志，在insert、update、delete的时候产生的便于数据回滚的日志。
        当insert的时候，产生的undo log日志只在回滚时需要，在事务提交后，可被立即删除。
        而update、delete的时候，产生的undo log日志不仅在回滚时需要，在快照读时也需要，不会立即
        被删除。

    2 版本链
        有一张表原始数据为

        id age name DB_TRX_ID DB_ROLL_PTR
        30  30  A30     1        null

        DB_TRX_ID :    代表最近修改事务ID，记录插入这条记录或最后一次修改该记录的事务ID，是自增的。
        DB_ROLL_PTR ： 由于这条数据是才插入的，没有被更新过，所以该字段值为null。

        然后，有四个并发事务同时在访问这张表。 (PDF)
        A. 第一步
            当事务2执行第一条修改语句时，会记录undo log日志，记录数据变更之前的样子; 然后更新记录，
            并且记录本次操作的事务ID，回滚指针，回滚指针用来指定如果发生回滚，回滚到哪一个版本。

        B. 第二步
            当事务3执行第一条修改语句时，也会记录undo log日志，记录数据变更之前的样子; 然后更新记
            录，并且记录本次操作的事务ID，回滚指针，回滚指针用来指定如果发生回滚，回滚到哪一个版本。

        C. 第三步
            当事务4执行第一条修改语句时，也会记录undo log日志，记录数据变更之前的样子; 然后更新记
            录，并且记录本次操作的事务ID，回滚指针，回滚指针用来指定如果发生回滚，回滚到哪一个版本。

        最终我们发现，不同事务或相同事务对同一条记录进行修改，会导致该记录的undolog生成一条
        记录版本链表，链表的头部是最新的旧记录，链表尾部是最早的旧记录。


4 readview
    ReadView（读视图）是 快照读 SQL执行时MVCC提取数据的依据，记录并维护系统当前活跃的事务（未提交的）id。
    ReadView中包含了四个核心字段：

    字段            含义
    m_ids           当前活跃的事务ID集合
    min_trx_id      最小活跃事务ID
    max_trx_id      预分配事务ID，当前最大事务ID+1（因为事务ID是自增的）
    creator_trx_id  ReadView创建者的事务ID

    而在readview中就规定了版本链数据的访问规则：
    trx_id 代表当前undolog版本链对应事务ID。

    条件                                是否可以访问                                说明
    trx_id == creator_trx_id            可以访问该版本                              成立，说明数据是当前这个事务更改的。
    trx_id < min_trx_id                 可以访问该版本                              成立，说明数据已经提交了。
    trx_id > max_trx_id                 不可以访问该版本                            成立，说明该事务是在ReadView生成后才开启。
    min_trx_id <= trx_id <= max_trx_id  如果trx_id不在m_ids中，是可以访问该版本的    成立，说明数据已经提交。

    不同的隔离级别，生成ReadView的时机不同：
        - READ COMMITTED ：在事务中每一次执行快照读时生成ReadView。
        - REPEATABLE READ：仅在事务中第一次执行快照读时生成ReadView，后续复用该ReadView。


5 原理分析
    1 RC隔离级别
        RC隔离级别下，在事务中每一次执行快照读时生成ReadView。

        我们就来分析事务5中，两次快照读读取数据，是如何获取数据的?
        在事务5中，查询了两次id为30的记录，由于隔离级别为Read Committed，所以每一次进行快照读
        都会生成一个ReadView，那么两次生成的ReadView如下。

        那么这两次快照读在获取数据时，就需要根据所生成的ReadView以及ReadView的版本链访问规则，
        到undolog版本链中匹配数据，最终决定此次快照读返回的数据。

        (PDF)

    2 RR隔离级别
        RR隔离级别下，仅在事务中第一次执行快照读时生成ReadView，后续复用该ReadView。 而RR 是可
        重复读，在一个事务中，执行两次相同的select语句，查询到的结果是一样的。

        (PDF)
