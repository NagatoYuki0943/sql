1 概述 (PDF)
    MySQL5.5 版本开始，默认使用InnoDB存储引擎，它擅长事务处理，具有崩溃恢复特性，在日常开发
    中使用非常广泛。下面是InnoDB架构图，左侧为内存结构，右侧为磁盘结构。


2 内存结构 (PDF)
    在左侧的内存结构中，主要分为这么四大块儿： Buffer Pool、Change Buffer、Adaptive
    Hash Index、Log Buffer。 接下来介绍一下这四个部分。

    1). Buffer Pool
        InnoDB存储引擎基于磁盘文件存储，访问物理硬盘和在内存中进行访问，速度相差很大，为了尽可能
        弥补这两者之间的I/O效率的差值，就需要把经常使用的数据加载到缓冲池中，避免每次访问都进行磁
        盘I/O。

        在InnoDB的缓冲池中不仅缓存了索引页和数据页，还包含了undo页、插入缓存、自适应哈希索引以及
        InnoDB的锁信息等等。

        缓冲池 Buffer Pool，是主内存中的一个区域，里面可以缓存磁盘上经常操作的真实数据，在执行增
        删改查操作时，先操作缓冲池中的数据（若缓冲池没有数据，则从磁盘加载并缓存），然后再以一定频
        率刷新到磁盘，从而减少磁盘IO，加快处理速度。

        缓冲池以Page页为单位，底层采用链表数据结构管理Page。根据状态，将Page分为三种类型：
            • free page：空闲page，未被使用。
            • clean page：被使用page，数据没有被修改过。
            • dirty page：脏页，被使用page，数据被修改过，也中数据与磁盘的数据产生了不一致。

        在专用服务器上，通常将多达80％的物理内存分配给缓冲池 。参数设置：
            show variables like 'innodb_buffer_pool_size';
            +-------------------------+----------+
            | Variable_name           | Value    |
            +-------------------------+----------+
            | innodb_buffer_pool_size | 67108864 |
            +-------------------------+----------+


    2). Change Buffer
        Change Buffer，更改缓冲区（针对于非唯一二级索引页），在执行DML语句时，如果这些数据Page
        没有在Buffer Pool中，不会直接操作磁盘，而会将数据变更存在更改缓冲区 Change Buffer
        中，在未来数据被读取时，再将数据合并恢复到Buffer Pool中，再将合并后的数据刷新到磁盘中。
        Change Buffer的意义是什么呢?
        先来看一幅图，这个是二级索引的结构图： (PDF)

        与聚集索引不同，二级索引通常是非唯一的，并且以相对随机的顺序插入二级索引。同样，删除和更新
        可能会影响索引树中不相邻的二级索引页，如果每一次都操作磁盘，会造成大量的磁盘IO。有了
        ChangeBuffer之后，我们可以在缓冲池中进行合并处理，减少磁盘IO。


    3). Adaptive Hash Index
        自适应hash索引，用于优化对Buffer Pool数据的查询。MySQL的innoDB引擎中虽然没有直接支持
        hash索引，但是给我们提供了一个功能就是这个自适应hash索引。因为前面我们讲到过，hash索引在
        进行等值匹配时，一般性能是要高于B+树的，因为hash索引一般只需要一次IO即可，而B+树，可能需
        要几次匹配，所以hash索引的效率要高，但是hash索引又不适合做范围查询、模糊匹配等。

        InnoDB存储引擎会监控对表上各索引页的查询，如果观察到在特定的条件下hash索引可以提升速度，
        则建立hash索引，称之为自适应hash索引。

        自适应哈希索引，无需人工干预，是系统根据情况自动完成。

        参数： adaptive_hash_index

            show variables like '%hash_index%';
            +----------------------------------+-------+
            | Variable_name                    | Value |
            +----------------------------------+-------+
            | innodb_adaptive_hash_index       | ON    |
            | innodb_adaptive_hash_index_parts | 8     |
            +----------------------------------+-------+


        4). Log Buffer
        Log Buffer：日志缓冲区，用来保存要写入到磁盘中的log日志数据（redo log 、undo log），
        默认大小为 16MB，日志缓冲区的日志会定期刷新到磁盘中。如果需要更新、插入或删除许多行的事
        务，增加日志缓冲区的大小可以节省磁盘 I/O。

        参数:

            innodb_log_buffer_size：缓冲区大小
            innodb_flush_log_at_trx_commit：日志刷新到磁盘时机，取值主要包含以下三个：
                1: 日志在每次事务提交时写入并刷新到磁盘，默认值。
                0: 每秒将日志写入并刷新到磁盘一次。
                2: 日志在每次事务提交后写入，并每秒刷新到磁盘一次。

        show variables like 'innodb_log_buffer_size';
        +------------------------+---------+
        | Variable_name          | Value   |
        +------------------------+---------+
        | innodb_log_buffer_size | 4194304 |
        +------------------------+---------+

        show variables like 'innodb_flush_log_at_trx_commit';
        +--------------------------------+-------+
        | Variable_name                  | Value |
        +--------------------------------+-------+
        | innodb_flush_log_at_trx_commit | 1     | -- 1: 日志在每次事务提交时写入并刷新到磁盘，默认值。
        +--------------------------------+-------+


