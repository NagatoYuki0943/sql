1 整库数据备份也叫做sql数据备份,备份的结果都是sql指令
在MySQL中提供了一个专门用于备份sql的客户端:mysqldump.exe

2 应用场景
    sql备份是一种mysql非常常见的备份与还原方式,sql备份不只是数据备份,还备份对应的sql指令(表结构),
    即便是数据库遭到毁灭性破坏(数据库被删),那么利用sql备份依然可以实现数据还原

    sql备份需要备份结构,因此产生的备份文件特别大,因此不适合特大型数据备份,也不适合数据变换频繁性数据库备份

3 应用方案
    sql备份
    sql备份用到的是专门的备份客户端,因此还没与数据库服务器进行连接
    基本语法:
    使用cmd
        mysqldump/mysqldump.exe -hPup 数据库名字 [表1 [表2...]] > 备份文件地址  没有分号

    备份有三种方式
    (1)整库备份:只需要提供数据库名字

        mysqldump -hlocalhost -P3306 -uroot -proot mb > d:/phpstudy_pro/temp/mb.sql


    (2)单表备份:数据库后跟一张表

    (3)单表备份:数据库后跟多表
                               库名 表名用空格区分
        mysqldump -uroot -proot mb students1 students2 > d:/phpstudy_pro/temp/students.sql


    (4)查看数据
    DROP TABLE IF EXISTS `students2`;     //先删除
    /*!40101 SET @saved_cs_client     = @@character_set_client */;
    SET character_set_client = utf8mb4 ;
    CREATE TABLE `students2` (            //再创建
    `id` int(255) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
    `sex` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
    `age` int(255) DEFAULT NULL,
    `class` int(255) DEFAULT NULL,
    `score` int(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=MyISAM AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
    /*!40101 SET character_set_client = @saved_cs_client */;

    --
    -- Dumping data for table `students2`
    --

    LOCK TABLES `students2` WRITE;         //最后插入数据
    /*!40000 ALTER TABLE `students2` DISABLE KEYS */;
    INSERT INTO `students2` VALUES (1,'赵一','male',15,1,58),(2,'钱二','female',16,2,55),(3,'孙三','male',16,2,88),(4,'李四','male',11,1,100),(5,'周五','female',15,2,88),(6,'吴六','male',16,1,75),(7,'郑七','female',16,1,87),(8,'王八','male',16,3,88),(9,'冯九','male',14,3,45),(10,'陈十','female',14,4,85),(11,'褚十一','female',16,3,85),(55,'卫十二','male',17,4,85),(13,'蒋十三','female',13,5,33),(14,'沈十四','male',16,4,11),(15,'韩十五','female ',14,3,49),(16,'杨十六','male',17,5,94),(17,'朱十七','female',19,5,60),(18,'秦十八','male',17,4,11),(19,'尤十九','female ',11,5,0),(30,'许二十','male',17,6,44),(31,'何二十一','male',16,3,58),(32,'吕二十二','female',15,6,59),(33,'施二十三','male',14,5,86),(34,'张二十四','female',18,6,88),(35,'孔二十五','male',14,6,80),(36,'曹二十六','female',15,4,55);
    /*!40000 ALTER TABLE `students2` ENABLE KEYS */;
    UNLOCK TABLES;
    /*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

    (5)数据还原
        mysql提供了多种方式来实现:两种
        mysqldump备份的数据中没有关于数据库本身的操作,只有针对表的操作,当进行数据(sql还原),必须指定数据库
            a.利用mysql.exe客户端:没有登录之前,可以使用该客户端还原
                mysql.exe -hPup 数据库  < 文件位置

                mysql.exe -uroot -proot mb < d:/phpstudy_pro/temp/mb.sql
            b.在sql中提供了导入sql指令的方式
                source sql文件位置;//必须先进入到指定的数据库
            c.人为操作:打开备份文件,复制所有sql指令,然后执行(不推荐)
