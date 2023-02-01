1. 启动服务
    # 指定路径启动
    mongod --dbpath=..\data\db

    # 配置文件启动
    mongod -f ../config/mongod.conf
    或
    mongod --config ../config/mongod.conf


2. shell连接
    mongosh
    或
    mongosh --host=127.0.0.1 --port=27017
