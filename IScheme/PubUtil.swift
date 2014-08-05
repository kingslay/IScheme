//
//  PubUtil.swift
//  IScheme
//
//  Created by king on 14/7/3.
//  Copyright (c) 2014年 king. All rights reserved.
//

import Foundation

class PubUtil{
    class func tokenize(text :String) -> [String]{
        return text.stringByReplacingOccurrencesOfString("(", withString: " ( ")
            .stringByReplacingOccurrencesOfString(")",withString:" ) ")
            .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            .componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    class func prettyPrint(sentence:String) -> String{
        let elements = tokenize(sentence).map{ "'\($0)'" }
        return "[" + join(", ",elements) + "]"
    }
    class func parseAsIScheme(code : String) -> SExpression {
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
        return program.children[0]
    }
}
