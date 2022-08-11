新创建的用户没有使用权限
    use mb;
    ERROR 1044 (42000): Access denied for user 'user1'@'%' to database 'mb'

1 权限管理
    (0) all allprivileges 全部权限
    (1) 数据权限:增删改查(select,insert,update,delete)
    (2) 结构权限:结构操作(create,drop,alert)
    (3) 管理权限:权限管理(create,user,grant,revoke) 通常只给管理员
    grant:授予
    revoke:annul,abolish,abrogate,rescind,repeal 废除

2 show 查询权限
    基本语法: show grants for '用户名'@'主机名';
        测试:
        show grants for 'user1'@'';
        +----------------------------------+
        | Grants for user1@                |
        +----------------------------------+
        | GRANT USAGE ON *.* TO `user1`@`` |
        +----------------------------------+

3 grant 授予权限
    将权限分配给指定的用户
    基本语法: grant 权限列表 on 数据库(*).表名(*) to '用户名'@'主机名';  //使用*而不是% ,在没有""时用* ,有""时用%
    权限列表:使用逗号分隔,但可以使用 all privileges 代表全部权限
    数据库.表名:可以使单表(数据库.表名),可以使某个数据库(数据库.*),也可以是整库(*.*)

        测试:给查看(select)权限
        grant select on mb.* to `user1`@'';
        Query OK, 0 rows affected (0.26 sec)

        //user1就可以使用了,不需要退出重进,直接可以使用
        select * from mb_int1;
        +----+-------+
        | id | int_1 |
        +----+-------+
        |  1 |     1 |
        |  2 |     2 |
        |  3 |     4 |
        |  4 |    55 |
        |  5 |    51 |
        |  6 |     3 |
        |  7 |     3 |
        |  8 |     5 |
        |  9 |     8 |
        | 10 |     0 |
        +----+-------+
        10 rows in set (0.00 sec)

    给几个数据库以及几张表,使用 show 时就只能看到几个

4 revoke 权限回收
    将权限从用户手中回收
    基本语法: revoke 权限列表/all privileges on 数据库(*).数据表(*) from '用户名'@'主机名';

        测试:
        revoke all on mb.* from `user1`@'';

        //访问不了了
        //user1立刻不能使用了
        select * from mb_int1;
        ERROR 2006 (HY000): MySQL server has gone away
        No connection. Trying to reconnect...
        ERROR 1044 (42000): Access denied for user 'user1'@'' to database 'mb'
        ERROR:
        Can t connect to the server


5 flush 刷新权限
    将当前对用户的权限操作,进行一个刷新,将操作的具体内容同步到对应的表中.
    基本语法: flush privileges;

        测试:
        flush privileges;
        Query OK, 0 rows affected (0.14 sec)
