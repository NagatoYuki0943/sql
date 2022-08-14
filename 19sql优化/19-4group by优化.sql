分组操作，我们主要来看看索引对于分组操作的影响。
    首先我们先将 m_tb_user 表的索引全部删除掉。
        drop index idx_user_pro_age_sta on m_tb_user;
        drop index idx_email_5 on m_tb_user;
        drop index idx_user_age_phone_aa on m_tb_user;
        drop index idx_user_age_phone_ad on m_tb_user;

    接下来，在没有索引的情况下，执行如下SQL，查询执行计划：
        explain select profession , count(*) from m_tb_user group by profession ;

    然后，我们在针对于 profession ， age， status 创建一个联合索引。
        create index idx_user_pro_age_sta on m_tb_user(profession , age , status);

    紧接着，再执行前面相同的SQL查看执行计划。
        explain select profession , count(*) from m_tb_user group by profession ;

    再执行如下的分组查询SQL，查看执行计划：

    我们发现，如果仅仅根据age分组，就会出现 Using temporary ；而如果是 根据
    profession,age两个字段同时分组，则不会出现 Using temporary。原因是因为对于分组操作，
    在联合索引中，也是符合最左前缀法则的。


所以，在分组操作中，我们需要通过以下两点进行优化，以提升性能：
    A. 在分组操作时，可以通过索引来提高效率。
    B. 分组操作时，索引的使用也是满足最左前缀法则的。
