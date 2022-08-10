1 check 保证字段值满足某一个条件


    CREATE TABLE tb_user(
        age int check (age > 0 && age <= 120) COMMENT '年龄' ,
    );
