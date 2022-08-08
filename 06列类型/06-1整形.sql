整形分类
1 tinyint 迷你整形
    系统采用1字节保存 0~255

2 smallint 小整形
    系统采用2个字节 0~65535

3 mediumint 中整形
    系统采用3个字节

4 int 整形
    系统采用4个字节

5 bigint
    系统采用8个字节

    create mb_int3(
        int_1 tinyint,
        int_2 smallint,
        int_3 mediumint,
        int_4 int,
        int_5 bigint
    )charset utf8;

insert into mb_int3 values(255,100000,100000,100000000,100000000000);
    255插入不进去,因为默认有负数 所以范围是-128~127

6 无符号设定
    只有正数
    基本语法:在类型之后加上 unsigned
    alter table mb_int3 add int_6 tinyint unsigned;
    insert into mb_int3 values(10,10000,100000,100000000,100000000000,255);
    可以插入
