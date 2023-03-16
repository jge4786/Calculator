//  연산자
//  Operator.swift
//  
//
//  Created by 조기은 on 2023/03/14.
//

import Foundation

class Operator: FormularMember, Equatable {
    private var op: Operators = .add
    
    //연산자의 문자값
    var value: String {
        get {
            return Operators.opDict[op] ?? "?"
        }
    }
    
    init() { self.op = .add}
    init(_ val: Operators) { self.op = val}
    init(from: String) {
        op = Operators.opDict.first(where: { $1 == from })?.key ?? Operators.add
    }    
    
    static func == (lhs: Operator, rhs: Operator) -> Bool {
        return lhs.value == rhs.value
    }
}
