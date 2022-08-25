垂直拆分(将一个数据库中的数据表分散到不同的数据库)


1 场景
    在业务系统中, 涉及以下表结构 ,但是由于用户与订单每天都会产生大量的数据, 单台服务器的数据
    存储及处理能力是有限的, 可以对数据库表进行拆分, 原有的数据库表如下。
    (PDF)
    现在考虑将其进行垂直分库操作，将商品相关的表拆分到一个数据库服务器，订单表拆分的一个数据库
    服务器，用户及省市区表拆分到一个服务器。最终结构如下：
    (PDF)


2 准备
    准备三台服务器，IP地址如图所示
    (PDF)
    并且在 192.168.200.210，192.168.200.213, 192.168.200.214 上面创建数据库 shopping。


3 配置
    1). schema.xml
        <schema name="SHOPPING" checkSQLschema="true" sqlMaxLimit="100">
            -- 这些表在 dn1 节点
            <table name="tb_goods_base" dataNode="dn1" primaryKey="id"/>
            <table name="tb_goods_brand" dataNode="dn1" primaryKey="id"/>
            <table name="tb_goods_cat" dataNode="dn1" primaryKey="id"/>
            <table name="tb_goods_desc" dataNode="dn1" primaryKey="goods_id"/>
            <table name="tb_goods_item" dataNode="dn1" primaryKey="id"/>

            -- 这些表在 dn2 节点
            <table name="tb_order_item" dataNode="dn2" primaryKey="id"/>
            <table name="tb_order_master" dataNode="dn2" primaryKey="order_id"/>
            <table name="tb_order_pay_log" dataNode="dn2" primaryKey="out_trade_no"/>
            <table name="tb_user" dataNode="dn3" primaryKey="id"/>

            -- 这些表在 dn3 节点
            <table name="tb_user_address" dataNode="dn3" primaryKey="id"/>
            <table name="tb_areas_provinces" dataNode="dn3" primaryKey="id"/>
            <table name="tb_areas_city" dataNode="dn3" primaryKey="id"/>
            <table name="tb_areas_region" dataNode="dn3" primaryKey="id"/>
        </schema>

        --        三个数据节点         关联的节点主机    节点的数据库
        <dataNode name="dn1" dataHost="dhost1" database="shopping"/>
        <dataNode name="dn2" dataHost="dhost2" database="shopping"/>
        <dataNode name="dn3" dataHost="dhost3" database="shopping"/>

        -- 节点主机    节点标识        最大最小连接数         负载均衡   写操作分发方式                      数据库驱动
        <dataHost name="dhost1" maxCon="1000" minCon="10" balance="0" writeType="0" dbType="mysql" dbDriver="jdbc" switchType="1" slaveThreshold="100">
            <heartbeat>select user()</heartbeat>
            <writeHost host="master" url="jdbc:mysql://192.168.200.210:3306?useSSL=false&amp;serverTimezone=Asia/Shanghai&amp;characterEncoding=utf8" user="root" password="1234" />
        </dataHost>
        <dataHost name="dhost2" maxCon="1000" minCon="10" balance="0" writeType="0" dbType="mysql" dbDriver="jdbc" switchType="1" slaveThreshold="100">
            <heartbeat>select user()</heartbeat>
            <writeHost host="master" url="jdbc:mysql://192.168.200.213:3306?useSSL=false&amp;serverTimezone=Asia/Shanghai&amp;characterEncoding=utf8" user="root" password="1234" />
        </dataHost>
        <dataHost name="dhost3" maxCon="1000" minCon="10" balance="0" writeType="0" dbType="mysql" dbDriver="jdbc" switchType="1" slaveThreshold="100">
            <heartbeat>select user()</heartbeat>
            <writeHost host="master" url="jdbc:mysql://192.168.200.214:3306?useSSL=false&amp;serverTimezone=Asia/Shanghai&amp;characterEncoding=utf8" user="root" password="1234" />
        </dataHost>


    2). server.xml
        <user name="root" defaultAccount="true">
            <property name="password">123456</property>
            <property name="schemas">SHOPPING</property>
            <!-- 表级 DML 权限设置 -->
            <!--
            <privileges check="true">
                <schema name="DB01" dml="0110" >
                    <table name="TB_ORDER" dml="1110"></table>
                </schema>
            </privileges>
            -->
        </user>
        <user name="user">
            <property name="password">123456</property>
            <property name="schemas">SHOPPING</property>    -- 改用户可以访问的逻辑库,多个逻辑库之间逗号分隔
            <property name="readOnly">true</property>
        </user>


