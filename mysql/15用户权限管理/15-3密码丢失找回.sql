密码丢失解决方案:忘记了root密码,需要找回或者重置root用户密码

1 停止服务
    net stop mysql

2 重新启动服务:mysqld.exe --skip-grant-tables //启动服务器,但是跳过权限管理

3 当前启动的服务器没有权限概念,非常危险,任何客户端,不需要任何用户信息都可以直接登录,而且是root权限
    新开客户端,使用mysql.exe登录即可,直接输入mysql就可以登录

4 修改root用户密码:指定用户名@host
    updaet mysql.user set password=password('root') where user = 'root' and host = 'localhost';

5 赶紧关闭服务并启动