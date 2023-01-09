1.字符是各种文字和符号的总称,包括国家文字,标点符号,图形符号,数字等.
在计算机中看到的所有内容都是字符

字符编码(character code)是计算机针对各种符号,在计算机中的一种二进制存储代号

字符集是多个字符的集合,字符集种类较多,每个字符集包含的字符个数不同
ASCII字符集 GB2312 BIG5 GB18030 Unicode

2.设置MySQL字符集

    通过命令存入中文可能出错
    出错原因:
        1.用户通过mysql.exe来操作mysqld.exe
        2.真正的sql执行时mysqld.exe执行
        3.mysql.exe将数据传入mysqld.exe的时候没有告知字符集,
          mysqld.exe不判断字符集,它使用自己的字符集,就出现了问题
    解决方案:
        mysql.exe客户端在进行数据操作之前将自己的字符集告诉mysqld.exe
        cmd中使用gbk的字符集

    快捷方式: set names 字符集;
        set names gbk;
    深层原理:
    处理一共分为3层, set names 会改变3层
        客户端传入数据服务端 client
        客户端返回数据给客户端 server
        客户端与服务端之间的连接 connection
        set names 本质就是一次打通3层关系的字符集,变得一致
        系统中有3个变量来记录着这三个关系对应的字符集:show variables like 'character_set%';

        show variables like 'character_set%';
        +--------------------------+--------------------------------------------------------+
        | Variable_name            | Value                                                  |
        +--------------------------+--------------------------------------------------------+
        | character_set_client     | utf8mb4          客户端                                |
        | character_set_connection | utf8mb4          连接                                  |
        | character_set_database   | utf8             数据库                                |
        | character_set_filesystem | binary                                                 |
        | character_set_results    | utf8mb4          返回值                                |
        | character_set_server     | utf8                                                   |
        | character_set_system     | utf8                                                   |
        | character_sets_dir       | D:\phpstudy_pro\Extensions\MySQL8.0.12\share\charsets\ |
        +--------------------------+--------------------------------------------------------+

    修改服务器端变量的值
        set 变量名 = 值 ;
        set character_set_client = gbk;
        +--------------------------+--------------------------------------------------------+
        | Variable_name            | Value                                                  |
        +--------------------------+--------------------------------------------------------+
        | character_set_client     | gbk                                                    |
        | character_set_connection | utf8mb4                                                |
        | character_set_database   | utf8                                                   |
        | character_set_filesystem | binary                                                 |
        | character_set_results    | utf8mb4                                                |
        | character_set_server     | utf8                                                   |
        | character_set_system     | utf8                                                   |
        | character_sets_dir       | D:\phpstudy_pro\Extensions\MySQL8.0.12\share\charsets\ |
        +--------------------------+--------------------------------------------------------+

        这样也能存入,但是查询会出错,有乱码 因为client是gbk,results是utf8,把results也改为gkb就没有乱码了

        connection只是为了更方便客户端与服务端进行字符集转换而设
        set name gbk; 相当于下面三行
        set character_set_client=gbk;     //为了让服务器识别客户端传来的数据
        set character_set_connection=gbk; //更好的帮助客户端与服务端之间进行字符集转换
        set character_set_results=gbk;    //为了告诉客户端 服务端所有的返回的数据字符集
