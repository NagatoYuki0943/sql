1 表子查询:   返回的结果是多行多列,表字查询和行子查询非常相近,行子查询要产生行元素,二表子查询没有
    行子查询用于where条件判断:where子查询
    表子查询用于from:from子查询

    查询得到的多行多列信息也可以使用 in 来进行匹配

2 语法
    select 字段表 from (子查询) as 别名 [where] [group by] [having] [limit];

    1.将每个班分数最高的学生排在最前面
    2.针对结果进行group by:保留每组第一个

    group by只返回第一个字段
    select * from (select * from mb_students1 order by score desc) as s1 group by class;

    select * from (select * from mb_students1 limit 5) as s1 where s1.id=1;
    +----+------+------+-----+-------+-------+
    | id | name | sex  | age | class | score |
    +----+------+------+-----+-------+-------+
    |  1 | 赵一 | male |  15 |     1 |    58 |
    +----+------+------+-----+-------+-------+


    案例:
    A. 查询与 "鹿杖客" , "宋远桥" 的职位和薪资相同的员工信息
    分解为两步执行:
    ①. 查询 "鹿杖客" , "宋远桥" 的职位和薪资
    select job, salary from emp where name = '鹿杖客' or name = '宋远桥';

    ②. 查询与 "鹿杖客" , "宋远桥" 的职位和薪资相同的员工信息
    select * from emp where (job,salary) in ( select job, salary from emp where name = '鹿杖客' or name = '宋远桥' );


    B. 查询入职日期是 "2006-01-01" 之后的员工信息 , 及其部门信息
    分解为两步执行:
    ①. 入职日期是 "2006-01-01" 之后的员工信息
    select * from emp where entrydate > '2006-01-01';

    ②. 查询这部分员工, 对应的部门信息;
    select e.*, d.* from (select * from emp where entrydate > '2006-01-01') e left join dept d on e.dept_id = d.id ;