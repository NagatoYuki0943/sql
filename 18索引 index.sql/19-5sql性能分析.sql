1 SQL执行频率
    MySQL 客户端连接成功后，通过 show [session|global] status 命令可以提供服务器状态信
    息。通过如下指令，可以查看当前数据库的 insert、update、delete、select 的访问频次：

    -- session 是查看当前会话 ;
    -- global 是查询全局数据 ;
    show global status like 'Com_______';

    Com_delete: 删除次数
    Com_insert: 插入次数
    Com_select: 查询次数
    Com_update: 更新次数
    我们可以在当前数据库再执行几次查询操作，然后再次查看执行频次，看看 Com_select 参数会不会变化。

    通过上述指令，我们可以查看到当前数据库到底是以查询为主，还是以增删改为主，从而为数据
    库优化提供参考依据。 如果是以增删改为主，我们可以考虑不对其进行索引的优化。 如果是以
    查询为主，那么就要考虑对数据库的索引进行优化了。

    那么通过查询SQL的执行频次，我们就能够知道当前数据库到底是增删改为主，还是查询为主。 那假
    如说是以查询为主，我们又该如何定位针对于那些查询语句进行优化呢？ 次数我们可以借助于慢查询
    日志。
    接下来，我们就来介绍一下MySQL中的慢查询日志。


2 慢查询日志
    慢查询日志记录了所有执行时间超过指定参数（long_query_time，单位：秒，默认10秒）的所有
    SQL语句的日志。
    MySQL的慢查询日志默认没有开启，我们可以查看一下系统变量 slow_query_log。

        show variables like 'slow_query_log';
        +----------------+-------+
        | Variable_name  | Value |
        +----------------+-------+
        | slow_query_log | ON    |
        +----------------+-------+

    如果要开启慢查询日志，需要在MySQL的配置文件（/etc/my.cnf）中配置如下信息：
        # 开启MySQL慢日志查询开关
        slow_query_log=1
        # 设置慢日志的时间为2秒，SQL语句执行时间超过2秒，就会视为慢查询，记录慢查询日志
        long_query_time=2

    配置完毕之后，通过以下指令重新启动MySQL服务器进行测试，查看慢日志文件中记录的信息
    /var/lib/mysql/localhost-slow.log。
        systemctl restart mysqld
    然后，再次查看开关情况，慢查询日志就已经打开了。

    测试：
        A. 执行如下SQL语句 ：
        select * from tb_user; -- 这条SQL执行效率比较高, 执行耗时 0.00sec
        select count(*) from tb_sku; -- 由于tb_sku表中, 预先存入了1000w的记录, count一次,耗时
        13.35sec

        select * from students1,students2;
        1764 rows in set (1.85 sec)

        B. 检查慢查询日志 ：
        最终我们发现，在慢查询日志中，只会记录执行时间超多我们预设时间（2s）的SQL，执行较快的SQL
        是不会记录的。

        那这样，通过慢查询日志，就可以定位出执行效率比较低的SQL，从而有针对性的进行优化。