4 测试
    1). 上传测试SQL脚本到服务器的/root目录
        /root/shopping-table.sql
        /root/shopping-insert.sql

    2). 执行指令导入测试数据
        重新启动MyCat后，在mycat的命令行中，通过source指令导入表结构，以及对应的数据，查看数据分布情况。

            source /root/shopping-table.sql
            source /root/shopping-insert.sql

        将表结构及对应的测试数据导入之后，可以检查一下各个数据库服务器中的表结构分布情况。 检查是
        否和我们准备工作中规划的服务器一致。
        (PDF)

    3). 查询用户的收件人及收件人地址信息(包含省、市、区)。
        在MyCat的命令行中，当我们执行以下多表联查的SQL语句时，可以正常查询出数据。

        select ua.user_id, ua.contact, p.province, c.city, r.area , ua.address from
        tb_user_address ua ,tb_areas_city c , tb_areas_provinces p ,tb_areas_region r
        where ua.province_id = p.provinceid and ua.city_id = c.cityid and ua.town_id =
        r.areaid ;

    4). 查询每一笔订单及订单的收件地址信息(包含省、市、区)。
        实现该需求对应的SQL语句如下：

        SELECT order_id , payment ,receiver, province , city , area FROM tb_order_master o
        , tb_areas_provinces p , tb_areas_city c , tb_areas_region r WHERE
        o.receiver_province = p.provinceid AND o.receiver_city = c.cityid AND
        o.receiver_region = r.areaid ;

        但是现在存在一个问题，订单相关的表结构是在 192.168.200.213 数据库服务器中，而省市区的数
        据库表是在 192.168.200.214 数据库服务器中。那么在MyCat中执行是否可以成功呢？

        经过测试，我们看到，SQL语句执行报错。原因就是因为MyCat在执行该SQL语句时，需要往具体的数
        据库服务器中路由，而当前没有一个数据库服务器完全包含了订单以及省市区的表结构，造成SQL语句失败，报错。

        对于上述的这种现象，我们如何来解决呢？ 下面我们介绍的全局表，就可以轻松解决这个问题。


5 全局表
    对于省、市、区/县表tb_areas_provinces , tb_areas_city , tb_areas_region，是属于
    数据字典表，在多个业务模块中都可能会遇到，可以将其设置为全局表，利于业务操作。

    修改 schema.xml 中的逻辑表的配置，修改 tb_areas_provinces、tb_areas_city、
    tb_areas_region 三个逻辑表，增加 type 属性，配置为global，就代表该表是全局表，就会在
    所涉及到的dataNode中创建给表。对于当前配置来说，也就意味着所有的节点中都有该表了。

    <schema name="SHOPPING" checkSQLschema="true" sqlMaxLimit="100">
        ...                                      --三个节点都有
        <table name="tb_areas_provinces" dataNode="dn1,dn2,dn3" primaryKey="id" type="global"/>  -- global代表全局表
        <table name="tb_areas_city" dataNode="dn1,dn2,dn3" primaryKey="id" type="global"/>
        <table name="tb_areas_region" dataNode="dn1,dn2,dn3" primaryKey="id" type="global"/>
    </schema>
    (PDF)


    配置完毕后，重新启动MyCat。
    1). 删除原来每一个数据库服务器中的所有表结构
    2). 通过source指令，导入表及数据
        source /root/shopping-table.sql
        source /root/shopping-insert.sql
    3). 检查每一个数据库服务器中的表及数据分布，看到三个节点中都有这三张全局表
    4). 然后再次执行上面的多表联查的SQL语句
        SELECT order_id , payment ,receiver, province , city , area FROM tb_order_master o
        , tb_areas_provinces p , tb_areas_city c , tb_areas_region r WHERE
        o.receiver_province = p.provinceid AND o.receiver_city = c.cityid AND
        o.receiver_region = r.areaid;
        是可以正常执行成功的。
    5). 当在MyCat中更新全局表的时候，我们可以看到，所有分片节点中的数据都发生了变化，每个节点的全局表数据时刻保持一致。
