1.设置表选项
    表属性指的就是表选项:engine,charset,collate
    语法:alter table 表名 表选项 [=] 值
    alter table mb_int3 charset=gbk

    注意:如果数据库已经有数据了, 不要轻易修改表选项

2.修改表结构
    (1).修改表名:   rename table 旧表名 to 新表名
        rename table mb_students6_1 to mb_students6;

    (2).新增列:     alter table 表名 add [column] 新列名 列类型 [列属性] [位置first,after]
        默认加到表的最后面,first放到最前面,after+字段名,放到谁的后面
        alter table mb_students6 add birthday date comment '生日';

    (3).修改列属性: alter table 表名 modify 列名 新类型 [新属性] [新位置]
        alter table mb_students6 modify name varchar(100);

    (4).修改列名:   alter table 表名 change 旧列名 新列名 列类型 [列属性] [新位置]
        alter table mb_students6 change gender sex enum('male', 'female', 'futa') default 'futa' comment '性别';

    (5).删除列:     alter table 表名 drop 列名
        alter table mb_students6 drop birthday1;

3.删除表
    drop table 表名[,表名2];    表和内容全部删除    不可恢复
    drop table if exists 表名;

    truncate table 表名;        只删除内容          不可恢复  可以重置 auto_increment
    truncate 表名;              和上一行一样

    delete from 表名;           只删除内容          可以恢复  不会重置 auto_increment
    delete from mb_int2 limit n; //删除n条

4.添加主键/unique
    添加:
        alter table 表名 add primary key(id);
        alter table mb_score add primary key(key1,key2);  //多个组成复合主键,删除一次全部删除
        alter table 表名 add unique(id);
        alter table 表名 add unique key(id); 和上一行相同
        alter table mb_unique1 add unique(key1,key2); //可以一次添加多个

    删除:
        alter table 表名 drop primary key;
        alter table 表名 drop index id; //删除unique,不能使用drop unique

5.添加时间戳
    alter table 表名 add regTime timestamp not null default current_timestamp on update current_timestamp;
