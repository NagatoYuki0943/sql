1 介绍
    存储函数是有返回值的存储过程，存储函数的参数只能是IN类型的。

2 语法
    CREATE FUNCTION 存储函数名称 ([ 参数列表 ])
    RETURNS type [characteristic ...]
    BEGIN
        -- SQL语句
        RETURN ...;
    END ;

    characteristic说明：
        DETERMINISTIC：相同的输入参数总是产生相同的结果
        NO SQL ：不包含 SQL 语句。
        READS SQL DATA：包含读取数据的语句，但不包含写入数据的语句。

    在mysql8.0版本中binlog默认是开启的，一旦开启了，mysql就要求在定义存储过程时，需要指定
    characteristic特性，否则就会报如下错误：


2  案例
    计算从1累加到n的值，n为传入的参数值。

    create function fun1(n int)
    returns int deterministic
    begin
        declare total int default 0;
        while n>0 do
            set total := total + n;
            set n := n - 1;
        end while;
        return total;
    end;

    select fun1(50);
