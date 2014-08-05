//
//  SExpression.swift
//  IScheme
//
//  Created by king on 14/7/3.
//  Copyright (c) 2014年 king. All rights reserved.
//
import Foundation
typealias FunctionType = ([SExpression],SScope) -> SObject
class SExpression : Printable {
    var value: String
    var children = [SExpression]()
    var parent: SExpression?
    var description: String {
    if self.value == "(" {
        return "(" +  " ".join(self.children) + ")"
    } else {
        return self.value
        }
    }
    
    init(value:String , parent:SExpression?) {
        self.value = value
        self.parent = parent
    }
    
    func evaluate(scope: SScope) -> SObject! {
        if self.children.count == 0 {
            if let number = self.value.toInt() {
                return SNumber(value: number);
            }
        }else{
            var first = self.children[0]
            if var function: FunctionType = scope.builtinFunctions[first.value] {
                var arguments = self.children[1 ..< self.children.count]
                var result = function(Array(arguments),scope)
                return result
            }
        }
        assert(false, "THIS IS JUST TEMPORARY!" )
        return nil
    }
    
}

class SScope : NSObject {
    var parent :SScope!
    var variableMap = Dictionary<String,SObject>()
    var builtinFunctions  = Dictionary<String,FunctionType>()
    init(parent : SScope!) {
        self.parent = parent
    }
    func find(name: String) -> SObject? {
        var curren = self
        while curren != nil {
            if let sobject = curren.variableMap[name] {
                return sobject
            }else{
                curren = curren.parent
            }
        }
        
        assert(false, "is not defined." )
        return nil
    }
    
    func define(name: String, value: SObject) {
        variableMap[name] = value
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
            println("Too many arguments.")
        }
        var scope = SScope(parent: self)
        for i in 0 ..< values.count {
            scope.variableMap[name[i]] = values[i]
        }
        return scope
    }
    
    func buildIn(name: String, builtinFunction: FunctionType) -> SScope {
        builtinFunctions[name] = builtinFunction;
        return self
    }
    
    
}
