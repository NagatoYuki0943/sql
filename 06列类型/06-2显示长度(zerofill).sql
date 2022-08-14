mysql> desc int3;
+-------+---------------------+------+-----+---------+-------+
| Field | Type                | Null | Key | Default | Extra |
+-------+---------------------+------+-----+---------+-------+
| int_1 | tinyint(4)          | YES  |     | NULL    |       |
| int_2 | smallint(6)         | YES  |     | NULL    |       |
| int_3 | mediumint(9)        | YES  |     | NULL    |       |
| int_4 | int(11)             | YES  |     | NULL    |       |
| int_5 | bigint(20)          | YES  |     | NULL    |       |
| int_6 | tinyint(3) unsigned | YES  |     | NULL    |       |
+-------+---------------------+------+-----+---------+-------+

1.类型后面的数字代表显示长度
    显示长度是指数据(整形)在数据显示的时候到底可以显示多少位
        tinyint(3) 表示最长显示3位 unsigned只能说明是整数 0~255 3位
        tinyint(4) 表示最长显示4位 -128~127 -128四位

2.显示长度表示是否可以达到指定长度,不会自动满足到指定长度,
    数据显示的时候,保持最高位(显示长度,那么还需要给数据字段增加 zerofill属性)
    zerofill自动加unsigned,只能是整数,负数不能使用zerofill
    不足补零,超出或者正好不补
    alter table int3 add int_7 tinyint zerofill;

    |     1 |     1 |      1 |         1 |            1 |     1 |   001 |
                                                                会自动补0到3位

    不足补零,超出或者正好不补
    自己定义的时候可以自己定义长度
    如果数据超出自己定义的显示长度也没办法,也会输出,低于长度自动补0
    alter table int3 add int_8 tinyint(10) zerofill;