1 索引分类
    在MySQL数据库，将索引的具体类型主要分为以下几类：主键索引、唯一索引、常规索引、全文索引。

    分类        含义                                                特点                                关键字
    主键索引    针对于表中主键创建的索引                            默认自动创建, 只能有一个(可以联合)      PRIMARY

    唯一索引    避免同一个表中某数据列中的值重复                     可以有多个                             UNIQUE

    常规索引    快速定位特定数据                                    可以有多个

    全文索引    全文索引查找的是文本中的关键词，而不是比较索引中的值    可以有多个                            FULLTEXT


2 聚集索引&二级索引
    而在在InnoDB存储引擎中，根据索引的存储形式，又可以分为以下两种：

    分类                        含义                                                        特点
    聚集索引(Clustered Index)   将数据存储与索引放到了一块，索引结构的叶子节点保存了行数据      必须有,而且只有一个(存放行数据)

    二级索引(Secondary Index)   将数据与索引分开存储，索引结构的叶子节点关联的是对应的主键      可以存在多个
                                指向数据的聚集索引

    二级索引又称非聚集索引

    聚集索引选取规则:
        - 如果存在主键，主键索引就是聚集索引。
        - 如果不存在主键，将使用第一个唯一（UNIQUE）索引作为聚集索引。
        - 如果表没有主键，或没有合适的唯一索引，则InnoDB会自动生成一个rowid作为隐藏的聚集索引。

    当查询二级索引的数据时,先通过二级索引找到对应的值,同时找到对应的聚集索引,在通过聚集索引找到对应的值,这个过程称之为回表查询