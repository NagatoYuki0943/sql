MySQL的排序，有两种方式：
    Using filesort : 通过表的索引或全表扫描，读取满足条件的数据行，然后在排序缓冲区sort
        buffer中完成排序操作，所有不是通过索引直接返回排序结果的排序都叫 FileSort 排序。

    Using index : 通过有序索引顺序扫描直接返回有序数据，这种情况即为 using index，不需要
        额外排序，操作效率高。
        对于以上的两种排序方式，Using index的性能高，而Using filesort的性能低，我们在优化排序
        操作时，尽量要优化为 Using index。


接下来，我们来做一个测试：
    A. 数据准备
        把之前测试时，为m_tb_user表所建立的部分索引直接删除掉

        drop index idx_user_phone on m_tb_user;
        drop index idx_user_phone_name on m_tb_user;
        drop index idx_user_name on m_tb_user;
        show index from m_tb_user;
        +-----------+------------+----------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
        | Table     | Non_unique | Key_name             | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible |
        +-----------+------------+----------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
        | m_tb_user |          0 | PRIMARY              |            1 | id          | A         |          24 | NULL     | NULL   |      | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_pro_age_sta |            1 | profession  | A         |          16 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_pro_age_sta |            2 | age         | A         |          22 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_pro_age_sta |            3 | status      | A         |          24 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_email_5          |            1 | email       | A         |          23 |        5 | NULL   | YES  | BTREE      |         |               | YES     |
        +-----------+------------+----------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+

    B. 执行排序SQL
        explain select id,age,phone from m_tb_user order by age;        --extra Using filesort
        +----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+----------------+
        | id | select_type | table     | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra          |
        +----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+----------------+
        |  1 | SIMPLE      | m_tb_user | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   24 |   100.00 | Using filesort |
        +----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+----------------+

        explain select id,age,phone from m_tb_user order by age, phone; --extra Using filesort
        +----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+----------------+
        | id | select_type | table     | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra          |
        +----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+----------------+
        |  1 | SIMPLE      | m_tb_user | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   24 |   100.00 | Using filesort |
        +----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+----------------+

        由于 age, phone 都没有索引，所以此时再排序时，出现Using filesort， 排序性能较低。

    C. 创建索引
        -- 创建索引
        create index idx_user_age_phone_aa on m_tb_user(age,phone);
        show index from m_tb_user;
        +-----------+------------+-----------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
        | Table     | Non_unique | Key_name              | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible |
        +-----------+------------+-----------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
        | m_tb_user |          0 | PRIMARY               |            1 | id          | A         |          24 | NULL     | NULL   |      | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_pro_age_sta  |            1 | profession  | A         |          16 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_pro_age_sta  |            2 | age         | A         |          22 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_pro_age_sta  |            3 | status      | A         |          24 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_email_5           |            1 | email       | A         |          23 |        5 | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_age_phone_aa |            1 | age         | A         |          19 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_age_phone_aa |            2 | phone       | A         |          24 | NULL     | NULL   |      | BTREE      |         |               | YES     |
        +-----------+------------+-----------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+

    D. 创建索引后，根据age, phone进行升序排序
        explain select id,age,phone from m_tb_user order by age;            --extra Using index
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-------------+
        | id | select_type | table     | partitions | type  | possible_keys | key                   | key_len | ref  | rows | filtered | Extra       |
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-------------+
        |  1 | SIMPLE      | m_tb_user | NULL       | index | NULL          | idx_user_age_phone_aa | 48      | NULL |   24 |   100.00 | Using index |
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-------------+

        explain select id,age,phone from m_tb_user order by age, phone;     --extra Using index
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-------------+
        | id | select_type | table     | partitions | type  | possible_keys | key                   | key_len | ref  | rows | filtered | Extra       |
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-------------+
        |  1 | SIMPLE      | m_tb_user | NULL       | index | NULL          | idx_user_age_phone_aa | 48      | NULL |   24 |   100.00 | Using index |
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-------------+

    建立索引之后，再次进行排序查询，就由原来的Using filesort， 变为了 Using index，性能就是比较高的了。


    E. 创建索引后，根据age, phone进行降序排
        explain select id,age,phone from m_tb_user order by age desc, phone desc;   --extra Backward index scan; Using index
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+----------------------------------+
        | id | select_type | table     | partitions | type  | possible_keys | key                   | key_len | ref  | rows | filtered | Extra                            |
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+----------------------------------+
        |  1 | SIMPLE      | m_tb_user | NULL       | index | NULL          | idx_user_age_phone_aa | 48      | NULL |   24 |   100.00 | Backward index scan; Using index |
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+----------------------------------+

        也出现 Using index， 但是此时Extra中出现了 Backward index scan，这个代表反向扫描索
        引，因为在MySQL中我们创建的索引，默认索引的叶子节点是从小到大排序的，而此时我们查询排序
        时，是从大到小，所以，在扫描时，就是反向扫描，就会出现 Backward index scan。 在
        MySQL8版本中，支持降序索引，我们也可以创建降序索引。


    F. 根据phone，age进行升序排序，phone在前，age在后。     --Using filesort 性能不好
        explain select id,age,phone from m_tb_user order by phone, age;             --extra Using index; Using filesort
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-----------------------------+
        | id | select_type | table     | partitions | type  | possible_keys | key                   | key_len | ref  | rows | filtered | Extra                       |
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-----------------------------+
        |  1 | SIMPLE      | m_tb_user | NULL       | index | NULL          | idx_user_age_phone_aa | 48      | NULL |   24 |   100.00 | Using index; Using filesort |
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-----------------------------+

        排序时,也需要满足最左前缀法则,否则也会出现 filesort。因为在创建索引的时候， age是第一个
        字段，phone是第二个字段，所以排序时，也就该按照这个顺序来，否则就会出现 Using
        filesort。


    G. 根据age, phone进行降序一个升序，一个降序
        explain select id,age,phone from m_tb_user order by age asc, phone desc;    --extra Using index; Using filesort
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-----------------------------+
        | id | select_type | table     | partitions | type  | possible_keys | key                   | key_len | ref  | rows | filtered | Extra                       |
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-----------------------------+
        |  1 | SIMPLE      | m_tb_user | NULL       | index | NULL          | idx_user_age_phone_aa | 48      | NULL |   24 |   100.00 | Using index; Using filesort |
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-----------------------------+

        因为创建索引时，如果未指定顺序，默认都是按照升序排序的，而查询时，一个升序，一个降序，此时
        就会出现Using filesort。

        为了解决上述的问题，我们可以创建一个索引，这个联合索引中 age 升序排序，phone 倒序排序。


    H. 创建联合索引(age 升序排序，phone 倒序排序)
        create index idx_user_age_phone_ad on m_tb_user(age asc, phone desc);
        show index from m_tb_user;
        +-----------+------------+-----------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
        | Table     | Non_unique | Key_name              | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible |
        +-----------+------------+-----------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
        | m_tb_user |          0 | PRIMARY               |            1 | id          | A         |          24 | NULL     | NULL   |      | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_pro_age_sta  |            1 | profession  | A         |          16 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_pro_age_sta  |            2 | age         | A         |          22 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_pro_age_sta  |            3 | status      | A         |          24 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_email_5           |            1 | email       | A         |          23 |        5 | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_age_phone_aa |            1 | age         | A         |          19 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_age_phone_aa |            2 | phone       | A         |          24 | NULL     | NULL   |      | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_age_phone_ad |            1 | age         | A         |          19 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_age_phone_ad |            2 | phone       | D         |          24 | NULL     | NULL   |      | BTREE      |         |               | YES     |
        +-----------+------------+-----------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+


    I. 然后再次执行如下SQL
        explain select id,age,phone from m_tb_user order by age asc, phone desc;    --extra Using index;
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-------------+
        | id | select_type | table     | partitions | type  | possible_keys | key                   | key_len | ref  | rows | filtered | Extra       |
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-------------+
        |  1 | SIMPLE      | m_tb_user | NULL       | index | NULL          | idx_user_age_phone_ad | 48      | NULL |   24 |   100.00 | Using index |
        +----+-------------+-----------+------------+-------+---------------+-----------------------+---------+------+------+----------+-------------+

        升序/降序联合索引结构图示: (PDF)


由上述的测试,我们得出order by优化原则:
    A. 根据排序字段建立合适的索引，多字段排序时，也遵循最左前缀法则。

    B. 尽量使用覆盖索引。

    C. 多字段排序, 一个升序一个降序，此时需要注意联合索引在创建时的规则（ASC/DESC）。

    D. 如果不可避免的出现filesort，大数据量排序时，可以适当增大排序缓冲区大小sort_buffer_size(默认256k)。

        show variables like 'sort_buffer_size';
        +------------------+--------+
        | Variable_name    | Value  |
        +------------------+--------+
        | sort_buffer_size | 262144 |
        +------------------+--------+
