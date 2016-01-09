//
//  SObject.swift
//  IScheme
//  https://github.com/kingslay/IScheme
//  Created by king on 14/7/7.
//  Copyright (c) 2014年 king. All rights reserved.
//

import Foundation
var NULL = SObject()
class SObject: NSObject, BooleanType{
    var boolValue: Bool {
        return self == TRUE
    }
    
    override var description: String {
        return ""
    }
    func toInt() -> Int {
        if let number = self as? SNumber {
            return number.value
        }
        return 0;
    }
}

class SException: SObject {
    var message: String
    init(_ message: String) {
        self.message = message
    }

    override var description: String {
        return message
    }
}
class SNumber: SObject,IntegerLiteralConvertible{
    var value : Int
    
    required init(integerLiteral value : Int) {
        self.value = value
    }
    override func isEqual(object: AnyObject!) -> Bool {
        if let number = object as? SNumber {
            return value == number.value
        }
        return false
    }
    
    override var description: String {
        return "\(value)"
    }
}

class SBool : SObject,BooleanLiteralConvertible{
    required init(booleanLiteral value: BooleanLiteralType){
        value ? TRUE:FALSE
    }
    
    override var description: String {
        return self.boolValue.description
    }
       
}


class SList : SObject, SequenceType, ArrayLiteralConvertible{
    typealias Element = SObject

    var values : Array<SObject>
    
    required init(_ values: [SObject]) {
        self.values = values
    }
   

    required init(array: Array<SObject>) {
        self.values = array
    }
    
    required init(arrayLiteral elements: Element...){
        self.values = elements
    }
    
    func generate() -> IndexingGenerator<[SObject]> {
        return values.generate()
    }
    
    func count() -> Int {
        return values.count
    }
    
    subscript (index: Int) -> SObject {
        return values[index]
    }
    
    subscript (subRange: Range<Int>) -> SList {
        return SList(array: Array(values[subRange]))
    }
    

    override var description: String {
        return "(list " + values.map{ $0.description }.joinWithSeparator(" ") + ")"
    }
}

func + (left: SList, right: SList) -> SList {
    let values = left.values + right.values
    return SList(values)
}

func + (left: SNumber, right: SNumber) -> SNumber {
    let value = left.value + right.value
    return SNumber(integerLiteral: value)
}


class SFunction : SObject {
    private(set) var body : SExpression
    private(set) var parameters : [String]
    private(set) var scope : SScope
    init(body : SExpression, parameters : [String], scope : SScope) {
        self.body = body
        self.parameters = parameters
        self.scope = scope
    }
    
    func evaluate() -> SObject {
        if computeFilledParameters().count < parameters.count {
            return self
        }else{
            return body.evaluate(scope)
        }
    }
    
    func computeFilledParameters() -> [String] {
        return parameters.filter{ self.scope.findInTop( $0 ) != nil }
    }
    
    func update(var arguments: [SObject]) -> SFunction {
        for parameter in parameters {
            if let obj = scope.findInTop(parameter){
                arguments.append(obj)
            }
        }
        let newScope = scope.parent!.spawnScopeWith(parameters, values: arguments)
        return SFunction(body: body, parameters: parameters, scope: newScope)
        
    }
    
    override var description: String {
        let tmp = parameters.map { name -> String in
            if let value = self.scope.findInTop(name) {
                return "\(name):\(value)"
            }else{
                return name
            }
            }.joinWithSeparator(" ")
        return "(func (\(tmp)) \(body))"
    }
    
}