3 磁盘结构 (PDF)
    接下来，再来看看InnoDB体系结构的右边部分，也就是磁盘结构：

    1). System Tablespace
        系统表空间是更改缓冲区的存储区域。如果表是在系统表空间而不是每个表文件或通用表空间中创建
        的，它也可能包含表和索引数据。(在MySQL5.x版本中还包含InnoDB数据字典、undolog等)
        参数：innodb_data_file_path
        系统表空间，默认的文件名叫 ibdata1。

        show variables like 'innodb_data_file_path';
        +-----------------------+------------------------+
        | Variable_name         | Value                  |
        +-----------------------+------------------------+
        | innodb_data_file_path | ibdata1:12M:autoextend |
        +-----------------------+------------------------+

    2). File-Per-Table tablespace
        如果开启了innodb_file_per_table开关 ，则每个表的文件表空间包含单个InnoDB表的数据和索
        引 ，并存储在文件系统上的单个数据文件中。
        开关参数：innodb_file_per_table ，该参数默认开启。

        那也就是说，我们没创建一个表，都会产生一个表空间文件，如图：

    3). General tablespace
        通用表空间，需要通过 create tablespace 语法创建通用表空间，在创建表时，可以指定该表空间。

        A. 创建表空间
            create tablespace ts_name add datafile 'file_name' engine = engine_name;

            create tablespace mb add datafile 'mb.itd' engine = innodb;

        B. 创建表时指定表空间
            create table xxx ... tablespace ts_name;

            create table a(
                id int auto_increment primary key,
                name varchar(10)
            ) engine=innodb,tablespace=mb;

    4). Undo tablespace
        撤销表空间，MySQL实例在初始化时会自动创建两个默认的undo表空间（初始大小16M），用于存储
        undo log日志。

    5). Temporary tablespace
        InnoDB 使用会话临时表空间和全局临时表空间。存储用户创建的临时表等数据。

    6). Doublewrite Buffer Files
        双写缓冲区，innoDB引擎将数据页从Buffer Pool刷新到磁盘前，先将数据页写入双写缓冲区文件
        中，便于系统异常时恢复数据。

    7). Redo Log
        重做日志，是用来实现事务的持久性。该日志文件由两部分组成：重做日志缓冲（redo log
        buffer）以及重做日志文件（redo log）,前者是在内存中，后者在磁盘中。当事务提交之后会把所
        有修改信息都会存到该日志中, 用于在刷新脏页到磁盘时,发生错误时, 进行数据恢复使用。
        以循环方式写入重做日志文件，涉及两个文件：

        前面我们介绍了InnoDB的内存结构，以及磁盘结构，那么内存中我们所更新的数据，又是如何到磁盘
        中的呢？ 此时，就涉及到一组后台线程，接下来，就来介绍一些InnoDB中涉及到的后台线程。


