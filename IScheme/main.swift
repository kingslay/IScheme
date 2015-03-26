//
//  main.swift
//  IScheme
//  https://github.com/kingslay/IScheme
//  Created by king on 14/7/18.
//  Copyright (c) 2014年 king. All rights reserved.
//

import Foundation
var TRUE : SBool = true
var FALSE : SBool = false

SScope.buildIn("if") { args, scope in
    var condition = args[0].evaluate(scope)
    return condition ? args[1].evaluate(scope) : args[2].evaluate(scope)
}
SScope.buildIn("def") { args, scope in
    scope.define(args[0].value, value: args[1].evaluate(SScope(scope)))
}
SScope.buildIn("begin") { args, scope in
    var result: SObject?
    for arg in args {
        result = arg.evaluate(scope)
    }
    return result!
}
SScope.buildIn("func") { args, scope in
    var parameters = args[0].children.map{ $0.value }
    return SFunction(body: args[1], parameters: parameters, scope: SScope(scope))
 
}
SScope.buildIn("list") { args, scope in
    return SList(args.map{ $0.evaluate(scope) })
}


SScope.buildIn("and") { args, scope in
    if args.count < 1 {
        return SException("Parameters count in or should be > 0 ")
    }
    for arg in args {
        if !arg.evaluate(scope) {
           return FALSE
        }
    }
    return TRUE
}
SScope.buildIn("or") { args, scope in
    if args.count < 1 {
        return SException("Parameters count in and should be > 0 ")
    }
    for arg in args {
        
        if arg.evaluate(scope) {
            return TRUE
        }
    }
    return FALSE
}
SScope.buildIn("not") { args, scope in
    if args.count != 1 {
        return SException("Parameters count in not should be 1 ")
    }    
    return args[0].evaluate(scope)
}



SScope.buildIn("+") { args, scope in
    var numbers = args.map{ $0.evaluate(scope).toInt() }
    return SNumber(integerLiteral: numbers.reduce(0){ $0 + $1 })
}
SScope.buildIn("-") { args, scope in
    var numbers = args.map{ $0.evaluate(scope).toInt() }
    var first = numbers.removeAtIndex(0)
    if numbers.count == 0 {
        return SNumber(integerLiteral: 0 - first)
    } else{
        return SNumber(integerLiteral: numbers.reduce(first){ $0 - $1 })
    }
}
SScope.buildIn("*") { args, scope in
    var numbers = args.map{ $0.evaluate(scope).toInt() }
    return SNumber(integerLiteral: numbers.reduce(1){ $0 * $1 })
}
SScope.buildIn("/") { args, scope in
    var numbers = args.map{ $0.evaluate(scope).toInt() }
    var first = numbers.removeAtIndex(0)
    return SNumber(integerLiteral: numbers.reduce(first){ $0 / $1 })
}
SScope.buildIn("%") { args, scope in
    var numbers = args.map{ $0.evaluate(scope).toInt()}
    if numbers.count != 2 {
        return SException("Parameters count in mod should be 2")
    }
    return SNumber(integerLiteral: numbers[0] % numbers[1])
}
SScope.buildIn("=") { chainRelation($0,$1){ $0 == $1 }}
SScope.buildIn("<") { chainRelation($0,$1){ $0 == $1 }}
SScope.buildIn("<=") { chainRelation($0,$1){ $0 == $1 }}
SScope.buildIn(">") { chainRelation($0,$1){ $0 == $1 }}
SScope.buildIn(">=") { chainRelation($0,$1){ $0 == $1 }}
SScope.buildIn("!=") { chainRelation($0,$1){ $0 == $1 }}
SScope.buildIn("first") {
    var obj = retrieveSList($0,$1,"first")
    if var list = obj as? SList {
        return list[0]
    }
    return obj
}
SScope.buildIn("rest") {
    var obj = retrieveSList($0,$1,"rest")
    if var list = obj as? SList {
        return list[1..<list.count()]
    }
    return obj
}
SScope.buildIn("empty?") {
    var obj = retrieveSList($0,$1,"empty?")
    if var list = obj as? SList {
        return list.count() == 0 ? TRUE : FALSE
    }
    return obj
}
SScope.buildIn("append") { args, scope in
    if args.count == 2 {
        let obj1 = args[0].evaluate(scope)
        let obj2 = args[1].evaluate(scope)
        if var list1 = obj1 as? SList {
            if var list2 = obj2 as? SList  {
                return list1 + list2
            }
        }
    }
    return SException("Input must be two lists")
}
var codes = ["1","(+ 1(* 2 3))","(and (= 1 0)(/ 1 0))","(or (= 0 0)(/ 1 0))","(def x 3)","(def square (func (x) (* x x)))","(square x)","y","(def alist(list 1 2 3))","(rest alist)","(def mul(func (a b)(* a b )))","(mul 3)","((mul 3) 4)","(def map (func (f alist)(if (empty? alist) alist (append (list (f (first alist)))(map f (rest alist))))))","(def alist(list 1 2 3 4 5 6))","(map (mul 3) alist)","(def reduce (func (init op alist)(if (empty? alist) init ( op (first alist )(reduce init op (rest alist))))))","(reduce 1 mul alist)"]
schemeTest(codes)
keepInterpretingInConsole()