3 profile详情
    show profiles 能够在做SQL优化时帮助我们了解时间都耗费到哪里去了。通过have_profiling
    参数，能够看到当前MySQL是否支持profile操作：

        SELECT @@have_profiling;
        +------------------+
        | @@have_profiling |
        +------------------+
        | YES              |
        +------------------+

    可以看到，当前MySQL是支持 profile操作的，但是开关是关闭的。可以通过set语句在
        select @@profiling;
        +-------------+
        | @@profiling |
        +-------------+
        |           0 |
        +-------------+

        --session/global级别开启profiling：
        set [session/global] @@profiling = 1;
        set @@profiling = 1;


    开关已经打开了，接下来，我们所执行的SQL语句，都会被MySQL记录，并记录执行时间消耗到哪儿去
    了。 我们直接执行如下的SQL语句：
        select * from m_tb_user;
        select * from m_tb_user where id = 1;
        select * from m_tb_user where name = '白起';
        select count(*) from m_tb_user
        select count(*) from m_tb_sku;

    执行一系列的业务SQL的操作，然后通过如下指令查看指令的执行耗时：
        -- 查看每一条SQL的耗时基本情况
        show profiles;
        +----------+------------+---------------------------------------------+
        | Query_ID | Duration   | Query                                       |
        +----------+------------+---------------------------------------------+
        |        1 | 0.00008450 | SET @@profiling = 1                         |
        |        2 | 0.00012725 | select @@profiling                          |
        |        3 | 0.00011525 | select @@profiling                          |
        |        4 | 0.10735400 | select * from m_tb_user                     |
        |        5 | 0.00019925 | select * from m_tb_user where id = 1        |
        |        6 | 0.00539450 | select * from m_tb_user where name = '白起' |
        |        7 | 0.00017300 | select count(*) from m_tb_user              |
        |        8 | 0.00006150 | show profile for query query_id             |
        |        9 | 0.00148575 | select * from students1,students2           |
        +----------+------------+---------------------------------------------+

        -- 查看指定query_id的SQL语句各个阶段的耗时情况
        show profile for query query_id;

        show profile for query 9;
        +----------------------+----------+
        | Status               | Duration |
        +----------------------+----------+
        | starting             | 0.000056 |
        | checking permissions | 0.000004 |
        | checking permissions | 0.000002 |
        | Opening tables       | 0.000218 |
        | init                 | 0.000005 |
        | System lock          | 0.000007 |
        | optimizing           | 0.000002 |
        | statistics           | 0.000009 |
        | preparing            | 0.000027 |
        | executing            | 0.000002 |
        | Sending data         | 0.001107 |
        | end                  | 0.000005 |
        | query end            | 0.000016 |
        | closing tables       | 0.000006 |
        | freeing items        | 0.000015 |
        | cleaning up          | 0.000007 |
        +----------------------+----------+
        16 rows in set (0.03 sec)

        -- 查看指定query_id的SQL语句CPU的使用情况
        show profile cpu for query query_id;

        show profile cpu for query 9;
        +----------------------+----------+----------+------------+
        | Status               | Duration | CPU_user | CPU_system |
        +----------------------+----------+----------+------------+
        | starting             | 0.000056 | 0.000000 | 0.000000   |
        | checking permissions | 0.000004 | 0.000000 | 0.000000   |
        | checking permissions | 0.000002 | 0.000000 | 0.000000   |
        | Opening tables       | 0.000218 | 0.000000 | 0.000000   |
        | init                 | 0.000005 | 0.000000 | 0.000000   |
        | System lock          | 0.000007 | 0.000000 | 0.000000   |
        | optimizing           | 0.000002 | 0.000000 | 0.000000   |
        | statistics           | 0.000009 | 0.000000 | 0.000000   |
        | preparing            | 0.000027 | 0.000000 | 0.000000   |
        | executing            | 0.000002 | 0.000000 | 0.000000   |
        | Sending data         | 0.001107 | 0.000000 | 0.000000   |
        | end                  | 0.000005 | 0.000000 | 0.000000   |
        | query end            | 0.000016 | 0.000000 | 0.000000   |
        | closing tables       | 0.000006 | 0.000000 | 0.000000   |
        | freeing items        | 0.000015 | 0.000000 | 0.000000   |
        | cleaning up          | 0.000007 | 0.000000 | 0.000000   |
        +----------------------+----------+----------+------------+
        16 rows in set (0.05 sec)


