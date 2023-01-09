在MySQL中有一项规定:MySQL的记录长度(record == 行)总长度不能超过65535个字节

varchar能够存储的理论值为65535个字符:字符在不同的字符集下坑能占用多个字节

1. 创建表:证明varchar在MySQL中能够达到的理论值(utf8和gbk)
    varcahr除了存储的数据本身要存储空间,还要记录长度
    create table varchar(
        name varchar(65535)
    )charset utf8;
    //存不进去,太大了
    Column length too big for column 'name' (max = 21845); use BLOB or TEXT instead

2. 计算utf8和gbk下对应的varchar的长度
    utf8 65535 / 3 = 21845     如果采用varchar还需要两个额外的字节保存长度
    utf8最多 21844

    gbk  65535 / 2 = 32767...1 如果采用varchar还需要两个额外的字节保存长度
    gbk 最多 32766

    create table utf(
        name varchar(21845)
    )charset utf8;
    //还是太长,最多21844
    Row size too large. The maximum row size for the used table type, not counting BLOBs, is 65535. This includes storage overhead, check the manual. You have to change some columns to TEXT or BLOBs

    create table utf(
        name varchar(21844)
    )charset utf8;
    Query OK


    create table gbk(
        name varchar(32767)
    )charset gbk;
    //还是太长,最多32766
    Row size too large. The maximum row size for the used table type, not counting BLOBs, is 65535. This includes storage overhead, check the manual. You have to change some columns to TEXT or BLOBs

    create table gbk(
        name varchar(32766)
    )charset gbk;
    Query OK
