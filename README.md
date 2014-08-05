IScheme
=======
参考博文http://zh.lucida.me/blog/how-to-implement-an-interpreter-in-csharp/

用SWIFT实现一个简化Scheme——iScheme及其解释器。

演示

一、基本的运算

1

(+ 1(* 2 3))

(and (= 1 0)(/ 1 0))

(or (= 0 0)(/ 1 0))

(def x 3)

(def square (func (x) (* x x)))

(square x)

y

(def alist(list 1 2 3))

(rest alist)

二、高阶函数

(def mul(func (a b)(* a b )))

(mul 3)

((mul 3) 4)
