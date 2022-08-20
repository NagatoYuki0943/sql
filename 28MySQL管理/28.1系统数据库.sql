1 系统数据库
    Mysql数据库安装完成后，自带了一下四个数据库，具体作用如下：

    数据库                  含义
    mysql               存储MySQL服务器正常运行所需要的各种信息 （时区、主从、用户、权限等）
    information_schema  提供了访问数据库元数据的各种表和视图，包含数据库、表、字段类型及访问权限等
    performance_schema  为MySQL服务器运行时状态提供了一个底层监控功能，主要用于收集数据库服务器性能参数
    sys                 包含了一系列方便 DBA 和开发人员利用 performance_schema性能数据库进行性能调优和诊断的视图

