1 while循环
    循环体都是要在大型代码块(函数/存储过程/触发器)中使用
2 基本语法
    while 条件 do
        循环执行的代码
    end while;

3 结构标识符
    为某些特定的结构进行命名,为的是在某些地方使用名字

    基本语法:
        标志名字:while 条件 do
        循环体
        end while[标志名字];

        标志名字的存在主要是为了在循环体中使用循环控制,在MySQL中没有continue和break,
        有自己的关键字替代:
            iterate : 迭代,以下的代码不执行,重新开始循环(continue)
            leave :  离开,终止循环(break)

            表示名字:while 条件 do

                if 条件判断 then
                    //循环控制
                    iterate/leave 标志名字;
                end if;
                循环体
            end while[标志名字];