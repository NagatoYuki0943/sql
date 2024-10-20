# 下载

https://www.postgresql.org/download/

# cmd

## `pg_ctl`



```sh
 pg_ctl --help
pg_ctl 是一个用于初始化、启动、停止或控制PostgreSQL服务器的工具.

使用方法:
  pg_ctl init[db]   [-D 数据目录] [-s] [-o 选项]
  pg_ctl start      [-D 数据目录] [-l 文件名] [-W] [-t 秒数] [-s]
                    [-o 选项] [-p 路径] [-c]
  pg_ctl stop       [-D 数据目录] [-m SHUTDOWN-MODE] [-W] [-t 秒数] [-s]
  pg_ctl restart    [-D 数据目录] [-m SHUTDOWN-MODE] [-W] [-t 秒数] [-s]
                    [-o 选项] [-c]
  pg_ctl reload     [-D 数据目录] [-s]
  pg_ctl status     [-D 数据目录]
  pg_ctl promote    [-D 数据目录] [-W] [-t 秒数] [-s]
  pg_ctl logrotate  [-D 数据目录] [-s]
  pg_ctl kill       信号名称 进程号
  pg_ctl register   [-D 数据目录] [-N 服务名称] [-U 用户名] [-P 口令]
                    [-S 启动类型] [-e 源] [-W] [-t 秒数] [-s] [-o 选项]
  pg_ctl unregister [-N 服务名称]

普通选项:
  -D, --pgdata=数据目录  数据库存储区域的位置
  -e SOURCE              当作为一个服务运行时要记录的事件的来源
  -s, --silent           只打印错误信息, 没有其他信息
  -t, --timeout=SECS     当使用-w 选项时需要等待的秒数
  -V, --version          输出版本信息, 然后退出
  -w, --wait             等待直到操作完成(默认)
  -W, --no-wait          不用等待操作完成
  -?, --help             显示此帮助, 然后退出
如果省略了 -D 选项, 将使用 PGDATA 环境变量.

启动或重启的选项:
  -c, --core-files       在这种平台上不可用
  -l, --log=FILENAME     写入 (或追加) 服务器日志到文件FILENAME
  -o, --options=OPTIONS  传递给postgres的命令行选项
                         (PostgreSQL 服务器执行文件)或initdb
  -p PATH-TO-POSTMASTER  正常情况不必要

停止或重启的选项:
  -m, --mode=MODE        可以是 "smart", "fast", 或者 "immediate"

关闭模式有如下几种:
  smart       所有客户端断开连接后退出
  fast        直接退出, 正确的关闭（默认）
  immediate   不完全的关闭退出; 重启后恢复

允许关闭的信号名称:
  ABRT HUP INT KILL QUIT TERM USR1 USR2

注册或注销的选项:
  -N 服务名称     注册到 PostgreSQL 服务器的服务名称
  -P 口令         注册到 PostgreSQL 服务器帐户的口令
  -U 用户名       注册到 PostgreSQL 服务器帐户的用户名
  -S START-TYPE   注册到PostgreSQL服务器的服务启动类型

启动类型有:
  auto       在系统启动时自动启动服务(默认选项)
  demand     按需启动服务

臭虫报告至<pgsql-bugs@lists.postgresql.org>.
PostgreSQL 主页: <https://www.postgresql.org/>
```

### init

```sh
pg_ctl init[db]   [-D 数据目录] [-s] [-o 选项]

pg_ctl init -D D:\sql\PostgreSQL\17\data
```

### start

```sh
pg_ctl start      [-D 数据目录] [-l 文件名] [-W] [-t 秒数] [-s]
                  [-o 选项] [-p 路径] [-c]

pg_ctl start -D D:\sql\PostgreSQL\17\data
```

### stop

```sh
pg_ctl stop       [-D 数据目录] [-m SHUTDOWN-MODE] [-W] [-t 秒数] [-s]

pg_ctl stop -D D:\sql\PostgreSQL\17\data
```

### restart

```sh
pg_ctl restart    [-D 数据目录] [-m SHUTDOWN-MODE] [-W] [-t 秒数] [-s]
                  [-o 选项] [-c]

pg_ctl restart -D D:\sql\PostgreSQL\17\data
```

### 连接

超级用户`postgres`连接默认的`postgres`数据库

```sh|
psql -d postgres
```

创建用户同时设置密码

```sql
创建用户、数据库
创建用户:
CREATE USER your_username WITH PASSWORD your_password SUPERUSER;
CREATE USER postgres WITH PASSWORD 'postgres' SUPERUSER;
创建数据库:
CREATE DATABASE database_name OWNER your_username;
CREATE DATABASE mb OWNER postgres;
```

