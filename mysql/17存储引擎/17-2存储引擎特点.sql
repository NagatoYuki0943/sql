1 存储引擎特点
    InnoDB
        1). 介绍
            InnoDB是一种兼顾高可靠性和高性能的通用存储引擎，在 MySQL 5.5 之后，InnoDB是默认的
            MySQL 存储引擎。
        2). 特点
            DML操作遵循ACID模型，支持事务；
            行级锁，提高并发访问性能；
            支持外键FOREIGN KEY约束，保证数据的完整性和正确性；
        3). 文件
            xxx.ibd：xxx代表的是表名，innoDB引擎的每张表都会对应这样一个表空间文件，存储该表的表结
            构（frm-早期的 、sdi-新版的）、数据和索引。
            参数：innodb_file_per_table

                show variables like 'innodb_file_per_table';
                如果该参数开启，代表对于InnoDB引擎的表，每一张表都对应一个ibd文件。 我们直接打开MySQL的
                数据存放目录： C:\ProgramData\MySQL\MySQL Server 8.0\Data ， 这个目录下有很多文件
                夹，不同的文件夹代表不同的数据库，我们直接打开itcast文件夹。

                可以看到里面有很多的ibd文件，每一个ibd文件就对应一张表，比如：我们有一张表 account，就
                有这样的一个account.ibd文件，而在这个ibd文件中不仅存放表结构、数据，还会存放该表对应的
                索引信息。 而该文件是基于二进制存储的，不能直接基于记事本打开，我们可以使用mysql提供的一
                个指令 ibd2sdi ，通过该指令就可以从ibd文件中提取sdi信息，而sdi数据字典信息中就包含该表
                的表结构。
        4). 逻辑存储结构
            - 表空间(Tablespace) : InnoDB存储引擎逻辑结构的最高层，ibd文件其实就是表空间文件，在表空间中可以
                包含多个Segment段。
            - 段(Segment) : 表空间是由各个段组成的， 常见的段有数据段、索引段、回滚段等。InnoDB中对于段的管
                理，都是引擎自身完成，不需要人为对其控制，一个段中包含多个区。
            - 区(Extent) : 区是表空间的单元结构，每个区的大小为1M。 默认情况下， InnoDB存储引擎页大小为
                16K， 即一个区中一共有64个连续的页。
            - 页(Page) : 页是组成区的最小单元，页也是InnoDB 存储引擎磁盘管理的最小单元，每个页的大小默
                认为 16KB。为了保证页的连续性，InnoDB 存储引擎每次从磁盘申请 4-5 个区。
            - 行(Row) : InnoDB 存储引擎是面向行的，也就是说数据是按行进行存放的，在每一行中除了定义表时
                所指定的字段以外，还包含两个隐藏字段(后面会详细介绍)。

    MyISAM
        1). 介绍
        MyISAM是MySQL早期的默认存储引擎
        2). 特点
            不支持事务，不支持外键
            支持表锁，不支持行锁
            访问速度快
        3). 文件
            xxx.sdi：存储表结构信息
            xxx.MYD: 存储数据
            xxx.MYI: 存储索引

    Memory
        1). 介绍
            Memory引擎的表数据时存储在内存中的，由于受到硬件问题、或断电问题的影响，只能将这些表作为
            临时表或缓存使用。
        2). 特点
            内存存放
            hash索引（默认）
        3).文件
            xxx.sdi：存储表结构信息

    区别及特点
        特点            InnoDB          MyISAM      Memory
        存储限制        64TB             有          有
        事务安全        支持             -            -
        锁机制          行锁             表锁         表锁
        B+tree索引      支持             支持         支持
        Hash索引        -                -           支持
        全文索引        支持(5.6版本之后)  支持         -
        空间使用        高                 低          N/A
        内存使用        高                低           中等
        批量插入速度    低                  高          高
        支持外键        支持                -           -

    面试题:
        InnoDB引擎与MyISAM引擎的区别 ?
        ①. InnoDB引擎, 支持事务, 而MyISAM不支持。
        ②. InnoDB引擎, 支持行锁和表锁, 而MyISAM仅支持表锁, 不支持行锁。
        ③. InnoDB引擎, 支持外键, 而MyISAM是不支持的。
        主要是上述三点区别，当然也可以从索引结构、存储限制等方面，更加深入的回答，具体参
        考如下官方文档：
        https://dev.mysql.com/doc/refman/8.0/en/innodb-introduction.html
        https://dev.mysql.com/doc/refman/8.0/en/myisam-storage-engine.html
