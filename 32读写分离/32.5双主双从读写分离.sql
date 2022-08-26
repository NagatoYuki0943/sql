1 配置
    MyCat控制后台数据库的读写分离和负载均衡由 schema.xml 文件datahost标签的balance属性控
    制，通过writeType及switchType来完成失败自动切换的。

    1). schema.xml
        配置逻辑库：
                    -- 逻辑库名
            <schema name="ITCAST_RW2" checkSQLschema="true" sqlMaxLimit="100" dataNode="dn7">
                -- 可以不指定逻辑表,不指定的话会加载数据节点的数据库中的全部表
            </schema>

        配置数据节点：
            --        数据节点名        关联的节点主机    节点的数据库
            <dataNode name="dn7" dataHost="dhost7" database="db01"/>

        配置节点主机：
            -- 节点主机    节点标识        最大最小连接数         负载均衡   写操作分发方式                     数据库驱动
            <dataHost name="dhost7" maxCon="1000" minCon="10" balance="1" writeType="0" dbType="mysql" dbDriver="jdbc" switchType="1" slaveThreshold="100">
                <heartbeat>select user()</heartbeat>
                <writeHost host="master1" url="jdbc:mysql://192.168.200.211:3306?useSSL=false&amp;serverTimezone=Asia/Shanghai&amp;characterEncoding=utf8" user="root" password="1234" >
                    <readHost host="slave1" url="jdbc:mysql://192.168.200.212:3306?useSSL=false&amp;serverTimezone=Asia/Shanghai&amp;characterEncoding=utf8" user="root" password="1234" />
                </writeHost>
                <writeHost host="master2" url="jdbc:mysql://192.168.200.213:3306?useSSL=false&amp;serverTimezone=Asia/Shanghai&amp;characterEncoding=utf8" user="root" password="1234" >
                    <readHost host="slave2" url="jdbc:mysql://192.168.200.214:3306?useSSL=false&amp;serverTimezone=Asia/Shanghai&amp;characterEncoding=utf8" user="root" password="1234" />
                </writeHost>
            </dataHost>

        具体的对应情况如下：
            (PDF)

        属性说明：
            balance="1"
                代表全部的 readHost 与 stand by writeHost 参与 select 语句的负载均衡，简单的说，
                当双主双从模式(M1->S1，M2->S2，并且 M1 与 M2 互为主备)，正常情况下，
                M2,S1,S2 都参与 select 语句的负载均衡 ;
            writeType
                0 : 写操作都转发到第1台writeHost, writeHost1挂了, 会切换到writeHost2上;
                1 : 所有的写操作都随机地发送到配置的writeHost上 ;
            switchType
                -1 : 不自动切换
                1 :  自动切换

    2). user.xml
        配置root用户也可以访问到逻辑库 ITCAST_RW2。
            <user name="root" defaultAccount="true">
            <property name="password">123456</property>
            <property name="schemas">SHOPPING,ITCAST,ITCAST_RW2</property>
            <!-- 表级 DML 权限设置 -->
            <!--
            <privileges check="true">
            <schema name="DB01" dml="0110" >
            <table name="TB_ORDER" dml="1110"></table>
            </schema>
            </privileges>
            -->
            </user>

2 测试
    登录MyCat，测试查询及更新操作，判定是否能够进行读写分离，以及读写分离的策略是否正确。
    当主库挂掉一个之后，是否能够自动切换。