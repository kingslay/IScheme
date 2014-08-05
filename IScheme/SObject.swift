//
//  SObject.swift
//  IScheme
//
//  Created by king on 14/7/7.
//  Copyright (c) 2014年 king. All rights reserved.
//

import Foundation

class SObject : NSObject,Printable{
    override var description : String {
    return ""
    }
}
class SNumber : SObject {
    var value : Int
    override var description : String {
    return "\(value)"
    }
    init(value : Int) {
        self.value = value
    }
    func __conversion() -> Int {
        return value
    }
}
extension Int {
    func __conversion() -> SNumber {
        return SNumber(value: self)
    }
    func __conversion() -> SObject {
        return SNumber(value: self)
    }
}


class SBool : SObject, LogicValue {
    class var false: SBool {
    return SBool()
    }
    class var true: SBool {
    return SBool()
    }
    init() {
        
    }
    func __conversion() -> Bool {
        return self == SBool.true
    }
    func getLogicValue() -> Bool {
        return self == SBool.true
    }
    override var description: String {
    return self.__conversion().description
    }
    
}
extension Bool {
    func __conversion() -> SBool {
        return self ? SBool.true : SBool.false
    }
}

class SList : SObject, Sequence{
    var values : Array<SObject>
    
    init(values: Array<SObject>) {
        self.values = values
    }
    
func generate() -> IndexingGenerator<[SObject]> {
        return self.values.generate()
    }
    override var description: String {
    return "(list " + " ".join(self.values) + ")"
    }
}
class SFunction : SObject {
    var body : SExpression
    var parameters : [String]
    var scope : SScope
    var isPartial : Bool {
    var count = computeFilledParameters().count
        return count > 0 && count < parameters.count
    }
    
    init(body : SExpression, parameters : [String], scope : SScope) {
        self.body = body
        self.parameters = parameters
        self.scope = scope
    }
    
    func evaluate() -> SObject {
        if computeFilledParameters().count < parameters.count {
            return self
        }else{
            return self.body.evaluate(self.scope)
        }
    }
    
    func computeFilledParameters() -> [String] {
        return parameters.filter{ self.scope.findInTop( $0 ) != nil }
    }
    
    override var description : String {
    var tmp = " ".join( self.parameters.map { name -> String in
        if let value = self.scope.findInTop(name) {
            return "\(name):\(value)"
        }else{
            return name
        }
        })
        return "(func (\(tmp)) \(self.body)"
    }
    
}







