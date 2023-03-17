import XCTest
@testable import Calculator

final class CalculatorTests: XCTestCase {
    func testExample() throws {
        var buffer: InputBuffer = InputBuffer()
        var formula: Formular = Formular()
        
        func makeFormular(_ tmpList: [Any]) {
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
        
        func flush() {
            buffer.flush()
            formula.flush()
        }
        
        let inputList0: [Any] = ["9",Operators.multi, ".", "4", Operators.add, "1", "3", Operators.sub, ".", "4", ".", ".", "3", Operators.erase, Operators.erase, ".", "6", Operators.erase, "5", Operators.add, Operators.div, "6"]
        let inputList1: [Any] = ["5", Operators.add, "1", "0", Operators.add, "2"]
        let inputList2: [Any] = ["5", "0", Operators.add]
        let inputList3: [Any] = [Operators.add, "5", "0"]
        let inputList4: [Any] = ["2", "0", Operators.multi, "6"]
        let inputList5: [Any] = [Operators.add, "3"]
        let inputList6: [Any] = ["1", Operators.add, "2", Operators.sub]
        let inputList7: [Any] = ["4", Operators.add, "5"]
        let inputList8: [Any] = ["0"]
        let inputList9: [Any] = ["1", "0", "0", "0", "2", "3", ".", "4", Operators.add, "0"]
        
        let inputList: [[Any]] = [
            inputList0,
            inputList1,
            inputList2,
            inputList3,
            inputList4,
            inputList5,
            inputList6,
            inputList7,
            inputList8,
            inputList9,
            [".", "0", "0", "0", "0", "5", Operators.add]
        ]
        
        let tmpList: [Any] = inputList[8]
        
        makeFormular(tmpList)

        
        XCTAssertEqual(formula.formular, "0.0")
        XCTAssertEqual(try formula.evaluate(), 0)
        XCTAssertEqual(try formula.evaluate(), 0)
        XCTAssertEqual(try formula.evaluate(), 0)
        XCTAssertEqual(try formula.evaluate(isDone: true), 0)
        
        flush()
        
        XCTAssertEqual(UILabel.text, "0")
        
        makeFormular(inputList[9])
        try formula.evaluate(isDone: true)
        
        XCTAssertEqual(UILabel.text, "100,023.4")
        
        makeFormular([Operators.multi, "1", "0"])
        
        XCTAssertEqual(formula.formular, "100023.4*10.0")
        
        try formula.evaluate()
        
        XCTAssertEqual(UILabel.text, "1,000,234")
        
        
        flush()
        
        makeFormular(inputList[1])
        
        XCTAssertEqual(formula.formular, "5.0+10.0+2.0")
        XCTAssertEqual(try formula.evaluate(), 17)
        
        makeFormular(inputList[3])
        
        XCTAssertEqual(formula.formular, "5.0+10.0+2.0+50.0")
        XCTAssertEqual(try formula.evaluate(isDone: true), 67)
        
        makeFormular(inputList[4])
        
        XCTAssertEqual(formula.formular, "67.0+20.0*6.0")
        XCTAssertEqual(try formula.evaluate(isDone: true), 187)
        
        
        XCTAssertEqual(try formula.evaluate(), 1122)
        XCTAssertEqual(formula.formular, "187.0*6.0")
        XCTAssertEqual(UILabel.text, "1,122")
        
        flush()
        
        makeFormular(inputList[10])
        
        XCTAssertEqual(try formula.evaluate(), 0.00005)
        
        flush()
        
        makeFormular(inputList[2])
        XCTAssertEqual(try formula.evaluate(), 50)
        XCTAssertEqual(try formula.evaluate(), 100)
        XCTAssertEqual(try formula.evaluate(), 150)
        XCTAssertEqual(try formula.evaluate(), 200)
        
        flush()
        
        makeFormular(inputList[0])
        
        XCTAssertEqual(formula.formular, "9.0*0.4+13.0-0.5/6.0")
        XCTAssertEqual(try formula.evaluate(), 16.516666666666667)
    }
}

