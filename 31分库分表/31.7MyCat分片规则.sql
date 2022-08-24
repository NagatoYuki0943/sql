分片规则


1 范围分片 auto-sharding-long
    1). 介绍
        根据指定的字段及其配置的范围与数据节点的对应情况， 来决定该数据属于哪一个分片。
        node0: 0~10000
        node1: 10001~20000
        node2: 20001~30000

    2). 配置
        schema.xml 逻辑表配置：
            <table name="TB_ORDER" dataNode="dn1,dn2,dn3" rule="auto-sharding-long"/>

        schema.xml 数据节点配置：
            <dataNode name="dn1" dataHost="dhost1" database="db01"/>
            <dataNode name="dn2" dataHost="dhost2" database="db01"/>
            <dataNode name="dn3" dataHost="dhost3" database="db01"/>

        rule.xml 分片规则配置：
            <tableRule name="auto-sharding-long">
                <rule>
                    <columns>id</columns>               -- 根据id进行分片
                    <algorithm>rang-long</algorithm>    -- 对应下面的tableRule
                </rule>
            </tableRule>
            <function name="rang-long" class="io.mycat.route.function.AutoPartitionByLong">
                <property name="mapFile">autopartition-long.txt</property>  -- autopartition-long.txt 指定长度
                <property name="defaultNode">0</property>
            </function>

        分片规则配置属性含义：
            属性            描述
            columns         标识将要分片的表字段
            algorithm       指定分片函数与function的对应关系
            class           指定该分片算法对应的类
            mapFile         对应的外部配置文件
            type            默认值为0 ; 0 表示Integer , 1 表示String
            defaultNode     默认节点 默认节点的所用:枚举分片时,如果碰到不识别的枚举值, 就让它路
                            由到默认节点 ; 如果没有默认值,碰到不识别的则报错 。

        在 rule.xml 中配置分片规则时，关联了一个映射配置文件 autopartition-long.txt，该配置文件的配置如下：
            # range start-end ,data node index
            # K=1000,M=10000.
            0-500M=0
            500M-1000M=1
            1000M-1500M=2
        含义：0-500万之间的值，存储在0号数据节点(数据节点的索引从0开始) ； 500万-1000万之间的数据存储在1号数据节点 ； 1000万-1500万的数据节点存储在2号节点 ；
        该分片规则，主要是针对于数字类型的字段适用。 在MyCat的入门程序中，我们使用的就是该分片规则。


2 取模分片 mod-long
    1). 介绍
        根据指定的字段值与节点数量进行求模运算，根据运算结果，来决定该数据属于哪一个分片。
        余数是几就放在哪一个节点
        node0: 3,6,9...
        node1: 1,4,7...
        node2: 2,5,8...

    2). 配置
        schema.xml 逻辑表配置：
            <table name="tb_log" dataNode="dn4,dn5,dn6" primaryKey="id" rule="mod-long"/>

        schema.xml 数据节点配置：
            <dataNode name="dn4" dataHost="dhost1" database="itcast"/>
            <dataNode name="dn5" dataHost="dhost2" database="itcast"/>
            <dataNode name="dn6" dataHost="dhost3" database="itcast"/>

        rule.xml 分片规则配置：
            <tableRule name="mod-long">
                <rule>
                    <columns>id</columns>               -- 按照id求模
                    <algorithm>mod-long</algorithm>     -- 对应下面的tableRule
                </rule>
            </tableRule>
            <function name="mod-long" class="io.mycat.route.function.PartitionByMod">
                <property name="count">3</property>     --节点数量
            </function>

        分片规则属性说明如下：
            属性        描述
            columns     标识将要分片的表字段
            algorithm   指定分片函数与function的对应关系
            class       指定该分片算法对应的类
            count       数据节点的数量
        该分片规则，主要是针对于数字类型的字段适用。 在前面水平拆分的演示中，我们选择的就是取模分片。

    3). 测试
        配置完毕后，重新启动MyCat，然后在mycat的命令行中，执行如下SQL创建表、并插入数据，查看数据分布情况。


