我们主要需要注意一下update语句执行时的注意事项。
    update course set name = 'javaEE' where id = 1;
当我们在执行删除的SQL语句时，会锁定id为1这一行的数据，然后事务提交之后，行锁释放。

但是当我们在执行如下SQL时。
    update course set name = 'SpringBoot' where name = 'PHP' ;
    当我们开启多个事务，在执行上述的SQL时，我们发现行锁升级为了表锁。 导致该update语句的性能大大降低。


InnoDB的行锁是针对索引加的锁，不是针对记录加的锁 ,并且该索引不能失效，否则会从行锁升级为表锁 。
