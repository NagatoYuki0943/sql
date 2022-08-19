1 介绍 (PDF)
    行级锁，每次操作锁住对应的行数据。锁定粒度最小，发生锁冲突的概率最低，并发度最高。应用在
    InnoDB存储引擎中。
    InnoDB的数据是基于索引组织的，行锁是通过对索引上的索引项加锁来实现的，而不是对记录加的
    锁。对于行级锁，主要分为以下三类：

    - 行锁（Record Lock）：     锁定单个行记录的锁，防止其他事务对此行进行update和delete。在RC、RR隔离级别下都支持。
    - 间隙锁（Gap Lock）：      锁定索引记录间隙（不含该记录），确保索引记录间隙不变，防止其他事务在这个间隙进行insert，产生幻读。在RR隔离级别下都支持。
                               比如6~18之间,锁定中间的值
    - 临键锁（Next-Key Lock）： 行锁和间隙锁组合，同时锁住数据，并锁住数据前面的间隙Gap。在RR隔离级别下支持。


2 行锁
    1). 介绍
        InnoDB实现了以下两种类型的行锁：
            - 共享锁（S）：允许一个事务去读一行，阻止其他事务获得相同数据集的排它锁。
                          共享锁和共享锁兼容,和排他锁排斥

            - 排他锁（X）：允许获取排他锁的事务更新数据，阻止其他事务获得相同数据集的共享锁和排他锁。

        两种行锁的兼容情况如下
                            请求所类型  S(共享锁)   X(排他锁)
            当前锁类型────┬─ S(共享锁)     兼容        冲突
                         └─ X(排他锁)     冲突        冲突


        常见的SQL语句，在执行时，所加的行锁如下：
            SQL                                行锁类型     说明
            INSERT ...                         排他锁       自动加锁
            UPDATE ...                         排他锁       自动加锁
            DELETE ...                         排他锁       自动加锁
            SELECT（正常）                      不加任何锁
            SELECT ... LOCK IN SHARE MODE      共享锁       需要手动在SELECT之后加LOCK IN SHARE MODE
            SELECT ... FOR UPDATE              排他锁       需要手动在SELECT之后加FOR UPDATE

    2). 演示
        默认情况下，InnoDB在 REPEATABLE READ事务隔离级别运行，InnoDB使用 next-key 锁进行搜
        索和索引扫描，以防止幻读。
            - 针对唯一索引进行检索时，对已存在的记录进行等值匹配时，将会自动优化为行锁。
            - InnoDB的行锁是针对于索引加的锁，不通过索引条件检索数据，那么InnoDB将对表中的所有记录加锁，此时 就会升级为表锁。

        可以通过以下SQL，查看意向锁及行锁的加锁情况：
            select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;

        示例演示
        数据准备:
            CREATE TABLE `m_stu` (
                `id` int NOT NULL PRIMARY KEY AUTO_INCREMENT,
                `name` varchar(255) DEFAULT NULL,
                `age` int NOT NULL
            ) ENGINE = InnoDB CHARACTER SET = utf8mb4;
            INSERT INTO `m_stu` VALUES (1, 'tom', 1);
            INSERT INTO `m_stu` VALUES (3, 'cat', 3);
            INSERT INTO `m_stu` VALUES (8, 'rose', 8);
            INSERT INTO `m_stu` VALUES (11, 'jetty', 11);
            INSERT INTO `m_stu` VALUES (19, 'lily', 19);
            INSERT INTO `m_stu` VALUES (25, 'luci', 25);

                select * from m_stu;
                +----+-------+-----+
                | id | name  | age |
                +----+-------+-----+
                |  1 | tom   |   1 |
                |  3 | cat   |   3 |
                |  8 | rose  |   8 |
                | 11 | jetty |  11 |
                | 19 | lily  |  19 |
                | 25 | luci  |  25 |
                +----+-------+-----+
                6 rows in set (0.00 sec)

                show index from m_stu;
                +-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
                | Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible |
                +-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
                | m_stu |          0 | PRIMARY  |            1 | id          | A         |           6 |     NULL |   NULL |      | BTREE      |         |               | YES     |
                +-------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+


            演示行锁的时候，我们就通过上面这张表来演示一下。
            A. 普通的select语句，执行时，不会加锁。
            左侧:
                begin;
                select * from m_stu where id=1;
                +----+------+-----+
                | id | name | age |
                +----+------+-----+
                |  1 | tom  |   1 |
                +----+------+-----+

                commit;

            右侧:
                begin;
                select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;
                Empty set (0.38 sec)    --没有锁

                select * from m_stu where id=1;
                +----+------+-----+
                | id | name | age |
                +----+------+-----+
                |  1 | tom  |   1 |
                +----+------+-----+

                commit;


            B. select...lock in share mode，加共享锁，共享锁与共享锁之间兼容。

                共享锁与排他锁之间互斥。

                客户端一获取的是id为1这行的共享锁，客户端二是可以获取id为3这行的排它锁的，因为不是同一行
                数据。 而如果客户端二想获取id为1这行的排他锁，会处于阻塞状态，以为共享锁与排他锁之间互斥。

            左侧:
                begin
                select * from m_stu where id=1 lock in share mode;  -- 加共享锁
                +----+------+-----+
                | id | name | age |
                +----+------+-----+
                |  1 | tom  |   1 |
                +----+------+-----+
                commit;

            右侧:
                select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;
                +---------------+-------------+------------+-----------+-----------+-----------+
                | object_schema | object_name | index_name | lock_type | lock_mode | lock_data |
                +---------------+-------------+------------+-----------+-----------+-----------+
                | mb            | m_stu       | NULL       | TABLE     | IS        | NULL      |
                | mb            | m_stu       | PRIMARY    | RECORD    | S         | 1         |  -- S 共享锁
                +---------------+-------------+------------+-----------+-----------+-----------+

                begin;
                select * from m_stu where id=1 lock in share mode;  -- 也加共享锁,不冲突
                +----+------+-----+
                | id | name | age |
                +----+------+-----+
                |  1 | tom  |   1 |
                +----+------+-----+

                select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;
                +---------------+-------------+------------+-----------+-----------+-----------+
                | object_schema | object_name | index_name | lock_type | lock_mode | lock_data |
                +---------------+-------------+------------+-----------+-----------+-----------+
                | mb            | m_stu       | NULL       | TABLE     | IS        | NULL      |
                | mb            | m_stu       | PRIMARY    | RECORD    | S         | 1         |
                | mb            | m_stu       | NULL       | TABLE     | IS        | NULL      |
                | mb            | m_stu       | PRIMARY    | RECORD    | S         | 1         |
                +---------------+-------------+------------+-----------+-----------+-----------+

                commit;
                Query OK, 0 rows affected (0.00 sec)

                select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;   -- 提交之后自己的锁就没了
                +---------------+-------------+------------+-----------+-----------+-----------+
                | object_schema | object_name | index_name | lock_type | lock_mode | lock_data |
                +---------------+-------------+------------+-----------+-----------+-----------+
                | mb            | m_stu       | NULL       | TABLE     | IS        | NULL      |
                | mb            | m_stu       | PRIMARY    | RECORD    | S         | 1         |
                +---------------+-------------+------------+-----------+-----------+-----------+

                begin;
                update m_stu set name='Java' where id=1;  --卡住,排他锁和共享锁互斥
                commit;


            C. 排它锁与排他锁之间互斥
                当客户端一，执行update语句，会为id为1的记录加排他锁； 客户端二，如果也执行update语句更
                新id为1的数据，也要为id为1的数据加排他锁，但是客户端二会处于阻塞状态，因为排他锁之间是互
                斥的。 直到客户端一，把事务提交了，才会把这一行的行锁释放，此时客户端二，解除阻塞。
            左侧:
                begin;

                update m_stu set name='Java' where id=1;
                Query OK, 1 row affected (0.00 sec)
                Rows matched: 1  Changed: 1  Warnings: 0

                commit;

            右侧:
                begin;

                update m_stu set name='Java' where id=1; --卡住
                Query OK, 0 rows affected (48.92 sec)    -- 左侧提交才会插入
                Rows matched: 1  Changed: 0  Warnings: 0

                commit;


            D. 无索引行锁升级为表锁
                m_stu表中数据如下:
                我们在两个客户端中执行如下操作:

                在客户端一中，开启事务，并执行update语句，更新name为Lily的数据，也就是id为19的记录 。
                然后在客户端二中更新id为3的记录，却不能直接执行，会处于阻塞状态，为什么呢？

                原因就是因为此时，客户端一，根据name字段进行更新时，name字段是没有索引的，如果没有索引，
                此时行锁会升级为表锁(因为行锁是对索引项加的锁，而name没有索引)。

                接下来，我们再针对name字段建立索引，索引建立之后，再次做一个测试：

                此时我们可以看到，客户端一，开启事务，然后依然是根据name进行更新。而客户端二，在更新id为3
                的数据时，更新成功，并未进入阻塞状态。 这样就说明，我们根据索引字段进行更新操作，就可以避
                免行锁升级为表锁的情况。

            左侧:
                begin;

                mysql> update m_stu set name='Lei' where name='lily';
                Query OK, 1 row affected (0.32 sec)
                Rows matched: 1  Changed: 1  Warnings: 0

                commit;

            右侧:
                begin;

                update m_stu set name='PHP' where id=3;   -- 卡住,根据name字段进行更新时，name字段是没有索引的，如果没有索引，此时行锁会升级为表锁
                Query OK, 1 row affected (1 min 5.44 sec) -- 左侧提交才会插入
                Rows matched: 1  Changed: 1  Warnings: 0

                commit;

            --给名字创建索引
            create index idx_name on m_stu(name);

            左侧:
                begin;

                update m_stu set name='Lei' where name='lily';
                Query OK, 0 rows affected (0.00 sec)
                Rows matched: 0  Changed: 0  Warnings: 0

                commit;

            右侧:
                begin;

                update m_stu set name='PHP' where id=3; -- 不会卡住,因为上面给name添加索引了
                Query OK, 0 rows affected (0.00 sec)
                Rows matched: 1  Changed: 0  Warnings: 0

                commit;


