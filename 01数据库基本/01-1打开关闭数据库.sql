MySQL是一种C/S结构
服务端对应软件:Mysqld.exe

前提:这两个命令要把mysql服务添加到进去
启动:   Net start mysql
关闭:   Net stop mysql

连接musql数据库
    1.找到mysql.exe
    2.输入对应的服务器地址:
        -h : host   -h[IP地址/域名]
    3.输入服务器中MySQL监听的端口:
        -P:port     -p3306
    4.输入用户名:
        -u:username -uroot
    5.输入密码:
        -p:password -proot
基本语法: mysql -h主机地址 -P端口 -u用户名 -p密码

退出:
    Exit;   有分号
    Quit;
    \q;     Quit缩写