3 一致性hash分片 sharding-by-murmur
    1). 介绍
        所谓一致性哈希，相同的哈希因子计算值总是被划分到相同的分区表中，不会因为分区节点的增加而改变原来数据的分区位置，有效的解决了分布式数据的拓容问题。
        比如主键id不是数字,而是随机字符串,比如uuid,就可以使用一致性hash运算结果
        (PDF)

    2). 配置
        schema.xml 中逻辑表配置：
            <table name="tb_order" dataNode="dn4,dn5,dn6" rule="sharding-by-murmur"/>

        schema.xml 中数据节点配置：
            <dataNode name="dn4" dataHost="dhost1" database="itcast"/>
            <dataNode name="dn5" dataHost="dhost2" database="itcast"/>
            <dataNode name="dn6" dataHost="dhost3" database="itcast"/>

        rule.xml 中分片规则配置：
            <tableRule name="sharding-by-murmur">
                <rule>
                    <columns>id</columns>           -- 使用id做hash运算
                    <algorithm>murmur</algorithm>   -- 对应下面的tableRule
                </rule>
            </tableRule>
            <function name="murmur" class="io.mycat.route.function.PartitionByMurmurHash">
                <property name="seed">0</property>                  -- 默认是0
                <property name="count">3</property>                 -- 节点数量
                <property name="virtualBucketTimes">160</property>  -- 虚拟结点数量
            </function>

        分片规则属性含义：

            属性                描述
            columns             标识将要分片的表字段
            algorithm           指定分片函数与function的对应关系
            class               指定该分片算法对应的类
            seed                创建murmur_hash对象的种子，默认0
            count               要分片的数据库节点数量，必须指定，否则没法分片
            virtualBucketTimes  一个实际的数据库节点被映射为这么多虚拟节点，默认是160倍，也就是虚拟节点数是物理节点数的160倍;virtualBucketTimes*count就是虚拟结点数量;
            weightMapFile       节点的权重，没有指定权重的节点默认是1。以properties文件的格式填写，以从0开始到count-1的整数值也就是节点索引为key，以节点权重值为值。所有权重值必须是正整数，否则以1代替
            bucketMapPath       用于测试时观察各物理节点与虚拟节点的分布情况，如果指定了这个属性，会把虚拟节点的murmur hash值与物理节点的映射按行输出到这个文件，没有默认值，如果不指定，就不会输出任何东西

    3). 测试
        配置完毕后，重新启动MyCat，然后在mycat的命令行中，执行如下SQL创建表、并插入数据，查看数据分布情况。
            create table tb_order(
                id varchar(100) not null primary key,
                money int null,
                content varchar(200) null
            );
            insert into tb_order (id, money, content) values ('b92fdaaf-6fc4-11ec-b831-482ae33c4a2d', 10, 'b92fdaf8-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b93482b6-6fc4-11ec-b831-482ae33c4a2d', 20, 'b93482d5-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b937e246-6fc4-11ec-b831-482ae33c4a2d', 50, 'b937e25d-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b93be2dd-6fc4-11ec-b831-482ae33c4a2d', 100, 'b93be2f9-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b93f2d68-6fc4-11ec-b831-482ae33c4a2d', 130, 'b93f2d7d-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b9451b98-6fc4-11ec-b831-482ae33c4a2d', 30, 'b9451bcc-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b9488ec1-6fc4-11ec-b831-482ae33c4a2d', 560, 'b9488edb-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b94be6e6-6fc4-11ec-b831-482ae33c4a2d', 10, 'b94be6ff-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b94ee10d-6fc4-11ec-b831-482ae33c4a2d', 123, 'b94ee12c-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b952492a-6fc4-11ec-b831-482ae33c4a2d', 145, 'b9524945-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b95553ac-6fc4-11ec-b831-482ae33c4a2d', 543, 'b95553c8-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b9581cdd-6fc4-11ec-b831-482ae33c4a2d', 17, 'b9581cfa-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b95afc0f-6fc4-11ec-b831-482ae33c4a2d', 18, 'b95afc2a-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b95daa99-6fc4-11ec-b831-482ae33c4a2d', 134, 'b95daab2-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b9667e3c-6fc4-11ec-b831-482ae33c4a2d', 156, 'b9667e60-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b96ab489-6fc4-11ec-b831-482ae33c4a2d', 175, 'b96ab4a5-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b96e2942-6fc4-11ec-b831-482ae33c4a2d', 180, 'b96e295b-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b97092ec-6fc4-11ec-b831-482ae33c4a2d', 123, 'b9709306-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b973727a-6fc4-11ec-b831-482ae33c4a2d', 230, 'b9737293-6fc4-11ec-b831-482ae33c4a2d');
            insert into tb_order (id, money, content) values ('b978840f-6fc4-11ec-b831-482ae33c4a2d', 560, 'b978843c-6fc4-11ec-b831-482ae33c4a2d');