3 间隙锁&临键锁
    默认情况下，InnoDB在 REPEATABLE READ事务隔离级别运行，InnoDB使用 next-key 锁进行搜
    索和索引扫描，以防止幻读。
        - 索引上的等值查询(唯一索引)，给不存在的记录加锁时, 优化为间隙锁 。
        - 索引上的等值查询(非唯一普通索引)，向右遍历时最后一个值不满足查询需求时，next-keylock 退化为间隙锁。
        - 索引上的范围查询(唯一索引)，会访问到不满足条件的第一个值为止。

    注意：间隙锁唯一目的是防止其他事务插入间隙。间隙锁可以共存，一个事务采用的间隙锁不会阻止另一个事务在同一间隙上采用间隙锁。

    示例演示
        A. 索引上的等值查询(唯一索引)，给不存在的记录加锁时, 优化为间隙锁 。

            select * from m_stu;
            +----+-------+-----+
            | id | name  | age |
            +----+-------+-----+
            |  1 | Java  |   1 |
            |  3 | PHP   |   3 |
            |  8 | rose  |   8 |
            | 11 | jetty |  11 |
            | 19 | Lei   |  19 |
            | 25 | luci  |  25 |
            +----+-------+-----+

        左侧:
            begin;

            update m_stu set age=10 where id=5;     -- 不存在 id=5 的数据
            Query OK, 0 rows affected (0.00 sec)
            Rows matched: 0  Changed: 0  Warnings: 0

            commit;

        右侧:
            select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;
            +---------------+-------------+------------+-----------+-----------+-----------+
            | object_schema | object_name | index_name | lock_type | lock_mode | lock_data |
            +---------------+-------------+------------+-----------+-----------+-----------+
            | mb            | m_stu       | NULL       | TABLE     | IX        | NULL      |
            | mb            | m_stu       | PRIMARY    | RECORD    | X,GAP     | 8         |  -- X 排他锁  GAP 间隙锁 local_data是8之前的间隙,就是3~8不包括8的信息
            +---------------+-------------+------------+-----------+-----------+-----------+

            begin;

            insert into m_stu values(7, 'BOB', 7);  -- 卡住,因为有间隙锁
            Query OK, 1 row affected (36.07 sec)    -- 左侧提交才会插入

            commit;

            select * from m_stu;
            +----+-------+-----+
            | id | name  | age |
            +----+-------+-----+
            |  1 | Java  |   1 |
            |  3 | PHP   |   3 |
            |  7 | BOB   |   7 |    --两边都提交后就看到新的第7条了
            |  8 | rose  |   8 |
            | 11 | jetty |  11 |
            | 19 | Lei   |  19 |
            | 25 | luci  |  25 |
            +----+-------+-----+


        B. 索引上的等值查询(非唯一普通索引)，向右遍历时最后一个值不满足查询需求时，next-key lock 退化为间隙锁。

            介绍分析一下：
            我们知道InnoDB的B+树索引，叶子节点是有序的双向链表。 假如，我们要根据这个二级索引查询值
            为18的数据，并加上共享锁，我们是只锁定18这一行就可以了吗？ 并不是，因为是非唯一索引，这个
            结构中可能有多个18的存在，所以，在加锁时会继续往后找，找到一个不满足条件的值（当前案例中也
            就是29）。此时会对18加临键锁，并对29之前的间隙加锁。

            select * from m_stu;
            +----+-------+-----+
            | id | name  | age |
            +----+-------+-----+
            |  1 | Java  |   1 |
            |  3 | PHP   |   3 |
            |  7 | BOB   |   7 |
            |  8 | rose  |   8 |
            | 11 | jetty |  11 |
            | 19 | Lei   |  19 |
            | 25 | luci  |  25 |
            +----+-------+-----+

            create index idx_stu_age on m_stu(age); -- 添加不唯一索引
            Query OK, 0 rows affected (0.80 sec)
            Records: 0  Duplicates: 0  Warnings: 0

            show index from m_stu;
            +-------+------------+-------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
            | Table | Non_unique | Key_name    | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible |
            +-------+------------+-------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
            | m_stu |          0 | PRIMARY     |            1 | id          | A         |           6 |     NULL |   NULL |      | BTREE      |         |               | YES     |
            | m_stu |          1 | idx_name    |            1 | name        | A         |           6 |     NULL |   NULL | YES  | BTREE      |         |               | YES     |
            | m_stu |          1 | idx_stu_age |            1 | age         | A         |           7 |     NULL |   NULL |      | BTREE      |         |               | YES     |
            +-------+------------+-------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+

            左侧:
                begin;

                select * from m_stu where age=3 lock in share mode;  -- 加共享锁
                +----+------+-----+
                | id | name | age |
                +----+------+-----+
                |  3 | PHP  |   3 |
                +----+------+-----+
                1 row in set (0.00 sec)

                commit;

            右侧:
                select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;
                +---------------+-------------+-------------+-----------+-----------+-----------+
                | object_schema | object_name | index_name  | lock_type | lock_mode | lock_data |
                +---------------+-------------+-------------+-----------+-----------+-----------+
                | mb            | m_stu       | NULL        | TABLE     | IS        | NULL      |
                | mb            | m_stu       | idx_stu_age | RECORD    | S         | 3, 3      |   -- S 共享锁 3,3
                | mb            | m_stu       | PRIMARY     | RECORD    | S         | 3         |   -- 第一个3是对现有数据加行锁,第二个3是对3到3之前的数据锁住(包括3)是邻间锁
                | mb            | m_stu       | idx_stu_age | RECORD    | S,GAP     | 7, 7      |   -- GAP 间隙锁,7~3之间加间隙锁 因为age是非唯一索引,防止出现幻读现象
                +---------------+-------------+-------------+-----------+-----------+-----------+

                commit;


        C. 索引上的范围查询(唯一索引) --会访问到不满足条件的第一个值为止。

            查询的条件为id>=19，并添加共享锁。 此时我们可以根据数据库表中现有的数据，将数据分为三个部
            分：
                [19]
                (19,25]
                (25,+∞]
            所以数据库数据在加锁是，就是将19加了行锁，25的临键锁（包含25及25之前的间隙），正无穷的临
            键锁(正无穷及之前的间隙)。

            左侧:
                begin;

                select * from m_stu where id >= 19 lock in share mode;
                +----+------+-----+
                | id | name | age |
                +----+------+-----+
                | 19 | Lei  |  19 |
                | 25 | luci |  25 |
                +----+------+-----+

                commit;

            右侧:
                select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;
                +---------------+-------------+------------+-----------+-----------+------------------------+
                | object_schema | object_name | index_name | lock_type | lock_mode | lock_data              |
                +---------------+-------------+------------+-----------+-----------+------------------------+
                | mb            | m_stu       | NULL       | TABLE     | IS        | NULL                   |
                | mb            | m_stu       | PRIMARY    | RECORD    | S         | 19                     | --19记录加行锁
                | mb            | m_stu       | PRIMARY    | RECORD    | S         | supremum pseudo-record | --25之后到正无穷加邻间锁
                | mb            | m_stu       | PRIMARY    | RECORD    | S         | 25                     | --临间锁,25之前到19加临间锁
                +---------------+-------------+------------+-----------+-----------+------------------------+
