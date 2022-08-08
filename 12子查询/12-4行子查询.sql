1 行子查询:   返回的结果是一行(一行多列,一条记录)

2 行元素
    字段元素是指一个字段对应的值,行元素对应的是多个字段,
    多个字段合起来作为一个元素参与运算,把这种情况称为行元素

3 语法
    主查询 where 条件 [(构造一个行元素)] = (行子查询);

    select * from mb_students2 where (age,score)=(select max(age),max(score) from mb_students1);
    Empty set

    select * from mb_students2 where (age,score)=(select min(age),min(score) from mb_students1);
    Empty set

    select * from mb_students2 where (age,score)=(select max(age),min(score) from mb_students1);
    Empty set

    //只有这个有数据
    select * from mb_students2 where (age,score)=(select min(age),max(score) from mb_students1);
    +----+------+------+-----+-------+-------+
    | id | name | sex  | age | class | score |
    +----+------+------+-----+-------+-------+
    |  4 | 李四 | male |  11 |     1 |   100 |
    +----+------+------+-----+-------+-------+

4 总结
    已经学过三个子查询:常见的三个子查询
    标量子查询,列子查询和行子查询:都属于where子查询