4 后台线程
    在InnoDB的后台线程中，分为4类，分别是：Master Thread 、IO Thread、Purge Thread、
    Page Cleaner Thread。

    1). Master Thread
        核心后台线程，负责调度其他线程，还负责将缓冲池中的数据异步刷新到磁盘中, 保持数据的一致性，
        还包括脏页的刷新、合并插入缓存、undo页的回收 。

    2). IO Thread
        在InnoDB存储引擎中大量使用了AIO来处理IO请求, 这样可以极大地提高数据库的性能，而IO
        Thread主要负责这些IO请求的回调。

        线程类型            默认个数        职责
        Read thread             4       负责读操作
        Write thread            4       负责写操作
        Log thread              1       负责将日志缓冲区刷新到磁盘
        Insert buffer thread    1       负责将写缓冲区内容刷新到磁盘

        我们可以通过以下的这条指令，查看到InnoDB的状态信息，其中就包含IO Thread信息。

            show engine innodb status \G;
            *************************** 1. row ***************************
            Type: InnoDB
            Name:
            Status:
            =====================================
            2022-08-21 20:37:43 0x3cd8 INNODB MONITOR OUTPUT
            =====================================
            Per second averages calculated from the last 24 seconds
            -----------------
            BACKGROUND THREAD
            -----------------
            srv_master_thread loops: 15 srv_active, 0 srv_shutdown, 5337 srv_idle
            srv_master_thread log flush and writes: 0
            ----------
            SEMAPHORES
            ----------
            OS WAIT ARRAY INFO: reservation count 1
            OS WAIT ARRAY INFO: signal count 1
            RW-shared spins 0, rounds 0, OS waits 0
            RW-excl spins 1, rounds 30, OS waits 1
            RW-sx spins 0, rounds 0, OS waits 0
            Spin rounds per wait: 0.00 RW-shared, 30.00 RW-excl, 0.00 RW-sx
            ------------
            TRANSACTIONS
            ------------
            Trx id counter 174468
            Purge done for trx s n:o < 174345 undo n:o < 0 state: running but idle
            History list length 153
            LIST OF TRANSACTIONS FOR EACH SESSION:
            ---TRANSACTION 284328861220384, not started
            0 lock struct(s), heap size 1136, 0 row lock(s)
            ---TRANSACTION 284328861219504, not started
            0 lock struct(s), heap size 1136, 0 row lock(s)
            ---TRANSACTION 284328861218624, not started
            0 lock struct(s), heap size 1136, 0 row lock(s)
            --------
            FILE I/O
            --------
            I/O thread 0 state: wait Windows aio (insert buffer thread)
            I/O thread 1 state: wait Windows aio (log thread)
            I/O thread 2 state: wait Windows aio (read thread)
            I/O thread 3 state: wait Windows aio (read thread)
            I/O thread 4 state: wait Windows aio (read thread)
            I/O thread 5 state: wait Windows aio (read thread)
            I/O thread 6 state: wait Windows aio (write thread)
            I/O thread 7 state: wait Windows aio (write thread)
            I/O thread 8 state: wait Windows aio (write thread)
            I/O thread 9 state: wait Windows aio (write thread)
            Pending normal aio reads: [0, 0, 0, 0] , aio writes: [0, 0, 0, 0] ,
            ibuf aio reads:, log i/o's:, sync i/o's:
            Pending flushes (fsync) log: 0; buffer pool: 0
            1244 OS file reads, 394 OS file writes, 108 OS fsyncs
            0.00 reads/s, 0 avg bytes/read, 0.00 writes/s, 0.00 fsyncs/s
            -------------------------------------
            INSERT BUFFER AND ADAPTIVE HASH INDEX
            -------------------------------------
            Ibuf: size 1, free list len 0, seg size 2, 0 merges
            merged operations:
            insert 0, delete mark 0, delete 0
            discarded operations:
            insert 0, delete mark 0, delete 0
            Hash table size 17393, node heap has 0 buffer(s)
            Hash table size 17393, node heap has 2 buffer(s)
            Hash table size 17393, node heap has 4 buffer(s)
            Hash table size 17393, node heap has 1 buffer(s)
            Hash table size 17393, node heap has 2 buffer(s)
            Hash table size 17393, node heap has 0 buffer(s)
            Hash table size 17393, node heap has 0 buffer(s)
            Hash table size 17393, node heap has 0 buffer(s)
            0.00 hash searches/s, 0.00 non-hash searches/s
            ---
            LOG
            ---
            Log sequence number          58146831
            Log buffer assigned up to    58146831
            Log buffer completed up to   58146831
            Log written up to            58146831
            Log flushed up to            58146831
            Added dirty pages up to      58146831
            Pages flushed up to          58146831
            Last checkpoint at           58146831
            110 log i/o's done, 0.00 log i/o's/second
            ----------------------
            BUFFER POOL AND MEMORY
            ----------------------
            Total large memory allocated 68681728
            Dictionary memory allocated 453297
            Buffer pool size   4096
            Free buffers       2875
            Database pages     1212
            Old database pages 467
            Modified db pages  0
            Pending reads      0
            Pending writes: LRU 0, flush list 0, single page 0
            Pages made young 0, not young 0
            0.00 youngs/s, 0.00 non-youngs/s
            Pages read 1074, created 138, written 268
            0.00 reads/s, 0.00 creates/s, 0.00 writes/s
            No buffer pool page gets since the last printout
            Pages read ahead 0.00/s, evicted without access 0.00/s, Random read ahead 0.00/s
            LRU len: 1212, unzip_LRU len: 0
            I/O sum[0]:cur[0], unzip sum[0]:cur[0]
            --------------
            ROW OPERATIONS
            --------------
            0 queries inside InnoDB, 0 queries in queue
            0 read views open inside InnoDB
            Process ID=19004, Main thread ID=0000000000003D80 , state=sleeping
            Number of rows inserted 394, updated 369, deleted 0, read 8327
            0.00 inserts/s, 0.00 updates/s, 0.00 deletes/s, 0.00 reads/s
            ----------------------------
            END OF INNODB MONITOR OUTPUT
            ============================

            1 row in set (0.00 sec)

            ERROR:
            No query specified


    3). Purge Thread
        主要用于回收事务已经提交了的undo log，在事务提交之后，undo log可能不用了，就用它来回收。

    4). Page Cleaner Thread
        协助 Master Thread 刷新脏页到磁盘的线程，它可以减轻 Master Thread 的工作压力，减少阻塞。



