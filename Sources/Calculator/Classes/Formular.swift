//  Formular.swift
//  
//
//  Created by 조기은 on 2023/03/14.
//

import Foundation

/// 식을 저장하고 계산하여 반환하는 클래스
class Formular {
    private var list: [FormularMember] = []
    
    // 계산 완료 후 입력된 값이 있는지
    private var hasNewValue: Bool = false
    
    // 마지막으로 저장된 연산자와 피연산자. 하나의 계산 완료 후 다른 입력을 하지 않고 = 만 눌렀을 때 계산할 수 있도록 하기 위함
    private var lastOperand: Operand = Operand(0)
    private var lastOperator: Operator = Operator(.add)
    
    weak var resultLabel: UILabel!
    
    /** NSExpression에 넣기 위해 식을 문자열로 출력 */
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
        
        // 첫 입력에서 연산자가 들어올 경우, 식에 0을 추가.
        if list.isEmpty && params[0] is Operator {
            list.append(Operand(0))
        }
        
        
        // 식의 마지막과 새로운 입력의 첫 값이 연산자일 경우 식의 마지막 값을 새로운 값으로 대체. ex) [1, +, 3, -], [*, 3]
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
    
    
    /// 저장된 식을 계산하는 메소드
    /// - Parameter isDone: 저장된 식을 초기화하고 결과값으로 대체할지. 기본값: false ( false: 연산자 입력으로 인한 계산, true: = 입력으로 인한 계산)
    /// - Returns: 계산 결과
    func evaluate(isDone: Bool = false) throws -> NSNumber {
        
        defer {
            hasNewValue = false
        }
        
        // 추가 입력 없이 = 만 누를 경우
        if list.count >= 2 && !hasNewValue {
            redo()
        }
        
        // 식의 마지막 값이 연산자일 경우 더미 값 추가
        if let tmpOpr: Operator = list.last as? Operator {
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