4 枚举分片 sharding-by-intfile-enumstatus
    1). 介绍
        通过在配置文件中配置可能的枚举值, 指定数据分布到不同数据节点上, 本规则适用于按照省份、性别、状态拆分数据等业务 。
        (PDF)

    2). 配置
        schema.xml 中逻辑表配置：
            <table name="tb_user" dataNode="dn4,dn5,dn6" rule="sharding-by-intfile-enumstatus"

        schema.xml 中数据节点配置：
            <dataNode name="dn4" dataHost="dhost1" database="itcast"/>
            <dataNode name="dn5" dataHost="dhost2" database="itcast"/>
            <dataNode name="dn6" dataHost="dhost3" database="itcast"/>

        rule.xml 中分片规则配置：
            <tableRule name="sharding-by-intfile">
                <rule>
                    <columns>sharding_id</columns>
                    <algorithm>hash-int</algorithm>    -- 对应下面的tableRule
                </rule>
            </tableRule>
            <!-- 自己增加 tableRule -->
            <tableRule name="sharding-by-intfile-enumstatus">
                <rule>
                    <columns>status</columns>
                    <algorithm>hash-int</algorithm>    -- 对应下面的tableRule
                </rule>
            </tableRule>
            <function name="hash-int" class="io.mycat.route.function.PartitionByFileMap">
                <property name="defaultNode">2</property>
                <property name="mapFile">partition-hash-int.txt</property>
            </function>

        partition-hash-int.txt ，内容如下 :
            1=0
            2=1
            3=2

        分片规则属性含义：
            属性            描述
            columns         标识将要分片的表字段
            algorithm       指定分片函数与function的对应关系
            class           指定该分片算法对应的类
            mapFile         对应的外部配置文件
            type            默认值为0 ; 0 表示Integer , 1 表示String
            defaultNode     默认节点 ; 小于0 标识不设置默认节点 , 大于等于0代表设置默认节点 ;默认节点的所用:枚举分片时,如果碰到不识别的枚举值, 就让它路由到默认节点 ; 如果没有默认值,碰到不识别的则报错 。

    3). 测试
        配置完毕后，重新启动MyCat，然后在mycat的命令行中，执行如下SQL创建表、并插入数据，查看数据分布情况。
        CREATE TABLE tb_user (
            id bigint(20) NOT NULL COMMENT 'ID',
            username varchar(200) DEFAULT NULL COMMENT '姓名',
            status int(2) DEFAULT '1' COMMENT '1: 未启用, 2: 已启用, 3: 已关闭',
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        insert into tb_user (id,username ,status) values(1,'Tom',1);
        insert into tb_user (id,username ,status) values(2,'Cat',2);
        insert into tb_user (id,username ,status) values(3,'Rose',3);
        insert into tb_user (id,username ,status) values(4,'Coco',2);
        insert into tb_user (id,username ,status) values(5,'Lily',1);
        insert into tb_user (id,username ,status) values(6,'Tom',1);
        insert into tb_user (id,username ,status) values(7,'Cat',2);
        insert into tb_user (id,username ,status) values(8,'Rose',3);
        insert into tb_user (id,username ,status) values(9,'Coco',2);
        insert into tb_user (id,username ,status) values(10,'Lily',1);


5 应用指定算法
    1). 介绍
        运行阶段由应用自主决定路由到那个分片 , 直接根据字符子串（必须是数字）计算分片号。
        (PDF)

    2). 配置
        schema.xml 中逻辑表配置：
            <!-- 应用指定算法 -->
            <table name="tb_app" dataNode="dn4,dn5,dn6" rule="sharding-by-substring" />
        schema.xml 中数据节点配置：
            <dataNode name="dn4" dataHost="dhost1" database="itcast" />
            <dataNode name="dn5" dataHost="dhost2" database="itcast" />
            <dataNode name="dn6" dataHost="dhost3" database="itcast" />
        rule.xml 中分片规则配置：
            <tableRule name="sharding-by-substring">
                <rule>
                    <columns>id</columns>
                    <algorithm>sharding-by-substring</algorithm>    -- 对应下面的tableRule
                </rule>
            </tableRule>
            <function name="sharding-by-substring" class="io.mycat.route.function.PartitionDirectBySubString">
                <property name="startIndex">0</property> <!-- zero-based -->
                <property name="size">2</property>
                <property name="partitionCount">3</property>
                <property name="defaultPartition">0</property>
            </function>

        分片规则属性含义：
            属性                 描述
            columns             标识将要分片的表字段
            algorithm           指定分片函数与function的对应关系
            class               指定该分片算法对应的类
            startIndex          字符子串起始索引
            size                字符长度
            partitionCount      分区(分片)数量
            defaultPartition    默认分片(在分片数量定义时, 字符标示的分片编号不在分片数量内时,使用默认分片)

        示例说明 :
            id=05-100000002 , 在此配置中代表根据id中从 startIndex=0，开始，截取siz=2位数字即
            05，05就是获取的分区，如果没找到对应的分片则默认分配到defaultPartition 。

    3). 测试
        配置完毕后，重新启动MyCat，然后在mycat的命令行中，执行如下SQL创建表、并插入数据，查看数据分布情况。
        create table tb_app (
            id varchar(10) NOT NULL COMMENT 'ID',
            name varchar(200) DEFAULT NULL COMMENT '名称',
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        insert into tb_app (id,name) values('0000001','Testx00001');
        insert into tb_app (id,name) values('0100001','Test100001');
        insert into tb_app (id,name) values('0100002','Test200001');
        insert into tb_app (id,name) values('0200001','Test300001');
        insert into tb_app (id,name) values('0200002','TesT400001');


6 固定分片hash算法 sharding-by-long-hash
    1). 介绍
        该算法类似于十进制的求模运算，但是为二进制的操作，例如，取 id 的二进制低 10 位 与
        1111111111 进行位 & 运算，位与运算最小值为 0000000000，最大值为1111111111，转换为十
        进制，也就是位于0-1023之间。
        (PDF)
        特点：
            - 如果是求模，连续的值，分别分配到各个不同的分片；但是此算法会将连续的值可能分配到相同的分片，降低事务处理的难度。
            - 可以均匀分配，也可以非均匀分配。
            - 分片字段必须为数字类型。

    2). 配置
        schema.xml 中逻辑表配置：
            <table name="tb_longhash" dataNode="dn4,dn5,dn6" rule="sharding-by-long-hash"/>

        schema.xml 中数据节点配置：
            <dataNode name="dn4" dataHost="dhost1" database="itcast"/>
            <dataNode name="dn5" dataHost="dhost2" database="itcast"/>
            <dataNode name="dn6" dataHost="dhost3" database="itcast"/>

        rule.xml 中分片规则配置：
            <tableRule name="sharding-by-long-hash">
                <rule>
                    <columns>id</columns>
                    <algorithm>sharding-by-long-hash</algorithm>    -- 对应下面的tableRule
                </rule>
            </tableRule>
            <!-- 分片总长度为1024，count与length数组长度必须一致； -->
            <function name="sharding-by-long-hash" class="io.mycat.route.function.PartitionByLong">
                <property name="partitionCount">2,1</property>
                <property name="partitionLength">256,512</property>
            </function>

        分片规则属性含义：
            属性             描述
            columns         标识将要分片的表字段名
            algorithm       指定分片函数与function的对应关系
            class           指定该分片算法对应的类
            partitionCount  分片个数列表
            partitionLength 分片范围列表

        约束 :
            1). 分片长度 : 默认最大2^10 , 为 1024 ;
            2). count, length的数组长度必须是一致的 ;
            以上分为三个分区:0-255,256-511,512-1023

        示例说明 :
            (PDF)

    3). 测试
        配置完毕后，重新启动MyCat，然后在mycat的命令行中，执行如下SQL创建表、并插入数据，查看数据分布情况。

        CREATE TABLE tb_longhash (
            id int(11) NOT NULL COMMENT 'ID',
            name varchar(200) DEFAULT NULL COMMENT '名称',
            firstChar char(1) COMMENT '首字母',
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        insert into tb_longhash (id,name,firstChar) values(1,'七匹狼','Q');
        insert into tb_longhash (id,name,firstChar) values(2,'八匹狼','B');
        insert into tb_longhash (id,name,firstChar) values(3,'九匹狼','J');
        insert into tb_longhash (id,name,firstChar) values(4,'十匹狼','S');
        insert into tb_longhash (id,name,firstChar) values(5,'六匹狼','L');
        insert into tb_longhash (id,name,firstChar) values(6,'五匹狼','W');
        insert into tb_longhash (id,name,firstChar) values(7,'四匹狼','S');
        insert into tb_longhash (id,name,firstChar) values(8,'三匹狼','S');
        insert into tb_longhash (id,name,firstChar) values(9,'两匹狼','L');


7 字符串hash解析算法 sharding-by-stringhash
    1). 介绍
        截取字符串中的指定位置的子字符串, 进行hash算法， 算出分片。
        (PDF)

    2). 配置
        schema.xml 中逻辑表配置：
            <table name="tb_strhash" dataNode="dn4,dn5" rule="sharding-by-stringhash"/>

        schema.xml 中数据节点配置：
            <dataNode name="dn4" dataHost="dhost1" database="itcast"/>
            <dataNode name="dn5" dataHost="dhost2" database="itcast"/>

        rule.xml 中分片规则配置：
            <tableRule name="sharding-by-stringhash">
                <rule>
                    <columns>name</columns>
                    <algorithm>sharding-by-stringhash</algorithm>    -- 对应下面的tableRule
                </rule>
            </tableRule>
            <function name="sharding-by-stringhash"
            class="io.mycat.route.function.PartitionByString">
                <property name="partitionLength">512</property> <!-- zero-based -->
                <property name="partitionCount">2</property>
                <property name="hashSlice">0:2</property>
            </function>

        分片规则属性含义：
            属性                 描述
            columns             标识将要分片的表字段
            algorithm           指定分片函数与function的对应关系
            class               指定该分片算法对应的类
            partitionLength     hash求模基数 ; length*count=1024 (出于性能考虑)
            partitionCount      分区数
            hashSlice           hash运算位 , 根据子字符串的hash运算 ; 0 代表 str.length(), -1 代表 str.length()-1 , 大于0只代表数字自身 ; 可以理解为substring（start，end），start为0则只表示0

        示例说明：
            (PDF)

    3). 测试
        配置完毕后，重新启动MyCat，然后在mycat的命令行中，执行如下SQL创建表、并插入数据，查看数据分布情况。

        create table tb_strhash(
            name varchar(20) primary key,
            content varchar(100)
        )engine=InnoDB DEFAULT CHARSET=utf8mb4;
        insert into tb_strhash (name,content) values('T1001', UUID());
        insert into tb_strhash (name,content) values('ROSE', UUID());
        insert into tb_strhash (name,content) values('JERRY', UUID());
        insert into tb_strhash (name,content) values('CRISTINA', UUID());
        insert into tb_strhash (name,content) values('TOMCAT', UUID());


