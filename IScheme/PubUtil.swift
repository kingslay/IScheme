//
//  PubUtil.swift
//  IScheme
//
//  Created by king on 14/7/3.
//  Copyright (c) 2014年 king. All rights reserved.
//

import Foundation

func tokenize(text :String) -> [String]{
    return text.stringByReplacingOccurrencesOfString("(", withString: " ( ")
        .stringByReplacingOccurrencesOfString(")",withString:" ) ")
        .componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter{ $0 != "" }
}
func prettyPrint(sentence:String) -> String{
    let elements = tokenize(sentence).map{ "'\($0)'" }
    return "[" + join(", ",elements) + "]"
}
func parseAsIScheme(code : String) -> SExpression! {
    var program = SExpression(value: "", parent: nil)
    var current = program
    for lex in tokenize(code) {
        if lex == "(" {
            var newNode = SExpression(value: "(", parent: current)
            current.children.append(newNode)
            current = newNode
        }else if lex == ")" {
            current = current.parent!
        }else{
            current.children.append(SExpression(value: lex, parent: current))
        }
    }
    if program.children.count > 0{
        return program.children[0]
    } else {
        return nil
    }
}
func chainRelation(expressions: [SExpression], scope: SScope,relation:(number1: SNumber, number2: SNumber)-> Bool) -> SObject {
    if expressions.count < 2 {
        return SException("Must have more than 1 parameter in relation operation.")
    }
    var current = expressions[0].evaluate(scope) as SNumber
    for expression in expressions[1 ..< expressions.count] {
        var next = expression.evaluate(scope) as SNumber
        if relation(number1: current, number2: next) {
            current = next
        } else {
            return FALSE
        }
    }
    return TRUE
}

func retrieveSList(expressions: [SExpression], scope: SScope, operationName: String) -> SObject {
    if expressions.count == 1 {
        let list = expressions[0].evaluate(scope)
        if list is SList  {
            return list
        }
    }
    return SException("<" + operationName + "> must apply to a list")
}
func keepInterpretingInConsole() {
    var scope = SScope(nil)
    println("welcome to IScheme")
    while(true){
        print(">>")
        var code = readLine()
        if code == "exit\n" {
            break
        } else if code.isEmpty  {
            continue
        } else {
            if var expression = parseAsIScheme(code) {
                println(expression.evaluate(scope));
            }
        }
    }
}
func readLine() -> String {
    var keyboard = NSFileHandle.fileHandleWithStandardInput()
    var inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding)
}

func schemeTest(codes: [String]) {
    var scope = SScope(nil)
    for code in codes {
        println(">>"+code)
        if code == "exit" {
            break
        } else if code.isEmpty  {
            continue
        } else {
            if var expression = parseAsIScheme(code) {
                println(expression.evaluate(scope) as String);
            }
        }
    }
}

