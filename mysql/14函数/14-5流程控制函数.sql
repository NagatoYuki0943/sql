1 if(value , t , f)
    如果value为true,则返回t,否则返回f

    select if(1, 'OK', 'error');
    +----------------------+
    | if(1, 'OK', 'error') |
    +----------------------+
    | OK                   |
    +----------------------+

    select score from students1 where id=1;
    +-------+
    | score |
    +-------+
    |    58 |
    +-------+
    select if((select score from students1 where id=1 > 60), '及格', '不及格');
    +------------------------------------------------------------------------+
    | if((select score from students1 where id=1 > 60), '及格', '不及格') |
    +------------------------------------------------------------------------+
    | 不及格                                                                 |
    +------------------------------------------------------------------------+


2 ifnull(value1 , value2)
    如果value1不为空,返回value1,否则返回value2

    select ifnull(null, 'default');
    +-------------------------+
    | ifnull(null, 'default') |
    +-------------------------+
    | default                 |
    +-------------------------+

    select ifnull('', 'default');
    +-----------------------+
    | ifnull('', 'default') |
    +-----------------------+
    |                       |
    +-----------------------+

    select score from students1 where id=19;
    +-------+
    | score |
    +-------+
    | NULL  |
    +-------+
    select ifnull((select score from students1 where id=19), '没考试');
    +----------------------------------------------------------------+
    | ifnull((select score from students1 where id=19), '没考试') |
    +----------------------------------------------------------------+
    | 没考试                                                         |
    +----------------------------------------------------------------+


3 case
  when [ val1 ] then [res1] ...
  else [ default ]
  end
    如果val1为true,返回res1,... 否则返回default默认值

        >=85分 优秀 >=60 及格 <60 不及格
        select id, name,
            (case when math>=85    then '优秀' when math>=60    then '及格' else '不及格' end) as '数学',
            (case when english>=85 then '优秀' when english>=60 then '及格' else '不及格' end) as '英语',
            (case when chinese>=85 then '优秀' when chinese>=60 then '及格' else '不及格' end) as '语文'
        from students4;
        +----+------+--------+------+------+
        | id | name | 数学   | 英语 | 语文 |
        +----+------+--------+------+------+
        |  1 | Tom  | 及格   | 优秀 | 优秀 |
        |  2 | Rose | 不及格 | 及格 | 优秀 |
        |  3 | Jack | 不及格 | 优秀 | 及格 |
        +----+------+--------+------+------+


4 case [ expr ]
  when [ val1 ] then [res1] ...
  else [ default ]
  end
    如果expr的值等于val1,返回res1,... 否则返回default默认值

    select name, case class when 1 then '一班' when 2 then '二班' else '其它' end as '班级' from students1 limit 10;
    +------+------+
    | name | 班级 |
    +------+------+
    | 赵一 | 一班 |
    | 钱二 | 二班 |
    | 孙三 | 二班 |
    | 李四 | 一班 |
    | 周五 | 二班 |
    | 吴六 | 一班 |
    | 郑七 | 一班 |
    | 王八 | 其它 |
    | 冯九 | 其它 |
    | 陈十 | 其它 |
    +------+------+