8 按天分片算法
    1). 介绍
        按照日期及对应的时间周期来分片。
        (PDF)

    2). 配置
        schema.xml 中逻辑表配置：
            <table name="tb_datepart" dataNode="dn4,dn5,dn6" rule="sharding-by-date"/>

        schema.xml中数据节点配置：
            <dataNode name="dn4" dataHost="dhost1" database="itcast"/>
            <dataNode name="dn5" dataHost="dhost2" database="itcast"/>
            <dataNode name="dn6" dataHost="dhost3" database="itcast"/>

        rule.xml 中分片规则配置：
            <tableRule name="sharding-by-date">
                <rule>
                    <columns>create_time</columns>
                    <algorithm>sharding-by-date</algorithm>    -- 对应下面的tableRule
                </rule>
            </tableRule>
            <function name="sharding-by-date" class="io.mycat.route.function.PartitionByDate">
                <property name="dateFormat">yyyy-MM-dd</property>
                <property name="sBeginDate">2022-01-01</property>
                <property name="sEndDate">2022-01-30</property>
                <property name="sPartionDay">10</property>
            </function>
            <!--
            从开始时间开始，每10天为一个分片，到达结束时间之后，会重复开始分片插入
            配置表的 dataNode 的分片，必须和分片规则数量一致，例如 2022-01-01 到 2022-12-31 ，每
            10天一个分片，一共需要37个分片。
            -->

        分片规则属性含义：
            属性             描述
            columns         标识将要分片的表字段
            algorithm       指定分片函数与function的对应关系
            class           指定该分片算法对应的类
            dateFormat      日期格式
            sBeginDate      开始日期
            sEndDate        结束日期，如果配置了结束日期，则代码数据到达了这个日期的分片后，会重复从开始分片插入
            sPartionDay     分区天数，默认值 10 ，从开始日期算起，每个10天一个分区

    3). 测试
        配置完毕后，重新启动MyCat，然后在mycat的命令行中，执行如下SQL创建表、并插入数据，查看数据分布情况。
            create table tb_datepart(
                id bigint not null comment 'ID' primary key,
                name varchar(100) null comment '姓名',
                create_time date null
            );
            insert into tb_datepart(id,name ,create_time) values(1,'Tom','2022-01-01');
            insert into tb_datepart(id,name ,create_time) values(2,'Cat','2022-01-10');
            insert into tb_datepart(id,name ,create_time) values(3,'Rose','2022-01-11');
            insert into tb_datepart(id,name ,create_time) values(4,'Coco','2022-01-20');
            insert into tb_datepart(id,name ,create_time) values(5,'Rose2','2022-01-21');
            insert into tb_datepart(id,name ,create_time) values(6,'Coco2','2022-01-30');
            insert into tb_datepart(id,name ,create_time) values(7,'Coco3','2022-01-31');


