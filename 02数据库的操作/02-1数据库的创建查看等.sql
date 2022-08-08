1.创建数据库
    create database [if not exists] 数据库名字 [default charset 字符集] [collate 排序规则];
    库选项
        字符集: charset 字符集,代表当前数据库下的所有表存储的数据默认指定的字符集(如果当前不指定,那么才懂DBMS默认的)
        校对集: collate 校对集
        create database mb;
        create database mb charset utf8mb4;

2.显示数据库
    (1).创建数据库,会产生相应的文件夹,在data目录下
        opt文件是数据库选项
    (2).显示全部数据库  show databases;
    (3).显示部分数据库  show databases like "匹配模式";
        _:匹配当前位置单个字符
        %:匹配指定位置多个字符
        a.获取以my开头的全部数据库: "my%"
        b.获取以m开头,后面第一个字母不确定,但是最后为database的数据库: "m_database"
        c.获取以database结尾的数据库: "%database"

3.显示创建数据库
    show create database 数据库名字;
    看到的指令并非原始指令,系统加工过

4.选择数据库
    use 数据库名字;

5.删除数据库
    drop database [if exists] 数据库名字
    删除之后文件夹就没了

6.
    select database(); 查询当前所在的数据库