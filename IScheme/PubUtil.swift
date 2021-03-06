//
//  PubUtil.swift
//  IScheme
//  https://github.com/kingslay/IScheme
//  Created by king on 14/7/3.
//  Copyright (c) 2014年 king. All rights reserved.
//

import Foundation

func tokenize(_ text :String) -> [String]{
    return text.replacingOccurrences(of: "(", with: " ( ")
        .replacingOccurrences(of: ")",with:" ) ")
        .components(separatedBy: CharacterSet.whitespacesAndNewlines).filter{ $0 != "" }
}
func prettyPrint(_ sentence:String) -> String{
    let elements = tokenize(sentence).map{ "'\($0)'" }
    return "[" + elements.joined(separator: ", ") + "]"
}
func parseAsIScheme(_ code : String) -> SExpression! {
    let program = SExpression(value: "", parent: nil)
    var current = program
    for lex in tokenize(code) {
        if lex == "(" {
            let newNode = SExpression(value: "(", parent: current)
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
func chainRelation(_ expressions: [SExpression], scope: SScope,relation:(number1: SNumber, number2: SNumber)-> Bool) -> SObject {
    if expressions.count < 2 {
        return SException("Must have more than 1 parameter in relation operation.")
    }
    var current = expressions[0].evaluate(scope) as! SNumber
    for expression in expressions[1 ..< expressions.count] {
        let next = expression.evaluate(scope)as! SNumber
        if relation(number1: current, number2: next) {
            current = next
        } else {
            return FALSE
        }
    }
    return TRUE
}

func retrieveSList(_ expressions: [SExpression], scope: SScope, operationName: String) -> SObject {
    if expressions.count == 1 {
        let list = expressions[0].evaluate(scope)
        if list is SList  {
            return list
        }
    }
    return SException("<" + operationName + "> must apply to a list")
}
func keepInterpretingInConsole() {
    let scope = SScope(nil)
    print("welcome to IScheme")
    while(true){
        print(">>",terminator:"")
        if let code = readLine(strippingNewline: false) {
            if code == "exit\n" {
                break
            } else if code.isEmpty  {
                continue
            } else {
                if let expression = parseAsIScheme(code) {
                    print(expression.evaluate(scope));
                }
            }

        }
    }
}

func readLine() -> String {
    let keyboard = FileHandle.withStandardInput
    let inputData = keyboard.availableData
    return NSString(data: inputData, encoding:String.Encoding.utf8.rawValue) as! String
}

func schemeTest(_ codes: [String]) {
    let scope = SScope(nil)
    for code in codes {
        print(">>"+code)
        if code == "exit" {
            break
        } else if code.isEmpty  {
            continue
        } else {
            if let expression = parseAsIScheme(code) {
                print(expression.evaluate(scope).description);
            }
        }
    }
}



