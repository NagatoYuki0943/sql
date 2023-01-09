1 列子查询:   返回的结果是一列(一列多行,同一列名多个值)

2 语法
    用 in
    主查询 where 条件 in (子列查询)
    select * from 数据源 where 条件判断 in (select 字段名 from 数据源 where 条件判断) //返回集合

    //在表1中获取id小于5的学生的id,再根据姓名从表2中获取这些同学的信息
    select * from students2 where name in (select name from students1 where id < 5);
    +----+------+--------+-----+-------+-------+
    | id | name | sex    | age | class | score |
    +----+------+--------+-----+-------+-------+
    |  1 | 赵一 | male   |  15 |     1 |    58 |
    |  2 | 钱二 | female |  16 |     2 |    55 |
    |  3 | 孙三 | male   |  16 |     2 |    88 | //students1只有 1 2 3 没有4
    +----+------+--------+-----+-------+-------+