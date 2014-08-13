//
//  SObject.swift
//  IScheme
//
//  Created by king on 14/7/7.
//  Copyright (c) 2014年 king. All rights reserved.
//

import Foundation
var NULL = SObject()
class SObject: NSObject, BooleanType, Printable{
    override var description: String {
       return self as String
    }
    
    var boolValue: Bool {
        return self == TRUE
    }
    
    func __conversion() -> Int {
        return (self as SNumber).value
    }
    
    func __conversion() -> String {
        return ""
    }

}

class SException: SObject {
    var message: String
    init(_ message: String) {
        self.message = message
    }
    override func __conversion() -> String {
        return message
    }
}
class SNumber: SObject {
    var value : Int
    
    init(_ value : Int) {
        self.value = value
    }
    override func isEqual(object: AnyObject!) -> Bool {
        if let number = object as? SNumber {
            return value == number.value
        }
        return false
    }
    
    override func __conversion() -> String {
        return "\(value)"
    }
}
extension Int {
    func __conversion() -> SNumber {
        return SNumber(self)
    }
    func __conversion() -> SObject {
        return SNumber(self)
    }
}

var TRUE = SBool()
var FALSE = SBool()

class SBool : SObject, BooleanType {
    private override init() {
        
    }
    func __conversion() -> Bool {
        return self.boolValue
    }
    
    override func __conversion() -> String {
        return self.boolValue.description
    }
    
}
extension Bool {
    func __conversion() -> SBool {
        return self ? TRUE : FALSE
    }
}

class SList : SObject, SequenceType{
    var values : [SObject]
    
    init(_ values: [SObject]) {
        self.values = values
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
        return Array(values[subRange])
    }
    
    func __conversion() -> Array<SObject> {
        return values
    }

    override func __conversion() -> String {
        return "(list " + " ".join(values.map{ $0 as String }) + ")"
    }
}
extension Array {
    func __conversion() -> SList {
        return SList(self.map{ $0 as SObject })
    }
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
        var newScope = scope.parent!.spawnScopeWith(parameters, values: arguments)
        return SFunction(body: body, parameters: parameters, scope: newScope)
        
    }
    
    override func __conversion() -> String {
        var tmp = " ".join( parameters.map { name -> String in
            if let value = self.scope.findInTop(name) {
                return "\(name):\(value)"
            }else{
                return name
            }
            })
        return "(func (\(tmp)) \(body))"
    }
    
}