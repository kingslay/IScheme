//
//  SExpression.swift
//  IScheme
//  https://github.com/kingslay/IScheme
//  Created by king on 14/7/3.
//  Copyright (c) 2014年 king. All rights reserved.
//
import Foundation
typealias FunctionType = ([SExpression],SScope) -> SObject
class SExpression: SObject {
    private(set) var value: String
    var children = [SExpression]()
    private(set) var parent: SExpression?
    override var description: String {
        if value == "(" {
            return "(" +  children.map{ $0.description }.joinWithSeparator(" ") + ")"
        } else {
            return value
        }
    }
    
    init(value:String , parent:SExpression?) {
        self.value = value
        self.parent = parent
    }
    func evaluate(scope: SScope) -> SObject {
        return evaluate(self, scope: scope)
    }
    
    func evaluate(current: SExpression, scope: SScope) -> SObject {
        while true {
            if self.children.count == 0 {
                if let number = Int(self.value) {
                    return SNumber(integerLiteral: number);
                } else {
                    return scope.find(current.value)
                }
            }else{
                let first = self.children[0]
                let expressions = Array(self.children[1 ..< self.children.count])
                if let function = scope.builtinFunctions[first.value] {
                    return function(expressions,scope)
                } else {
                    let function = first.value == "(" ? first.evaluate(scope) : scope.find(first.value)
                    let arguments = expressions.map{ $0.evaluate(scope) }
                    let newFunction = (function as! SFunction).update(arguments)
                    return newFunction.evaluate()
                }
            }
        }
    }
}
var overallbuiltinFunctions = Dictionary<String,FunctionType>()
class SScope : NSObject {
    private(set) var parent :SScope!
    private(set) var variableMap = Dictionary<String,SObject>()
    var builtinFunctions: Dictionary<String,FunctionType> {
        return overallbuiltinFunctions
    }
    init(_ parent : SScope!) {
        self.parent = parent
    }
    func find(name: String) -> SObject {
        var curren: SScope? = self
        while (curren != nil) {
            if let sobject = curren!.variableMap[name] {
                return sobject
            }else{
                curren = curren!.parent
            }
        }
        return SException(name + " is not defined.")
    }
    
    func define(name: String, value: SObject) -> SObject {
        variableMap[name] = value
        return value
    }
    
    func findInTop(name : String) -> SObject? {
        if let sobject = variableMap[name] {
            return sobject
        }else{
            return nil
        }
    }
    
    func spawnScopeWith(name : [String], values : [SObject]) -> SScope {
        if name.count < values.count {
            print("Too many arguments.")
        }
        let scope = SScope(self)
        for i in 0 ..< values.count {
            scope.variableMap[name[i]] = values[i]
        }
        return scope
    }
    
    class func buildIn(name: String, builtinFunction: FunctionType) {
        overallbuiltinFunctions[name] = builtinFunction;
    }
    
}
