/**
 * 3/14 내용
 * 1. 파일 분리
 * 2. 소수점 추가
 * 3. 한 글자 제거
 * 4. 유효하지 않은 피연산자 입력 시 예외 처리
 *
 *
 * 3/15 내용
 * 1. UI 동작 추가
 * 2. 자리수 표시(,) 추가
 * 3. 연산자가 입력될 때마다 계산하도록 변경
 *  3-1. 연산자 입력으로 인한 계산과 = 입력으로 인한 계산 구분
 *   3-1-1. 연산자로 인한 계산은 식 유지되어 뒤에 입력되는 값에도 사칙연산 적용
 *   3-1-2. =로 인한 계산은 식을 비우고 결과값을 입력
 * 4. 초기화 추가
 * 5. 직전 연산을 기억하는 기능 추가
 *
 * 3/16 내용
 * 1. NSExpression  사용하지 않는 방식으로 전환 시도
 * 2. 값이 Int의 제한을 넘어갈 경우 inf. 출력하도록 수정
 */

import Foundation

//MARK: - 프로토콜
protocol Calculatable { }

protocol Addable: Calculatable {
    static func + (lhs: Self, rhs: Self) -> Self
}

protocol Subtractable:Calculatable {
    static func - (lhs: Self, rhs: Self) -> Self
}

protocol Divisible: Calculatable {
    static func / (lhs: Self, rhs: Self) -> Self
}

protocol Multiplicable: Calculatable {
    static func * (lhs: Self, rhs: Self) -> Self
}

//protocol Calculatable: Addable, Subtractable, Divisible, Multiplicable {
//}

/**
 연산자(Operator)와 피연산자(Calculatable)을 한 배열에 담기 위한 프로토콜
 */
protocol FormularMember { }




//MARK: - 열거형
enum CalculationError: Error{
    case DivideByZero
    case InputError
    case EvaluationFailed(formular: String)
}

enum Operators: Equatable, Hashable {
    case add
    case sub
    case multi
    case div
    case bracket(_ state: Bool)
    case erase
    case percentage
    
    /** 연산자의 문자열을 손쉽게 가져오기 위함 */
    static let opDict: [Operators: String] = [
        .add: "+",
        .sub: "-",
        .multi: "*",
        .div: "/",
        .bracket(true): "(",
        .bracket(false): ")",
        .percentage: ""
    ]
}




//MARK: - 확장
//extension Int: Addable {}
extension Double: Addable, Subtractable { }     //익스텐션 테스트용
//extension Float: Addable, Multiplicable {}





/// 결과창에 보일 문자열 만드는 함수
func makeResultString(_ value: String) -> String {
    
    if value.hasPrefix("0.") {
        
        return value
    }
    
    return makeResultString(Double(value) ?? 0)
}
func makeResultString(_ value: Double) -> String {
    var resultString = ""
    var decimalString = ""
    
    if value >= Double(Int.max) {
        return "inf."
    }
    
    //정수 부분과 소수 부분 분리
    if value == Double(Int(value)) && value >= 1.0 {
        resultString = String(Int(value))
    }else {
        resultString = String(value)
        
        let dotIndex: String.Index? = resultString.firstIndex(of: ".")

        if let idx = dotIndex {
            decimalString = String(resultString[idx...])
            resultString = String(resultString[..<idx])
        }
    }
    
    
        
    resultString = String(resultString.reversed())
    
    let tmp = resultString.enumerated()
    
    resultString = tmp.reduce("") {
        if $1.offset > 0 && $1.offset % 3 == 0 {
            return $0 + "," + String($1.element)
        }
        return $0 + String($1.element)
    }
    
    return String(resultString.reversed() + decimalString)
}



class UILabel {
    static var text: String = ""
}
