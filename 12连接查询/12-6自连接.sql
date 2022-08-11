1 自己连接自己
    select 字段列表 from 表A 别名A join 表A 别名B on 条件
    可以 inner left right 连接


    查询员工 及其 所属领导的名字
    表结构: emp
    select a.name , b.name from emp a inner join emp b on a.managerid = b.id;
    select a.name , b.name from emp a , emp b where a.managerid = b.id;


    查询所有员工 emp 及其领导的名字 emp , 如果员工没有领导, 也需要查询出来表结构: emp a , emp b
    select a.name '员工', b.name '领导' from emp a left join emp b on a.managerid = b.id;
