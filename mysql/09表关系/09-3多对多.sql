多对多
    一张表中的一条记录在另一个表中可以匹配到多条记录,反过来也一样
    多对多的关系如果按照多对一的关系维护,就会出现一个字段中有多个其他表的主键,在访问的时候带来不便

    既然通过两张表自己增加字段解决不了问题,那就通过第三张表来解决问题

    师生关系
    1.一个老师教多个学生
    2.一个学生听过多个老师的课

    老师表
    Tid     name	age     gender
    T1      MIKE    25      female
    T2      NKIE    25      male

    学生表
    Sid     name    age     gender
    S1      lili    15      male
    S2      tom     14      female
    S3      at      15      male
    S4      kc      16      male

    设计中间表维护两者关系
    ID    Tid     Sid
    1      T1      S1
    2      T1      S2
    3      T1      S3
    4      T2      S1
    5      T2      S4

    多对多的解决方案增加一个中间表,让中间表与对应的表形成两个多对一的关系
    多对一的解决方案是在"多"表中增加"一"表对应的主键字段


--学生表
create table m_student(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '姓名',
    no varchar(10) comment '学号'
) comment '学生表';
insert into m_student values (null, '黛绮丝', '2000100101'),(null, '谢逊', '2000100102'),(null, '殷天正', '2000100103'),(null, '韦一笑', '2000100104');

--课程表
create table m_course(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '课程名称'
) comment '课程表';
insert into m_course values (null, 'Java'), (null, 'PHP'), (null , 'MySQL'), (null, 'Hadoop');

--中间表
create table m_student_course(
    id int auto_increment comment '主键' primary key,
    studentid int not null comment '学生ID',
    courseid int not null comment '课程ID',
    constraint fk_courseid foreign key (courseid) references m_course (id),
    constraint fk_studentid foreign key (studentid) references m_student (id)
)comment '学生课程中间表';
insert into m_student_course values (null,1,1),(null,1,2),(null,1,3),(null,2,2),(null,2,3),(null,3,4);