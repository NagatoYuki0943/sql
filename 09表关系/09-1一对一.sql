1 表与表之间(实体)有什么样的关系,每种关系应该如何设计

2 一对一
    一张表中的一条记录与另外一张表中最多有一条明确的关系
    通常此设计方案保证两张表中使用同样的主键即可

    学生表
    学生id(pri)     姓名    年龄    性别        籍贯    婚否    住址

    使用过程中,常用的信息会经常查询,不常用信息会偶尔使用.
    解决方案:将一张表拆分成两张表,常见的放一张表,不常见的放另一张表

    学生id在两张表中是一致的
    常用表
    学生id(pri)     姓名    年龄    性别

    不常用表
    学生id(pri)     籍贯    婚否    住址

--用户表
create table mb_tb_user(
    id int auto_increment primary key comment '主键ID',
    name varchar(10) comment '姓名',
    age int comment '年龄',
    gender char(1) comment '1: 男 , 2: 女',
    phone char(11) comment '手机号'
) comment '用户基本信息表';

--用户受教育程度表
create table mb_tb_user_edu(
    id int auto_increment primary key comment '主键ID',
    degree varchar(20) comment '学历',
    major varchar(50) comment '专业',
    primaryschool varchar(50) comment '小学',
    middleschool varchar(50) comment '中学',
    university varchar(50) comment '大学',
    userid int unique comment '用户ID',
    constraint fk_userid foreign key (userid) references mb_tb_user(id)
) comment '用户教育信息表';

insert into mb_tb_user(id, name, age, gender, phone) values
(null,'黄渤',45,'1','18800001111'),
(null,'冰冰',35,'2','18800002222'),
(null,'码云',55,'1','18800008888'),
(null,'李彦宏',50,'1','18800009999');

insert into mb_tb_user_edu(id, degree, major, primaryschool, middleschool, university, userid) values
(null,'本科','舞蹈','静安区第一小学','静安区第一中学','北京舞蹈学院',1),
(null,'硕士','表演','朝阳区第一小学','朝阳区第一中学','北京电影学院',2),
(null,'本科','英语','杭州市第一小学','杭州市第一中学','杭州师范大学',3),
(null,'本科','应用数学','阳泉第一小学','阳泉区第一中学','清华大学',4);

