import XCTest
@testable import Calculator

final class CalculatorTests: XCTestCase {
    func testExample() throws {
        var buffer: InputBuffer = InputBuffer()
        
//        let inputList: [Any] = ["9",Operators.multi, ".", "4", Operators.add, "1", "3", "a", Operators.sub, ".", "4", ".", ".", "3", Operators.erase, Operators.erase, ".", "6", Operators.erase, "5", Operators.add, Operators.div, "6"]
//        let inputList: [Any] = ["5", Operators.add, "1", "0", Operators.add, "2"]
//        let inputList: [Any] = ["5", "0", Operators.add]
//        let inputList: [Any] = [Operators.add, "5", "0"]
//        let inputList: [Any] = ["2", "0", Operators.multi, "6"]
//        let inputList: [Any] = [Operators.add, "3"]
//        let inputList: [Any] = ["1", Operators.add, "2", Operators.sub]
        let inputList: [Any] = ["4", Operators.add, "5"]
        let inputList2: [Any] = ["1", "0", "0", "0", "2", "3", ".", "4", Operators.add, "0"]
        
        var formula: Formular = Formular()
        let tmpList: [Any] = inputList
        
        inin(tmpList)
        
        func inin(_ tmpList: [Any]) {
            for data in tmpList {
                do{
                    let tmpValue = try buffer.newInput(newValue: data)
                    
                    guard let val = tmpValue else {
                        continue
                    }
                    
                    formula.append(val)
                }catch{
                    print("not")
                }
            }
            formula.append(buffer.done() ?? Operand(to: ""))
        }
        
        
        XCTAssertEqual(formula.formular, "4.0+5.0")
        XCTAssertEqual(try formula.evaluate(), 9)
        XCTAssertEqual(UILabel.text, "9")
        XCTAssertEqual(try formula.evaluate(), 14)
        XCTAssertEqual(try formula.evaluate(), 19)
        XCTAssertEqual(try formula.evaluate(isDone: true), 24)
        
        buffer.flush()
        formula.flush()
        
        XCTAssertEqual(UILabel.text, "0")
        
        inin(inputList2)
        try formula.evaluate(isDone: true)
        
        XCTAssertEqual(UILabel.text, "100,023.4")
        
        inin([Operators.multi, "1", "0"])
        
        XCTAssertEqual(formula.formular, "100023.4*10.0")
        
        try formula.evaluate()
        
        XCTAssertEqual(UILabel.text, "1,000,234")
    }
}

