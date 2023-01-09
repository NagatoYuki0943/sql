分组操作，我们主要来看看索引对于分组操作的影响。
    首先我们先将 m_tb_user 表的索引全部删除掉。
        drop index idx_user_pro_age_sta on m_tb_user;
        drop index idx_email_5 on m_tb_user;
        drop index idx_user_age_phone_aa on m_tb_user;
        drop index idx_user_age_phone_ad on m_tb_user;
        show index from m_tb_user;
        +-----------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
        | Table     | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible |
        +-----------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
        | m_tb_user |          0 | PRIMARY  |            1 | id          | A         |          24 | NULL     | NULL   |      | BTREE      |         |               | YES     |
        +-----------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+


    接下来，在没有索引的情况下，执行如下SQL，查询执行计划：
        explain select profession, count(*) from m_tb_user group by profession ;
        +----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+-----------------+
        | id | select_type | table     | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra           |
        +----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+-----------------+
        |  1 | SIMPLE      | m_tb_user | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   24 |   100.00 | Using temporary |
        +----+-------------+-----------+------------+------+---------------+------+---------+------+------+----------+-----------------+


    然后，我们在针对于 profession， age， status 创建一个联合索引。
        create index idx_user_pro_age_sta on m_tb_user(profession, age, status);
        show index from m_tb_user;
        +-----------+------------+----------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
        | Table     | Non_unique | Key_name             | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible |
        +-----------+------------+----------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
        | m_tb_user |          0 | PRIMARY              |            1 | id          | A         |          24 | NULL     | NULL   |      | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_pro_age_sta |            1 | profession  | A         |          16 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_pro_age_sta |            2 | age         | A         |          22 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        | m_tb_user |          1 | idx_user_pro_age_sta |            3 | status      | A         |          24 | NULL     | NULL   | YES  | BTREE      |         |               | YES     |
        +-----------+------------+----------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+


    紧接着，再执行前面相同的SQL查看执行计划。
        explain select profession, count(*) from m_tb_user group by profession;
        +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+-------------+
        | id | select_type | table     | partitions | type  | possible_keys        | key                  | key_len | ref  | rows | filtered | Extra       |
        +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+-------------+
        |  1 | SIMPLE      | m_tb_user | NULL       | index | idx_user_pro_age_sta | idx_user_pro_age_sta | 54      | NULL |   24 |   100.00 | Using index |
        +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+-------------+

        explain select profession, age, count(*) from m_tb_user group by profession, age;
        +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+-------------+
        | id | select_type | table     | partitions | type  | possible_keys        | key                  | key_len | ref  | rows | filtered | Extra       |
        +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+-------------+
        |  1 | SIMPLE      | m_tb_user | NULL       | index | idx_user_pro_age_sta | idx_user_pro_age_sta | 54      | NULL |   24 |   100.00 | Using index |
        +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+-------------+

        explain select profession, age, status, count(*) from m_tb_user group by profession, age, status;
        +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+-------------+
        | id | select_type | table     | partitions | type  | possible_keys        | key                  | key_len | ref  | rows | filtered | Extra       |
        +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+-------------+
        |  1 | SIMPLE      | m_tb_user | NULL       | index | idx_user_pro_age_sta | idx_user_pro_age_sta | 54      | NULL |   24 |   100.00 | Using index |
        +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+-------------+

    再执行如下的分组查询SQL，查看执行计划：     --Using temporary 性能不好
    explain select age, status, count(*) from m_tb_user group by age, status;   --extra Using index; Using temporary
    +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+------------------------------+
    | id | select_type | table     | partitions | type  | possible_keys        | key                  | key_len | ref  | rows | filtered | Extra                        |
    +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+------------------------------+
    |  1 | SIMPLE      | m_tb_user | NULL       | index | idx_user_pro_age_sta | idx_user_pro_age_sta | 54      | NULL |   24 |   100.00 | Using index; Using temporary |
    +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+------------------------------+

    explain select age, count(*) from m_tb_user group by age;                   --extra Using index; Using temporary
    +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+------------------------------+
    | id | select_type | table     | partitions | type  | possible_keys        | key                  | key_len | ref  | rows | filtered | Extra                        |
    +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+------------------------------+
    |  1 | SIMPLE      | m_tb_user | NULL       | index | idx_user_pro_age_sta | idx_user_pro_age_sta | 54      | NULL |   24 |   100.00 | Using index; Using temporary |
    +----+-------------+-----------+------------+-------+----------------------+----------------------+---------+------+------+----------+------------------------------+

    我们发现，如果仅仅根据age分组，就会出现 Using temporary ；而如果是根据profession,age两个字段同时分组，则不会出现 Using temporary。
    原因是因为对于分组操作，在联合索引中，也是符合最左前缀法则的。


所以，在分组操作中，我们需要通过以下两点进行优化，以提升性能：
    A. 在分组操作时，可以通过索引来提高效率。
    B. 分组操作时，索引的使用也是满足最左前缀法则的。
