水平拆分(按行拆表)


1 场景
    在业务系统中, 有一张表(日志表), 业务系统每天都会产生大量的日志数据 , 单台服务器的数据存
    储及处理能力是有限的, 可以对数据库表进行拆分。
    (PDF)


2 准备
    准备三台服务器，具体的结构如下：
    (PDF)
    并且，在三台数据库服务器中分表创建一个数据库itcast。


3 配置
    1). schema.xml
        <schema name="ITCAST" checkSQLschema="true" sqlMaxLimit="100">
            --                            多个节点
            <table name="tb_log" dataNode="dn4,dn5,dn6" primaryKey="id" rule="mod-long"/> -- 分片规则 mod-long 求模运算,余数是几就放在哪一个节点
        </schema>
        --            节点名不同,但仍然关联相同的服务器,不过数据库是新的
        <dataNode name="dn4" dataHost="dhost1" database="itcast"/>
        <dataNode name="dn5" dataHost="dhost2" database="itcast"/>
        <dataNode name="dn6" dataHost="dhost3" database="itcast"/>

        tb_log表最终落在3个节点中，分别是 dn4、dn5、dn6 ，而具体的数据分别存储在 dhost1、dhost2、dhost3的itcast数据库中。

    2). server.xml
        配置root用户既可以访问 SHOPPING 逻辑库，又可以访问ITCAST逻辑库。

        <user name="root" defaultAccount="true">
            <property name="password">123456</property>
            <property name="schemas">SHOPPING,ITCAST</property>     -- 改用户可以访问的逻辑库,多个逻辑库之间逗号分隔
            <!-- 表级 DML 权限设置 -->
            <!--
            <privileges check="true">
                <schema name="DB01" dml="0110" >
                    <table name="TB_ORDER" dml="1110"></table>
                </schema>
            </privileges>
            -->
        </user>


4 测试
    配置完毕后，重新启动MyCat，然后在mycat的命令行中，执行如下SQL创建表、并插入数据，查看数
    据分布情况。

    CREATE TABLE tb_log (
        id bigint(20) NOT NULL COMMENT 'ID',
        model_name varchar(200) DEFAULT NULL COMMENT '模块名',
        model_value varchar(200) DEFAULT NULL COMMENT '模块值',
        return_value varchar(200) DEFAULT NULL COMMENT '返回值',
        return_class varchar(200) DEFAULT NULL COMMENT '返回值类型',
        operate_user varchar(20) DEFAULT NULL COMMENT '操作用户',
        operate_time varchar(20) DEFAULT NULL COMMENT '操作时间',
        param_and_value varchar(500) DEFAULT NULL COMMENT '请求参数名及参数值',
        operate_class varchar(200) DEFAULT NULL COMMENT '操作类',
        operate_method varchar(200) DEFAULT NULL COMMENT '操作方法',
        cost_time bigint(20) DEFAULT NULL COMMENT '执行方法耗时, 单位 ms',
        source int(1) DEFAULT NULL COMMENT '来源 : 1 PC , 2 Android , 3 IOS',
        PRIMARY KEY (id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    INSERT INTO tb_log (id, model_name, model_value, return_value, return_class,
    operate_user, operate_time, param_and_value, operate_class, operate_method,
    cost_time，source)
    VALUES('1','user','insert','success','java.lang.String','10001','2022-01-06
    18:12:28','{\"age\":\"20\",\"name\":\"Tom\",\"gender\":\"1\"}','cn.itcast.contro
    ller.UserController','insert','10',1);
    INSERT INTO tb_log (id, model_name, model_value, return_value, return_class,
    operate_user, operate_time, param_and_value, operate_class, operate_method,
    cost_time，source)
    VALUES('2','user','insert','success','java.lang.String','10001','2022-01-06
    18:12:27','{\"age\":\"20\",\"name\":\"Tom\",\"gender\":\"1\"}','cn.itcast.contro
    ller.UserController','insert','23',1);
    INSERT INTO tb_log (id, model_name, model_value, return_value, return_class,
    operate_user, operate_time, param_and_value, operate_class, operate_method,
    cost_time，source)
    VALUES('3','user','update','success','java.lang.String','10001','2022-01-06
    18:16:45','{\"age\":\"20\",\"name\":\"Tom\",\"gender\":\"1\"}','cn.itcast.contro
    ller.UserController','update','34',1);
    INSERT INTO tb_log (id, model_name, model_value, return_value, return_class,
    operate_user, operate_time, param_and_value, operate_class, operate_method,
    cost_time，source)
    VALUES('4','user','update','success','java.lang.String','10001','2022-01-06
    18:16:45','{\"age\":\"20\",\"name\":\"Tom\",\"gender\":\"1\"}','cn.itcast.contro
    ller.UserController','update','13',2);
    INSERT INTO tb_log (id, model_name, model_value, return_value, return_class,
    operate_user, operate_time, param_and_value, operate_class, operate_method,
    cost_time，source)
    VALUES('5','user','insert','success','java.lang.String','10001','2022-01-06
    18:30:31','{\"age\":\"200\",\"name\":\"TomCat\",\"gender\":\"0\"}','cn.itcast.co
    ntroller.UserController','insert','29',3);
    INSERT INTO tb_log (id, model_name, model_value, return_value, return_class,
    operate_user, operate_time, param_and_value, operate_class, operate_method,
    cost_time，source)
    VALUES('6','user','find','success','java.lang.String','10001','2022-01-06
    18:30:31','{\"age\":\"200\",\"name\":\"TomCat\",\"gender\":\"0\"}','cn.itcast.co
    ntroller.UserController','find','29',2);
