1 MyCat原理
    (PDF)
    SQL -> 解析SQL -> 切片分析 -> 路由分析 -> 读写分离分析 -> 查询数据库
    数据<- 分页处理 <- 排序处理 <- 聚合处理 <- 结果合并 <---------┘

    在MyCat中，当执行一条SQL语句时，MyCat需要进行SQL解析、分片分析、路由分析、读写分离分析
    等操作，最终经过一系列的分析决定将当前的SQL语句到底路由到那几个(或哪一个)节点数据库，数据
    库将数据执行完毕后，如果有返回的结果，则将结果返回给MyCat，最终还需要在MyCat中进行结果合
    并、聚合处理、排序处理、分页处理等操作，最终再将结果返回给客户端。

    而在MyCat的使用过程中，MyCat官方也提供了一个管理监控平台MyCat-Web（MyCat-eye）。
    Mycat-web 是 Mycat 可视化运维的管理和监控平台，弥补了 Mycat 在监控上的空白。帮 Mycat
    分担统计任务和配置管理任务。Mycat-web 引入了 ZooKeeper 作为配置中心，可以管理多个节
    点。Mycat-web 主要管理和监控 Mycat 的流量、连接、活动线程和内存等，具备 IP 白名单、邮
    件告警等模块，还可以统计 SQL 并分析慢 SQL 和高频 SQL 等。为优化 SQL 提供依据。


2 MyCat管理
    Mycat默认开通2个端口，可以在 server.xml 中进行修改。
        - 8066 数据访问端口，即进行 DML 和 DDL 操作。
        - 9066 数据库管理端口，即 mycat 服务管理控制功能，用于管理mycat的整个集群状态

    连接MyCat的管理控制台：
        mysql -h 192.168.200.210 -p 9066 -uroot -p123456

    命令                含义
    show @@help         查看Mycat管理工具帮助文档
    show @@version      查看Mycat的版本
    show @@datasource   查看Mycat的数据源信息
    show @@datanode     查看MyCat现有的分片节点信息
    show @@threadpool   查看Mycat的线程池信息
    show @@sql          查看执行的SQL
    show @@sql.sum      查看执行的SQL统计
    reload @@config     重新加载Mycat的配置文件


3 MyCat-eye
    1 介绍
    Mycat-web(Mycat-eye)是对mycat-server提供监控服务，功能不局限于对mycat-server使用。
    他通过JDBC连接对Mycat、Mysql监控，监控远程服务器(目前仅限于linux系统)的cpu、内存、网络、磁盘。
    Mycat-eye运行过程中需要依赖zookeeper，因此需要先安装zookeeper。

    2 安装
        1). zookeeper安装
        2). Mycat-web安装
        具体的安装步骤，请参考资料中提供的《MyCat-Web安装文档》

    3 访问
        http://192.168.200.210:8082/mycat

    4 配置
        1). 开启MyCat的实时统计功能(server.xml)
            <property name="useSqlStat">1</property> <!-- 1为开启实时统计、0为关闭 -->
        2). 在Mycat监控界面配置服务地址
            (PDF)

    5 测试
        配置好了之后，我们可以通过MyCat执行一系列的增删改查的测试，然后过一段时间之后，打开
        mycat-eye的管理界面，查看mycat-eye监控到的数据信息。

        A. 性能监控
            (PDF)
        B. 物理节点
            (PDF)
        C. SQL统计
            (PDF)
        D. SQL表分析
            (PDF)
        E. SQL监控
            (PDF)
        F. 高频SQL
            (PDF)
