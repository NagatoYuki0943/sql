
引入:SQL的执行从数据库端来讲,都是一条一条执行的.SQL在MySQL服务器端执行的逻辑是先编译后执行,
意味着即便是同一条SQL,每次发送到服务器端,都会经历编译,执行的过程,如果SQL量特别大,那么效率会大大折扣
为此,MySQL提供了一套 预处理 机制,可以实现效率的提升


MySQL预处理
定义:预处理prepare,是指客户端将要执行的SQL先发送给服务器,服务器先进行编译,不执行.等到客户端需要服务器端
执行的时候,发送一条执行命令,让服务器再执行已经提前处理好(预处理)的SQL指令

1.预处理流程:预处理流程是相对普通SQL执行流程的,普通的是客户端与服务器一对一一次性的服务,
  而预处理可能是一对一但是多次服务

2.实现预处理:预处理的步骤最开始会比普通SQL多执行一步,但是后续会节省服务器端的相应事件,提示服务器端的服务效率
  步骤如下
     发送预处理: prepare 预处理名字 from '要重复执行的sql语句';
     执行预处理: execute 预处理名字
  #重复的语句
  prepare students1_select from 'select * from students1';
  #执行预处理
  execute students1_select;

3.预处理占位:如果一条SQL本身就是重复多次,那么还不见得预处理有什么优势,毕竟这样的固定操作并不是特别多,
  更多的时候是需要条件变化的,因此预处理可以进行预处理占位,在执行的时候把数据填入即可实现不同的sql查询效果
     预处理占位符:在预处理指令中要执行的sql指令,使用 ? 来代替未知数据部分
     预处理执行(using):在执行预处理的时候将对应的数据携带到预处理指令中
  #执行重复的语句:从学生表中按学生id查询学生信息:id不确定,使用 ? 代替
  prepare student_select_id from 'select * from students1 where id = ?';
  #执行预处理:预处理数据不能直接使用数据常量带入,需要通过变量传入
  set @id=10;  #设置变量
  execute student_select_id using @id;

4.预处理可以同时设定多个占位符,在执行预处理的时候传入对应的参数即可(顺序匹配)
  #查询年龄区间的学生信息
  prepare student_select_age from 'select * from students1 where age between ? and ?';
  #执行预处理,提供两个参数
  set @min=10;
  set @max=13;
  execute student_select_age using @min,@max;
5.预处理在MySQL中,针对一个客户端不能出现同名预处理,如果预处理使用完毕,我们可以吧预处理给删掉
  以保证后续使用的方便
  语法: drop prepare 预处理名字;
  drop prepare student_select_id;


mysql> prepare student_select_id from 'select * from students1 where id = ?';
Query OK, 0 rows affected (0.03 sec)
Statement prepared

mysql> set @id=10;
Query OK, 0 rows affected (0.10 sec)

mysql> execute student_select_id using @id;
+----+------+--------+-----+-------+-------+
| id | name | sex    | age | class | score |
+----+------+--------+-----+-------+-------+
| 10 | 陈十 | female |  14 |     4 |    85 |
+----+------+--------+-----+-------+-------+


mysql> prepare student_select_age from 'select * from students1 where age between ? and ?';
Query OK, 0 rows affected (0.10 sec)
Statement prepared

mysql> set @min=10;
Query OK, 0 rows affected (0.00 sec)

mysql> set @max=13;
Query OK, 0 rows affected (0.00 sec)

mysql> execute student_select_age using @min,@max;
+----+--------+---------+-----+-------+-------+
| id | name   | sex     | age | class | score |
+----+--------+---------+-----+-------+-------+
| 88 | 李四   | male    |  11 |     1 |   100 |
| 13 | 蒋十三 | female  |  13 |     5 |    33 |
| 19 | 尤十九 | female  |  11 |     5 | NULL  |
+----+--------+---------+-----+-------+-------+

































