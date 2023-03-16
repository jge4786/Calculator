//  계산식 관리
//  Formular.swift
//  
//
//  Created by 조기은 on 2023/03/14.
//

import Foundation

//class Formular {
//    //첫 입력으로 연산자가 들어오더라도 계산 가능하도록 0을 초기값으로 설정
//    private var list: [FormularMember] = []
//    private var hasNewValue: Bool = false
//    private var lastOperand: Operand = Operand(0)
//    private var lastOperator: Operator = Operator(.add)
//
//    /** 식을 문자열로 출력 */
//    var formular: String {
//        get{
//            let ret: String = list.reduce("") {
//                (result: String, next: FormularMember) -> String in
//                if next is Operand {
//                    let nextString: String = String((next as? Operand)?.value ?? 0)
//                    return result + nextString
//                }else if next is Operator {
//                    let nextString: String = (next as? Operator)?.value ?? "?"
//                    return result + nextString
//                }else {
//                    return result
//                }
//            }
//            return ret
//        }
//    }
//
//    /** 식에 값 추가 */
//    func append(_ params: FormularMember...) {
//        if list.isEmpty && params[0] is Operator {
//            list.append(Operand(0))
//        }
//        params.map {
//            list.append($0)
//            if let tmpOpr = $0 as? Operator {
//                lastOperator = tmpOpr
//            }else if let tmpOprd = $0 as? Operand {
//                lastOperand = tmpOprd
//            }
//        }
//        hasNewValue = true
//    }
//
//    /** 식의 가장 마지막 값 제거 */
//    @discardableResult
//    func pop() -> FormularMember? {
//        return list.popLast()
//    }
//
//    func flush() {
//        list = [Operand(0)]
//        hasNewValue = false
//    }
//
//    func redo() {
//        list.append(lastOperator)
//        list.append(lastOperand)
//    }
//
//    /** 식 계산 */
//    func evaluate() throws -> NSNumber {
//        var needSaveResult: Bool = false
//
//        defer {
//            hasNewValue = false
//        }
//
//        if list.count >= 2 && !hasNewValue {
//            redo()
//        }
//        if let tmpOpr: Operator = list.last as? Operator {
//            needSaveResult = true
//            switch tmpOpr.value {
//            case "+", "-":
//                list.append(Operand(0))
//            case "*", "/":
//                list.append(Operand(1))
//            case "(", ")", "<", ">":
//                break
//            default:
//                break
//            }
//        }
//        do {
//            let result = try NSExpression(format: self.formular).expressionValue(with: nil, context: nil) as? NSNumber ?? 0
//            if hasNewValue && needSaveResult { lastOperand = Operand(number: result) }
//            return result
//        }catch {
//            throw CalculationError.EvaluationFailed(formular: formular)
//        }
//    }
//}


class Formular {
    private var list: [FormularMember] = []
    private var hasNewValue: Bool = false
    private var lastOperand: Operand = Operand(0)
    private var lastOperator: Operator = Operator(.add)
    weak var resultLabel: UILabel!
    
    /** 식을 문자열로 출력 */
    var formular: String {
        get{
            let ret: String = list.reduce("") {
                (result: String, next: FormularMember) -> String in
                if next is Operand {
                    let nextString: String = String((next as? Operand)?.value ?? 0)
                    return result + nextString
                }else if next is Operator {
                    let nextString: String = (next as? Operator)?.value ?? "?"
                    return result + nextString
                }else {
                    return result
                }
            }
            return ret
        }
    }
    
    /** 식에 값 추가 */
    func append(_ params: FormularMember...) {
        
        if list.isEmpty && params[0] is Operator {
            list.append(Operand(0))
        }
        
        if list.last is Operator && params.first is Operator {
            list.removeLast()
        }
        
        params.map {
            list.append($0)
            if let tmpOpr = $0 as? Operator {
                lastOperator = tmpOpr
            }else if let tmpOprd = $0 as? Operand {
                lastOperand = tmpOprd
            }
        }
        hasNewValue = true
    }
    
    /** 식의 가장 마지막 값 제거 */
    @discardableResult
    func pop() -> FormularMember? {
        return list.popLast()
    }
    
    func flush() {
        list = []
        
        hasNewValue = false
    }
    
    func redo() {
        if !(list.last is Operator) {
            list.append(lastOperator)
        }
        list.append(lastOperand)
    }
    
    /** 식 계산 */
    func evaluate(isDone: Bool = false) throws -> NSNumber {
        var needSaveResult: Bool = false
        
        defer {
            hasNewValue = false
        }
        
        if list.count >= 2 && !hasNewValue {
            redo()
        }
        
        if let tmpOpr: Operator = list.last as? Operator {
            needSaveResult = true
            switch tmpOpr.value {
            case "+", "-":
                list.append(Operand(0))
            case "*", "/":
                list.append(Operand(1))
            case "(", ")", "<", ">":
                break
            default:
                break
            }
        }
        
        do {
            let result = try NSExpression(format: self.formular).expressionValue(with: nil, context: nil) as? NSNumber ?? 0
            if hasNewValue && needSaveResult { lastOperand = Operand(number: result) }
            
            UILabel.text = makeResultString(Double(truncating: result))
            
            if isDone {
                let tmpList: [FormularMember] = [Operand(number: result), lastOperator]
                flush()
                list = tmpList
                
            }
            return result
        }catch {
            throw CalculationError.EvaluationFailed(formular: formular)
        }
    }
}