4 explain
    explain 或者 DESC命令获取 MySQL 如何执行 select 语句的信息，包括在 select 语句执行
    过程中表如何连接和连接的顺序。
    语法:
        -- 直接在select语句之前加上关键字 explain / desc
        explain select 字段列表 from 表名 where 条件 ;

    explain 执行计划中各个字段的含义:

    字段
        id
            select查询的序列号，表示查询中执行select子句或者是操作表的顺序
            (id相同，执行顺序从上到下；id不同，值越大，越先执行)。

        select_type
            表示 SELECT 的类型，常见的取值有 SIMPLE（简单表，即不使用表连接
            或者子查询）、PRIMARY（主查询，即外层的查询）、
            UNION（UNION 中的第二个或者后面的查询语句）、
            SUBQUERY（SELECT/WHERE之后包含了子查询）等

        type
            表示连接类型，性能由好到差的连接类型为 NULL、system、const、eq_ref、ref、range、 index、all 。
                system 查询系统表
                const  查询有unique的键
                ref    查询没有unique的键
                index  用了索引但是遍历全部索引
                all    全表扫描

        possible_key
            显示可能应用在这张表上的索引，一个或多个。

        key
            实际使用的索引，如果为NULL，则没有使用索引。

        key_len
            表示索引中使用的字节数， 该值为索引字段最大可能长度，并非实际使用长
            度，在不损失精确性的前提下， 长度越短越好 。

        rows
            MySQL认为必须要执行查询的行数，在innodb引擎的表中，是一个估计值，
            可能并不总是准确的。

        filtered
            表示返回结果的行数占需读取行数的百分比， filtered 的值越大越好。

    示例:
        查询所有学生的选课情况, 展示出学生名称, 学号, 课程名称   多对多中间表查询
            select s.name,s.no,c.name from m_student s,m_course c,m_student_course sc where s.id=sc.studentid and c.id=sc.courseid;
            +--------+------------+--------+
            | name   | no         | name   |
            +--------+------------+--------+
            | 黛绮丝 | 2000100101 | Java   |
            | 黛绮丝 | 2000100101 | PHP    |
            | 黛绮丝 | 2000100101 | MySQL  |
            | 谢逊   | 2000100102 | PHP    |
            | 谢逊   | 2000100102 | MySQL  |
            | 殷天正 | 2000100103 | Hadoop |
            +--------+------------+--------+

            explain select s.name,s.no,c.name from m_student s,m_course c,m_student_course sc where s.id=sc.studentid and c.id=sc.courseid;
            +----+-------------+-------+------------+--------+--------------------------+---------+---------+----------------+------+----------+----------------------------------------------------+
            | id | select_type | table | partitions | type   | possible_keys            | key     | key_len | ref            | rows | filtered | Extra                                              |
            +----+-------------+-------+------------+--------+--------------------------+---------+---------+----------------+------+----------+----------------------------------------------------+
            |  1 | SIMPLE      | s     | NULL       | ALL    | PRIMARY                  | NULL    | NULL    | NULL           |    4 |   100.00 | NULL                                               |
            |  1 | SIMPLE      | sc    | NULL       | ALL    | fk_courseid,fk_studentid | NULL    | NULL    | NULL           |    6 |    33.33 | Using where; Using join buffer (Block Nested Loop) |
            |  1 | SIMPLE      | c     | NULL       | eq_ref | PRIMARY                  | PRIMARY | 4       | mb.sc.courseid |    1 |   100.00 | NULL                                               |
            +----+-------------+-------+------------+--------+--------------------------+---------+---------+----------------+------+----------+----------------------------------------------------+


        查询选修了mysql的学生信息
        表: student , course , student_course
            select * from m_student where id in
                (select studentid from m_student_course where courseid = (select id from m_course where name='mysql'));
            select s.* from m_student s,m_student_course sc
                where (s.id=sc.studentid) and sc.courseid=(select id from m_course c where c.name ='mysql');
            +----+--------+------------+
            | id | name   | no         |
            +----+--------+------------+
            |  1 | 黛绮丝 | 2000100101 |
            |  2 | 谢逊   | 2000100102 |
            +----+--------+------------+

            explain select * from m_student where id in
                (select studentid from m_student_course where courseid = (select id from m_course where name='mysql'));
            +----+--------------+------------------+------------+--------+--------------------------+-------------+---------+-----------------------+------+----------+-------------+
            | id | select_type  | table            | partitions | type   | possible_keys            | key         | key_len | ref                   | rows | filtered | Extra       |
            +----+--------------+------------------+------------+--------+--------------------------+-------------+---------+-----------------------+------+----------+-------------+
            |  1 | PRIMARY      | <subquery2>      | NULL       | ALL    | NULL                     | NULL        | NULL    | NULL                  | NULL |   100.00 | NULL        |
            |  1 | PRIMARY      | m_student        | NULL       | eq_ref | PRIMARY                  | PRIMARY     | 4       | <subquery2>.studentid |    1 |   100.00 | NULL        |
            |  2 | MATERIALIZED | m_student_course | NULL       | ref    | fk_courseid,fk_studentid | fk_courseid | 4       | const                 |    2 |   100.00 | Using where |
            |  3 | SUBQUERY     | m_course         | NULL       | ALL    | NULL                     | NULL        | NULL    | NULL                  |    4 |    25.00 | Using where |
            +----+--------------+------------------+------------+--------+--------------------------+-------------+---------+-----------------------+------+----------+-------------+
            4 rows in set (0.05 sec)

            explain select s.* from m_student s,m_student_course sc
                    where (s.id=sc.studentid) and sc.courseid=(select id from m_course c where c.name ='mysql');
            +----+-------------+-------+------------+--------+--------------------------+-------------+---------+-----------------+------+----------+-------------+
            | id | select_type | table | partitions | type   | possible_keys            | key         | key_len | ref             | rows | filtered | Extra       |
            +----+-------------+-------+------------+--------+--------------------------+-------------+---------+-----------------+------+----------+-------------+
            |  1 | PRIMARY     | sc    | NULL       | ref    | fk_courseid,fk_studentid | fk_courseid | 4       | const           |    2 |   100.00 | Using where |
            |  1 | PRIMARY     | s     | NULL       | eq_ref | PRIMARY                  | PRIMARY     | 4       | mb.sc.studentid |    1 |   100.00 | NULL        |
            |  2 | SUBQUERY    | c     | NULL       | ALL    | NULL                     | NULL        | NULL    | NULL            |    4 |    25.00 | Using where |
            +----+-------------+-------+------------+--------+--------------------------+-------------+---------+-----------------+------+----------+-------------+
            3 rows in set (0.02 sec)


        type示例
            --查询唯一键出现const type
            explain select * from m_tb_user where phone='17799990000';
            +----+-------------+-----------+------------+-------+----------------+----------------+---------+-------+------+----------+-------+
            | id | select_type | table     | partitions | type  | possible_keys  | key            | key_len | ref   | rows | filtered | Extra |
            +----+-------------+-----------+------------+-------+----------------+----------------+---------+-------+------+----------+-------+
            |  1 | SIMPLE      | m_tb_user | NULL       | const | idx_user_phone | idx_user_phone | 46      | const |    1 |   100.00 | NULL  |
            +----+-------------+-----------+------------+-------+----------------+----------------+---------+-------+------+----------+-------+

            --查询不唯一键出现ref type
            explain select * from m_tb_user where name = '姜子牙';
            +----+-------------+-----------+------------+------+---------------+---------------+---------+-------+------+----------+-------+
            | id | select_type | table     | partitions | type | possible_keys | key           | key_len | ref   | rows | filtered | Extra |
            +----+-------------+-----------+------------+------+---------------+---------------+---------+-------+------+----------+-------+
            |  1 | SIMPLE      | m_tb_user | NULL       | ref  | idx_user_name | idx_user_name | 202     | const |    1 |   100.00 | NULL  |
            +----+-------------+-----------+------------+------+---------------+---------------+---------+-------+------+----------+-------+

