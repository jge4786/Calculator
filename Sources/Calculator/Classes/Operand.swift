//  연산자
//  Operand.swift
//  
//
//  Created by 조기은 on 2023/03/14.
//

import Foundation


final class Operand: OperandBase, Calculatable {
    static func + (lhs: Operand, rhs: Operand) -> Operand {
        guard let left = Double(exactly: lhs.value),
              let right = Double(exactly: rhs.value) else { return Operand(0) }

        return Operand(left + right)
    }
    
    /** Addable 프로토콜 확인용 */
    static func + (lhs: Operand, rhs: any Addable) -> Operand {
        guard let left = Double(exactly: lhs.value),
              let right = Double(exactly: rhs as! NSNumber) ?? nil else { return Operand(0) }

        return Operand(left + right)
    }
    
    static func - (lhs: Operand, rhs: Operand) -> Operand {
        guard let left = Double(exactly: lhs.value),
              let right = Double(exactly: rhs.value) else { return Operand(0) }

        return Operand(left - right)
    }
    
    static func * (lhs: Operand, rhs: Operand) -> Operand {
        guard let left = Double(exactly: lhs.value),
              let right = Double(exactly: rhs.value) else { return Operand(0) }

        return Operand(left * right)
    }
    
    //TODO: 0으로 나눌 때 예외 처리
    static func / (lhs: Operand, rhs: Operand) -> Operand {
        guard let left = Double(exactly: lhs.value),
              let right = Double(exactly: rhs.value) else { return Operand(0) }

        return Operand(left / right)
    }
}
