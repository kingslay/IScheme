IScheme
=======

参考博文http://zh.lucida.me/blog/how-to-implement-an-interpreter-in-csharp/

用SWIFT实现一个简化Scheme——iScheme及其解释器。

Requirements

iOS 7.x / 8.x, Swift 1.2

演示

一、基本的运算

\>>1

1

\>>(+ 1(* 2 3))

7

\>>(and (= 1 0)(/ 1 0))

false

\>>(or (= 0 0)(/ 1 0))

true

\>>(def x 3)

3

\>>(def square (func (x) (* x x)))

(func (x) (* x x))

\>>(square x)

9

\>>y

y is not defined.

\>>(def alist(list 1 2 3))

(list 1 2 3)

\>>(rest alist)

(list 2 3)

二、高阶函数

\>>(def mul(func (a b)(* a b )))

(func (a b) (* a b))

\>>(mul 3)

(func (a:3 b) (* a b))

\>>((mul 3) 4)

12

\>>(def map (func (f alist)(if (empty? alist) alist (append (list (f (first alist)))(map f (rest alist))))))

(func (f alist) (if (empty? alist) alist (append (list (f (first alist))) (map f (rest alist)))))

\>>(def alist(list 1 2 3 4 5 6))

(list 1 2 3 4 5 6)

\>>(map (mul 3) alist)

(list 3 6 9 12 15 18)

\>>(def reduce (func (init op alist)(if (empty? alist) init ( op (first alist )(reduce init op (rest alist))))))

(func (init op alist) (if (empty? alist) init (op (first alist) (reduce init op (rest alist)))))

\>>(reduce 1 mul alist)

720

