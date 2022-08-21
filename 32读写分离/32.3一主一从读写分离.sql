MyCat控制后台数据库的读写分离和负载均衡由schema.xml文件datahost标签的balance属性控制。

1 schema.xml 配置
        <!-- 配置逻辑库 -->
        <schema name="ITCAST_RW" checkSQLschema="true" sqlMaxLimit="100" dataNode="dn7">
        </schema>
        <dataNode name="dn7" dataHost="dhost7" database="itcast" />
        <dataHost name="dhost7" maxCon="1000" minCon="10" balance="1" writeType="0"
        dbType="mysql" dbDriver="jdbc" switchType="1" slaveThreshold="100">
        <heartbeat>select user()</heartbeat>
        <writeHost host="master1" url="jdbc:mysql://192.168.200.211:3306?
        useSSL=false&amp;serverTimezone=Asia/Shanghai&amp;characterEncoding=utf8"
        user="root" password="1234" >
        <readHost host="slave1" url="jdbc:mysql://192.168.200.212:3306?
        useSSL=false&amp;serverTimezone=Asia/Shanghai&amp;characterEncoding=utf8"
        user="root" password="1234" />
        </writeHost>
        </dataHost>
    上述配置的具体关联对应情况如下：
    (PDF)
    writeHost代表的是写操作对应的数据库，readHost代表的是读操作对应的数据库。 所以我们要想
    实现读写分离，就得配置writeHost关联的是主库，readHost关联的是从库。
    而仅仅配置好了writeHost以及readHost还不能完成读写分离，还需要配置一个非常重要的负责均衡
    的参数 balance，取值有4种，具体含义如下：

    参数值   含义
    0       不开启读写分离机制 , 所有读操作都发送到当前可用的writeHost上
    1       全部的readHost 与 备用的writeHost 都参与select 语句的负载均衡（主要针对于双主双从模式）
    2       所有的读写操作都随机在writeHost , readHost上分发
    3       所有的读请求随机分发到writeHost对应的readHost上执行, writeHost不负担读压力

    所以，在一主一从模式的读写分离中，balance配置1或3都是可以完成读写分离的。


2 server.xml 配置
    配置root用户可以访问SHOPPING、ITCAST 以及 ITCAST_RW逻辑库。
        <user name="root" defaultAccount="true">
        <property name="password">123456</property>
        <property name="schemas">SHOPPING,ITCAST,ITCAST_RW</property>
        <!-- 表级 DML 权限设置 -->
        <!--
        <privileges check="true">
        <schema name="DB01" dml="0110" >
        <table name="TB_ORDER" dml="1110"></table>
        </schema>
        </privileges>
        -->
        </user>


3 测试
    配置完毕MyCat后，重新启动MyCat。
        bin/mycat stop
        bin/mycat start
    然后观察，在执行增删改操作时，对应的主库及从库的数据变化。 在执行查询操作时，检查主库及从库对应的数据变化。

    在测试中，我们可以发现当主节点Master宕机之后，业务系统就只能够读，而不能写入数据了。
    (PDF)
    那如何解决这个问题呢？这个时候我们就得通过另外一种主从复制结构来解决了，也就是我们接下来讲解的双主双从。



