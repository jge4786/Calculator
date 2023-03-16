//  피연산자 기본 형태
//  OperandBase.swift
//  
//
//  Created by 조기은 on 2023/03/14.
//

import Foundation

class OperandBase {
    let value: Double;

    var stringValue: String {
        get{
            String(value)
        }
    }

    init(){
        value = 0
    }

    init(_ value: Double){
        self.value = value
    }

    init(number value: NSNumber){
        self.value = Double(truncating: value)
    }

    init(to value: String){
        self.value = Double(value) ?? 0
    }

    init(op: Operand) {
        self.value = op.value
    }
}
