//  입력 버퍼
//
//  InputBuffer.swift
//  
//
//  Created by 조기은 on 2023/03/14.
//

import Foundation

//struct InputBuffer {
//    private var operand: String?
//    private var opr: Operators?
//
//    private mutating func flush() {
//        self.operand = nil
//        self.opr = nil
//    }
//
//    private mutating func changeOperator(newValue: Operators) -> String? {
//
//        //입력 중인 피연산자가 있을 경우 맨 뒤의 값 하나 제거하고, 없을 경우 아무 일도 하지 않고 리턴
//        if newValue == .erase {
//            operand?.popLast()
//
//            return nil
//        }
//
//        //입력 중인 피연산자가 있을 때, 연산자가 입력되는 상황
//        if operand != nil && operand != "-" {
//            let tmp: String = operand ?? ""
//            operand = nil
//
//            self.opr = newValue
//
//            return tmp
//        }
//
//        self.opr = newValue
//
//        return nil
//    }
//
//    private mutating func appendOperand(newValue: String) -> Operators? {
//         if operand == nil {
//            operand = ""
//        }
//
//        if newValue == "." && operand?.firstIndex(of: ".") != nil {
//            return nil
//        }
//
//        operand = (operand ?? "") + newValue
//
//        if opr != nil {
//            let tmp = opr
//            opr = nil
//            return tmp
//        }
//
//        return nil
//    }
//
//    @discardableResult
//    mutating func newInput(newValue: Any) throws -> FormularMember? {
//        if let opr: Operators = newValue as? Operators {
//            let result = changeOperator(newValue: opr)
//
//            if result != nil {
//                return Operand(to: result ?? "")
//            }
//        }
//        else if let oprd: String = newValue as? String {
//            guard oprd == "." || Double(oprd) != nil  else{
//                throw CalculationError.InputError
//            }
//
//            let result = appendOperand(newValue: oprd)
//            if result != nil {
//                return Operator(result ?? .add)
//            }
//        }
//
//        return nil
//    }
//
//    init(){
//        operand = nil
//        opr = nil
//    }
//
//    mutating func done() -> FormularMember? {
//        if opr != nil {
//            return Operator(opr ?? .add)
//        }else if operand != nil {
//            return Operand(to: operand ?? "")
//        }
//        flush()
//        return nil
//    }
//}

/// 사용자로부터 하나씩 입력받아 계산식에 필요한 연산자와 피연산자를 만드는 클래스
class InputBuffer {
    private var operand: String? {
        didSet {
            guard operand != nil else { return }
            UILabel.text = makeResultString(operand ?? "0")
        }
    }
    private var opr: Operators?
    
    //계산기 화면에 보이는 결과
    weak var resultLabel: UILabel!
        
    init() {
        operand = nil
        opr = nil
    }
    
    init(label: UILabel){
        self.resultLabel = label
        operand = nil
        opr = nil
    }
   
    func flush() {
       self.operand = nil
       self.opr = nil
        UILabel.text = "0"
    }

    private func changeOperator(newValue: Operators) -> String? {
       
       //입력 중인 피연산자가 있을 경우 맨 뒤의 값 하나 제거하고, 없을 경우 아무 일도 하지 않고 리턴
       if newValue == .erase {
           operand?.popLast()
           
           return nil
       }
       
       //입력 중인 피연산자가 있을 때, 연산자가 입력되는 상황
       if operand != nil && operand != "-" {
           let tmp: String = operand ?? ""
           operand = nil
           
           self.opr = newValue
           
           return tmp
       }
       
       self.opr = newValue
               
       return nil
    }

    private func appendOperand(newValue: String) -> Operators? {
        if operand == nil {
           operand = ""
       }
       
       if newValue == "." && operand?.firstIndex(of: ".") != nil {
           return nil
       }
        if newValue == "." && operand?.count == 0 {
            operand = "0"
        }
       
       operand = (operand ?? "") + newValue
       
       if opr != nil {
           let tmp = opr
           opr = nil
           return tmp
       }
       
       return nil
    }

    @discardableResult
    func newInput(newValue: Any) throws -> FormularMember? {
       if let opr: Operators = newValue as? Operators {
           let result = changeOperator(newValue: opr)
           
           if result != nil {
               return Operand(to: result ?? "")
           }
       }
       else if let oprd: String = newValue as? String {
           guard oprd == "." || Double(oprd) != nil  else{
               throw CalculationError.InputError
           }
           
           let result = appendOperand(newValue: oprd)
           if result != nil {
               return Operator(result ?? .add)
           }
       }
       
       return nil
    }
    
    // 모든 입력이 완료됐을 때 버퍼를 비우는 메소드
    func done() -> FormularMember? {
       defer {
           flush()
       }
       
       if opr != nil {
           return Operator(opr ?? .add)
       }else if operand != nil {
           return Operand(to: operand ?? "")
       }
       return nil
    }
}
