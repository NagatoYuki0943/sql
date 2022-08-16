1. 执行如下脚本，创建m_emp表与m_dept表并插入测试数据
    -- 创建m_dept表，并插入数据
    create table m_dept(
        id int auto_increment comment 'ID' primary key,
        name varchar(50) not null comment '部门名称'
    )comment '部门表';
    INSERT INTO m_dept (id, name) VALUES (1, '研发部'), (2, '市场部'),(3, '财务部'), (4,'销售部'), (5, '总经办'), (6, '人事部');


    -- 创建m_emp表，并插入数据
    create table m_emp(
        id int auto_increment comment 'ID' primary key,
        name varchar(50) not null comment '姓名',
        age int comment '年龄',
        job varchar(20) comment '职位',
        salary int comment '薪资',
        entrydate date comment '入职时间',
        managerid int comment '直属领导ID',
        dept_id int comment '部门ID'
    )comment '员工表';
    -- 添加外键
    alter table m_emp add constraint fk_dept_id foreign key (dept_id) references m_dept(id);

    INSERT INTO m_emp (id, name, age, job,salary, entrydate, managerid, dept_id)
        VALUES
        (1, '金庸', 66, '总裁',20000, '2000-01-01', null,5),
        (2, '张无忌', 20, '项目经理',12500, '2005-12-05', 1,1),
        (3, '杨逍', 33, '开发', 8400,'2000-11-03', 2,1),
        (4, '韦一笑', 48, '开发',11000, '2002-02-05', 2,1),
        (5, '常遇春', 43, '开发',10500, '2004-09-07', 3,1),
        (6, '小昭', 19, '程序员鼓励师',6600, '2004-10-12', 2,1),
        (7, '灭绝', 60, '财务总监',8500, '2002-09-12', 1,3),
        (8, '周芷若', 19, '会计',48000, '2006-06-02', 7,3),
        (9, '丁敏君', 23, '出纳',5250, '2009-05-13', 7,3),
        (10, '赵敏', 20, '市场部总监',12500, '2004-10-12', 1,2),
        (11, '鹿杖客', 56, '职员',3750, '2006-10-03', 10,2),
        (12, '鹤笔翁', 19, '职员',3750, '2007-05-09', 10,2),
        (13, '方东白', 19, '职员',5500, '2009-02-12', 10,2),
        (14, '张三丰', 88, '销售总监',14000, '2004-10-12', 1,4),
        (15, '俞莲舟', 38, '销售',4600, '2004-10-12', 14,4),
        (16, '宋远桥', 40, '销售',4600, '2004-10-12', 14,4),
        (17, '陈友谅', 42, null,2000, '2011-10-12', 1,null);

    -- 薪水表
    create table m_salgrade(
        grade int,
        losal int,
        hisal int
    ) comment '薪资等级表';
    insert into m_salgrade values (1,0,3000),(2,3001,5000),(3,5001,8000),(4,8001,10000),(5,10001,15000),
    (6,15001,20000),(7,20001,25000),(8,25001,30000);