9 自然月分片
    1). 介绍
        使用场景为按照月份来分片, 每个自然月为一个分片。
        (PDF)

    2). 配置
        schema.xml 中逻辑表配置：
        <table name="tb_monthpart" dataNode="dn4,dn5,dn6" rule="sharding-by-month"/>

        schema.xml 中数据节点配置：
            <dataNode name="dn4" dataHost="dhost1" database="itcast"/>
            <dataNode name="dn5" dataHost="dhost2" database="itcast"/>
            <dataNode name="dn6" dataHost="dhost3" database="itcast"/>

        rule.xml 中分片规则配置：
            <tableRule name="sharding-by-month">
                <rule>
                    <columns>create_time</columns>
                    <algorithm>partbymonth</algorithm>    -- 对应下面的tableRule
                </rule>
            </tableRule>
            <function name="partbymonth" class="io.mycat.route.function.PartitionByMonth">
                <property name="dateFormat">yyyy-MM-dd</property>
                <property name="sBeginDate">2022-01-01</property>
                <property name="sEndDate">2022-03-31</property>
            </function>
            <!--
            从开始时间开始，一个月为一个分片，到达结束时间之后，会重复开始分片插入
            配置表的 dataNode 的分片，必须和分片规则数量一致，例如 2022-01-01 到 2022-12-31 ，一
            共需要12个分片。
            -->

        分片规则属性含义：
            属性             描述
            columns         标识将要分片的表字段
            algorithm       指定分片函数与function的对应关系
            class           指定该分片算法对应的类
            dateFormat      日期格式
            sBeginDate      开始日期
            sEndDate        结束日期，如果配置了结束日期，则代码数据到达了这个日期的分片后，会重复从开始分片插入

    3). 测试
        配置完毕后，重新启动MyCat，然后在mycat的命令行中，执行如下SQL创建表、并插入数据，查看数据分布情况。
        create table tb_monthpart(
            id bigint not null comment 'ID' primary key,
            name varchar(100) null comment '姓名',
            create_time date null
        );
        insert into tb_monthpart(id,name ,create_time) values(1,'Tom','2022-01-01');
        insert into tb_monthpart(id,name ,create_time) values(2,'Cat','2022-01-10');
        insert into tb_monthpart(id,name ,create_time) values(3,'Rose','2022-01-31');
        insert into tb_monthpart(id,name ,create_time) values(4,'Coco','2022-02-20');
        insert into tb_monthpart(id,name ,create_time) values(5,'Rose2','2022-02-25');
        insert into tb_monthpart(id,name ,create_time) values(6,'Coco2','2022-03-10');
        insert into tb_monthpart(id,name ,create_time) values(7,'Coco3','2022-03-31');
        insert into tb_monthpart(id,name ,create_time) values(8,'Coco4','2022-04-10');
        insert into tb_monthpart(id,name ,create_time) values(9,'Coco5','2022-04-30');