2.
    1). 查询员工的姓名、年龄、职位、部门信息 （隐式内连接）
    表: emp , dept
    连接条件: m_emp.dept_id = m_dept.id

        select e.name, e.age, e.job,d.name from m_emp e, m_dept d where e.dept_id = d.id;
        select e.name, e.age, e.job,d.name from m_emp e inner join m_dept d on e.dept_id = d.id;
        +--------+-----+--------------+--------+
        | name   | age | job          | name   |
        +--------+-----+--------------+--------+
        | 张无忌 |  20 | 项目经理     | 研发部 |
        | 杨逍   |  33 | 开发         | 研发部 |
        | 韦一笑 |  48 | 开发         | 研发部 |
        | 常遇春 |  43 | 开发         | 研发部 |
        | 小昭   |  19 | 程序员鼓励师 | 研发部 |
        | 赵敏   |  20 | 市场部总监   | 市场部 |
        | 鹿杖客 |  56 | 职员         | 市场部 |
        | 鹤笔翁 |  19 | 职员         | 市场部 |
        | 方东白 |  19 | 职员         | 市场部 |
        | 灭绝   |  60 | 财务总监     | 财务部 |
        | 周芷若 |  19 | 会计         | 财务部 |
        | 丁敏君 |  23 | 出纳         | 财务部 |
        | 张三丰 |  88 | 销售总监     | 销售部 |
        | 俞莲舟 |  38 | 销售         | 销售部 |
        | 宋远桥 |  40 | 销售         | 销售部 |
        | 金庸   |  66 | 总裁         | 总经办 |
        +--------+-----+--------------+--------+
        16 rows in set (0.10 sec)


    2). 查询年龄小于30岁的员工的姓名、年龄、职位、部门信息（显式内连接）
    表: emp , dept
    连接条件: m_emp.dept_id = m_dept.id

        select e.name, e.age, e.job ,d.name from m_emp e inner join m_dept d on e.dept_id = d.id where e.age < 30;
        select e.name, e.age, e.job ,d.name from m_emp e, m_dept d where e.dept_id = d.id and e.age < 30;
        +--------+-----+--------------+--------+
        | name   | age | job          | name   |
        +--------+-----+--------------+--------+
        | 张无忌 |  20 | 项目经理     | 研发部 |
        | 小昭   |  19 | 程序员鼓励师 | 研发部 |
        | 周芷若 |  19 | 会计         | 财务部 |
        | 丁敏君 |  23 | 出纳         | 财务部 |
        | 赵敏   |  20 | 市场部总监   | 市场部 |
        | 鹤笔翁 |  19 | 职员         | 市场部 |
        | 方东白 |  19 | 职员         | 市场部 |
        +--------+-----+--------------+--------+
        7 rows in set (0.11 sec)


    3). 查询拥有员工的部门ID、部门名称
    表: emp , dept
    连接条件: m_emp.dept_id = m_dept.id

        select distinct d.id , d.name from m_emp e , m_dept d where e.dept_id = d.id;
        select distinct d.id,d.name from m_dept d inner join m_emp e on d.id=e.dept_id;
        +----+--------+
        | id | name   |
        +----+--------+
        |  1 | 研发部 |
        |  2 | 市场部 |
        |  3 | 财务部 |
        |  4 | 销售部 |
        |  5 | 总经办 |
        +----+--------+
        5 rows in set (0.05 sec)


    4). 查询所有的部门信息, 并统计部门的员工人数  子查询在select中
        select d.id, d.name, (select count(*) from m_emp e where e.dept_id = d.id) '人数' from m_dept d;
        +----+--------+------+
        | id | name   | 人数 |
        +----+--------+------+
        |  1 | 研发部 |    5 |
        |  2 | 市场部 |    4 |
        |  3 | 财务部 |    3 |
        |  4 | 销售部 |    3 |
        |  5 | 总经办 |    1 |
        |  6 | 人事部 |    0 |
        +----+--------+------+
        6 rows in set (0.07 sec)


    5). 查询所有年龄大于40岁的员工, 及其归属的部门名称; 如果员工没有分配部门, 也需要展示出
    来(外连接)
    表: emp , dept
    连接条件: m_emp.dept_id = m_dept.id
    查询条件 : m_emp.age > 40

        select e.*, d.name from m_emp e left join m_dept d on e.dept_id = d.id where e.age > 40;
        +----+--------+-----+----------+--------+------------+-----------+---------+--------+
        | id | name   | age | job      | salary | entrydate  | managerid | dept_id | name   |
        +----+--------+-----+----------+--------+------------+-----------+---------+--------+
        |  1 | 金庸   |  66 | 总裁     |  20000 | 2000-01-01 | NULL      |       5 | 总经办 |
        |  4 | 韦一笑 |  48 | 开发     |  11000 | 2002-02-05 |         2 |       1 | 研发部 |
        |  5 | 常遇春 |  43 | 开发     |  10500 | 2004-09-07 |         3 |       1 | 研发部 |
        |  7 | 灭绝   |  60 | 财务总监 |   8500 | 2002-09-12 |         1 |       3 | 财务部 |
        | 11 | 鹿杖客 |  56 | 职员     |   3750 | 2006-10-03 |        10 |       2 | 市场部 |
        | 14 | 张三丰 |  88 | 销售总监 |  14000 | 2004-10-12 |         1 |       4 | 销售部 |
        | 17 | 陈友谅 |  42 | NULL     |   2000 | 2011-10-12 |         1 | NULL    | NULL   |
        +----+--------+-----+----------+--------+------------+-----------+---------+--------+
        7 rows in set (0.07 sec)


    6). 查询所有员工的工资等级
    表: emp , salgrade
    连接条件 : m_emp.salary >= m_salgrade.losal and m_emp.salary <= m_salgrade.hisal

        -- 方式一
        select e.id, e.name, s.* from m_emp e , m_salgrade s where e.salary >= s.losal and e.salary <= s.hisal;
        -- 方式二
        select e.id, e.name, s.* from m_emp e , m_salgrade s where e.salary between s.losal and s.hisal;
        -- 方式三  内连接                                                       on 后面的条件可以用 > < between 等
        select e.id, e.name, s.* from m_emp e inner join m_salgrade s on e.salary between s.losal and s.hisal;
        +----+--------+--------+-------+-------+-------+
        | id | name   | salary | grade | losal | hisal |
        +----+--------+--------+-------+-------+-------+
        |  1 | 金庸   |  20000 |     6 | 15001 | 20000 |
        |  2 | 张无忌 |  12500 |     5 | 10001 | 15000 |
        |  3 | 杨逍   |   8400 |     4 |  8001 | 10000 |
        |  4 | 韦一笑 |  11000 |     5 | 10001 | 15000 |
        |  5 | 常遇春 |  10500 |     5 | 10001 | 15000 |
        |  6 | 小昭   |   6600 |     3 |  5001 |  8000 |
        |  7 | 灭绝   |   8500 |     4 |  8001 | 10000 |
        |  9 | 丁敏君 |   5250 |     3 |  5001 |  8000 |
        | 10 | 赵敏   |  12500 |     5 | 10001 | 15000 |
        | 11 | 鹿杖客 |   3750 |     2 |  3001 |  5000 |
        | 12 | 鹤笔翁 |   3750 |     2 |  3001 |  5000 |
        | 13 | 方东白 |   5500 |     3 |  5001 |  8000 |
        | 14 | 张三丰 |  14000 |     5 | 10001 | 15000 |
        | 15 | 俞莲舟 |   4600 |     2 |  3001 |  5000 |
        | 16 | 宋远桥 |   4600 |     2 |  3001 |  5000 |
        | 17 | 陈友谅 |   2000 |     1 |     0 |  3000 |
        +----+--------+--------+-------+-------+-------+
        16 rows in set (0.10 sec)


    7). 查询 大于40岁的员工的信息,部门名称 及 工资等级  同时连接多个表
    表: emp , salgrade , dept
    连接条件 : m_emp.dept_id = m_dept.id, emp.salary between salgrade.losal and salgrade.hisal
    查询条件 : m_emp.age > 40

        select e.*,d.name,s.grade from m_emp e,m_dept d,m_salgrade s
        where e.dept_id=d.id and e.age > 40 and (e.salary between s.losal and s.hisal);
        +----+--------+-----+----------+--------+------------+-----------+---------+--------+-------+
        | id | name   | age | job      | salary | entrydate  | managerid | dept_id | name   | grade |
        +----+--------+-----+----------+--------+------------+-----------+---------+--------+-------+
        |  1 | 金庸   |  66 | 总裁     |  20000 | 2000-01-01 | NULL      |       5 | 总经办 |     6 |
        |  4 | 韦一笑 |  48 | 开发     |  11000 | 2002-02-05 |         2 |       1 | 研发部 |     5 |
        |  5 | 常遇春 |  43 | 开发     |  10500 | 2004-09-07 |         3 |       1 | 研发部 |     5 |
        |  7 | 灭绝   |  60 | 财务总监 |   8500 | 2002-09-12 |         1 |       3 | 财务部 |     4 |
        | 11 | 鹿杖客 |  56 | 职员     |   3750 | 2006-10-03 |        10 |       2 | 市场部 |     2 |
        | 14 | 张三丰 |  88 | 销售总监 |  14000 | 2004-10-12 |         1 |       4 | 销售部 |     5 |
        +----+--------+-----+----------+--------+------------+-----------+---------+--------+-------+
        6 rows in set (0.09 sec)


    8). 查询 "研发部" 所有员工的信息及 工资等级  同时连接多个表
    表: emp , salgrade , dept
    连接条件 : m_emp.dept_id = m_dept.id, emp.salary between salgrade.losal and salgrade.hisal
    查询条件 : m_dept.name = '研发部'

        select e.*,s.grade from m_emp e, m_dept d, m_salgrade s
        where e.dept_id=d.id and d.name='研发部' and (e.salary between s.losal and s.hisal);
        +----+--------+-----+--------------+--------+------------+-----------+---------+-------+
        | id | name   | age | job          | salary | entrydate  | managerid | dept_id | grade |
        +----+--------+-----+--------------+--------+------------+-----------+---------+-------+
        |  6 | 小昭   |  19 | 程序员鼓励师 |   6600 | 2004-10-12 |         2 |       1 |     3 |
        |  3 | 杨逍   |  33 | 开发         |   8400 | 2000-11-03 |         2 |       1 |     4 |
        |  2 | 张无忌 |  20 | 项目经理     |  12500 | 2005-12-05 |         1 |       1 |     5 |
        |  4 | 韦一笑 |  48 | 开发         |  11000 | 2002-02-05 |         2 |       1 |     5 |
        |  5 | 常遇春 |  43 | 开发         |  10500 | 2004-09-07 |         3 |       1 |     5 |
        +----+--------+-----+--------------+--------+------------+-----------+---------+-------+
        5 rows in set (0.09 sec)


    9). 查询 "研发部" 员工的平均工资
    表: emp , dept
    连接条件 : emp.dept_id = dept.id

        select avg(e.salary) from m_emp e, m_dept d where e.dept_id = d.id and d.name = '研发部';
        select avg(e.salary) from m_emp e inner join m_dept d on e.dept_id = d.id where d.name = '研发部';
        +---------------+
        | avg(e.salary) |
        +---------------+
        | 9800.0000     |
        +---------------+
        1 row in set (0.19 sec)


    10). 查询工资比 "灭绝" 高的员工信息。
        ①. 查询 "灭绝" 的薪资
        select salary from m_emp where name = '灭绝';
        ②. 查询比她工资高的员工数据
        select * from m_emp where salary > ( select salary from m_emp where name = '灭绝' );
        +----+--------+-----+------------+--------+------------+-----------+---------+
        | id | name   | age | job        | salary | entrydate  | managerid | dept_id |
        +----+--------+-----+------------+--------+------------+-----------+---------+
        |  1 | 金庸   |  66 | 总裁       |  20000 | 2000-01-01 | NULL      |       5 |
        |  2 | 张无忌 |  20 | 项目经理   |  12500 | 2005-12-05 |         1 |       1 |
        |  4 | 韦一笑 |  48 | 开发       |  11000 | 2002-02-05 |         2 |       1 |
        |  5 | 常遇春 |  43 | 开发       |  10500 | 2004-09-07 |         3 |       1 |
        |  8 | 周芷若 |  19 | 会计       |  48000 | 2006-06-02 |         7 |       3 |
        | 10 | 赵敏   |  20 | 市场部总监 |  12500 | 2004-10-12 |         1 |       2 |
        | 14 | 张三丰 |  88 | 销售总监   |  14000 | 2004-10-12 |         1 |       4 |
        +----+--------+-----+------------+--------+------------+-----------+---------+
        7 rows in set (0.07 sec)


    11). 查询比平均薪资高的员工信息
        ①. 查询员工的平均薪资
        select avg(salary) from m_emp;
        ②. 查询比平均薪资高的员工信息
        select * from m_emp where salary > ( select avg(salary) from m_emp );
        +----+--------+-----+------------+--------+------------+-----------+---------+
        | id | name   | age | job        | salary | entrydate  | managerid | dept_id |
        +----+--------+-----+------------+--------+------------+-----------+---------+
        |  1 | 金庸   |  66 | 总裁       |  20000 | 2000-01-01 | NULL      |       5 |
        |  2 | 张无忌 |  20 | 项目经理   |  12500 | 2005-12-05 |         1 |       1 |
        |  4 | 韦一笑 |  48 | 开发       |  11000 | 2002-02-05 |         2 |       1 |
        |  8 | 周芷若 |  19 | 会计       |  48000 | 2006-06-02 |         7 |       3 |
        | 10 | 赵敏   |  20 | 市场部总监 |  12500 | 2004-10-12 |         1 |       2 |
        | 14 | 张三丰 |  88 | 销售总监   |  14000 | 2004-10-12 |         1 |       4 |
        +----+--------+-----+------------+--------+------------+-----------+---------+
        6 rows in set (0.06 sec)


    12). 查询低于本部门平均工资的员工信息    内连接,自己连接自己
        ①. 查询指定部门平均薪资
        select avg(e1.salary) from m_emp e1 where e1.dept_id = 1;
        select avg(e1.salary) from m_emp e1 where e1.dept_id = 2;
        ②. 查询低于本部门平均工资的员工信息
        select * from m_emp e2 where e2.salary < (select avg(salary) from m_emp e1 where e1.dept_id = e2.dept_id);
        +----+--------+-----+--------------+--------+------------+-----------+---------+
        | id | name   | age | job          | salary | entrydate  | managerid | dept_id |
        +----+--------+-----+--------------+--------+------------+-----------+---------+
        |  3 | 杨逍   |  33 | 开发         |   8400 | 2000-11-03 |         2 |       1 |
        |  6 | 小昭   |  19 | 程序员鼓励师 |   6600 | 2004-10-12 |         2 |       1 |
        |  7 | 灭绝   |  60 | 财务总监     |   8500 | 2002-09-12 |         1 |       3 |
        |  9 | 丁敏君 |  23 | 出纳         |   5250 | 2009-05-13 |         7 |       3 |
        | 11 | 鹿杖客 |  56 | 职员         |   3750 | 2006-10-03 |        10 |       2 |
        | 12 | 鹤笔翁 |  19 | 职员         |   3750 | 2007-05-09 |        10 |       2 |
        | 13 | 方东白 |  19 | 职员         |   5500 | 2009-02-12 |        10 |       2 |
        | 15 | 俞莲舟 |  38 | 销售         |   4600 | 2004-10-12 |        14 |       4 |
        | 16 | 宋远桥 |  40 | 销售         |   4600 | 2004-10-12 |        14 |       4 |
        +----+--------+-----+--------------+--------+------------+-----------+---------+
        9 rows in set (0.04 sec)


    13). 查询与 "鹿杖客" , "宋远桥" 的职位和薪资相同的员工信息
        分解为两步执行:
        ①. 查询 "鹿杖客" , "宋远桥" 的职位和薪资
            select job, salary from m_emp where name = '鹿杖客' or name = '宋远桥';
            +------+--------+
            | job  | salary |
            +------+--------+
            | 职员 |   3750 |
            | 销售 |   4600 |
            +------+--------+

        ②. 查询与 "鹿杖客" , "宋远桥" 的职位和薪资相同的员工信息
            select * from m_emp where (job,salary) in ( select job, salary from m_emp where name = '鹿杖客' or name = '宋远桥');
            +----+--------+-----+------+--------+------------+-----------+---------+
            | id | name   | age | job  | salary | entrydate  | managerid | dept_id |
            +----+--------+-----+------+--------+------------+-----------+---------+
            | 11 | 鹿杖客 |  56 | 职员 |   3750 | 2006-10-03 |        10 |       2 |
            | 12 | 鹤笔翁 |  19 | 职员 |   3750 | 2007-05-09 |        10 |       2 |
            | 15 | 俞莲舟 |  38 | 销售 |   4600 | 2004-10-12 |        14 |       4 |
            | 16 | 宋远桥 |  40 | 销售 |   4600 | 2004-10-12 |        14 |       4 |
            +----+--------+-----+------+--------+------------+-----------+---------+


    14). 查询所有学生的选课情况, 展示出学生名称, 学号, 课程名称   多对多中间表查询
    表: student , course , student_course
    连接条件: m_student.id = m_student_course.studentid , m_course.id = m_student_course.courseid

        select s.name,s.no,c.name from m_student s,m_course c, m_student_course sc where s.id=sc.studentid and c.id=sc.courseid;
        +--------+------------+--------+
        | name   | no         | name   |
        +--------+------------+--------+
        | 黛绮丝 | 2000100101 | Java   |
        | 黛绮丝 | 2000100101 | PHP    |
        | 黛绮丝 | 2000100101 | MySQL  |
        | 谢逊   | 2000100102 | PHP    |
        | 谢逊   | 2000100102 | MySQL  |
        | 殷天正 | 2000100103 | Hadoop |
        +--------+------------+--------+
        6 rows in set (0.05 sec)


    15). 查询选修了mysql的学生信息
    表: student , course , student_course
        select * from m_student where id in
            (select studentid from m_student_course where courseid = (select id from m_course where name='mysql'));
        select s.* from m_student s,m_student_course sc
            where (s.id=sc.studentid) and sc.courseid=(select id from m_course c where c.name ='mysql');
        +----+--------+------------+
        | id | name   | no         |
        +----+--------+------------+
        |  1 | 黛绮丝 | 2000100101 |
        |  2 | 谢逊   | 2000100102 |
        +----+--------+------------+
        2 rows in set (0.06 sec)


    16). 查询id和name为something的同学信息
        select * from students1 where (id,name)=(select id,name from students1 order by score desc limit 1);
            +-----+----------+--------+-----+-------+-------+
        | id  | name     | sex    | age | class | score |
        +-----+----------+--------+-----+-------+-------+
        | 116 | 猫宫日向 | female |  17 |     8 |   526 |
        +-----+----------+--------+-----+-------+-------+
        1 row in set (0.05 sec)
