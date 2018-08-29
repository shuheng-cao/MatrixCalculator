//
//  TableViewCell.swift
//  Matrix!
//
//  Created by 曹书恒 on 2018/8/10.
//  Copyright © 2018 曹书恒. All rights reserved.
//

import UIKit

//    Whether or not using the delegate is suspended
//protocol TableViewCellDelegate {
//    func setToA(newMatrix: [[Double]])
//    func setToB(newMatrix: [[Double]])
//}

class TableViewCell: UITableViewCell {
    
    var delegate: DataPassingDelegate?
    var resultToPrsent: myCalculationResult?
    @IBOutlet weak var displayMatrix: UILabel!
    @IBOutlet weak var setToA: UIButton!
    @IBOutlet weak var setToB: UIButton!
    
    @IBOutlet weak var buttonStack: UIStackView!
    func setHistoryCell(myResult: myCalculationResult) {
        
        setToA.layer.cornerRadius = 5
        setToB.layer.cornerRadius = 5
        resultToPrsent = myResult
        
        if (myResult.operationType == myOperations.RREF) {
            displayMatrix.attributedText = convertArrayIntoString(myMatrix: myResult.outputMatrix)
        } else {
            displayMatrix.attributedText = convertArrayIntoString(myMatrix: myResult.inputMatrix)
        }
        
        buttonStack.spacing = CGFloat(10 * (myResult.inputMatrix.count - 1))
    }
    
    @IBAction func setAButton(_ sender: UIButton) {
        //        MARK: it should be output here
        delegate?.updateCurentMatrix(newMatrix: (resultToPrsent?.inputMatrix)!)
    }
    
    
    func convertArrayIntoString(myMatrix: [[Double]]) -> NSMutableAttributedString {
        var myText = NSMutableAttributedString(string: "")
        var arrayOfDigits: [[(Int, Int)]] = []
        
        // in order to slicing the string
        var count: Int = 0
        
        for i in myMatrix {
            var tmp: [(Int, Int)] = []
            for j in i {
                tmp.append(countDigitsOfDouble(x: j))
            }
            arrayOfDigits.append(tmp)
        }
        
        let tmp = theLongestString(myMatrix: myMatrix, arrayOfDigits: arrayOfDigits)
        let longestDigits = theLongestDigits(arrayOfDigits: arrayOfDigits)
        
        for i in 0...(myMatrix.count - 1) {
            count += 1
            for j in 0...(myMatrix[0].count - 1) {
                
                // for decimal digit
                var firstTime = true
                
                // before
                for _ in 0..<((longestDigits[j].0 - arrayOfDigits[i][j].0) - (longestDigits[j].0 - arrayOfDigits[i][j].0) / 2) {
                    
                    if (longestDigits[j].1 != 0 && arrayOfDigits[i][j].1 == 0 && firstTime) {
                        myText.append(NSMutableAttributedString(string: ".", attributes: [NSAttributedStringKey.foregroundColor : UIColor(red: 10/255, green: 190/255, blue: 50/255, alpha: 0)]))
                        firstTime = false
                        continue
                    }
                    
                    myText.append(NSMutableAttributedString(string: "0", attributes: [NSAttributedStringKey.foregroundColor : UIColor(red: 10/255, green: 190/255, blue: 50/255, alpha: 0)]))
                }
                
                // In the middle
                if (countDigitsOfDouble(x: myMatrix[i][j]).1 == 0) {
                    myText.append(NSMutableAttributedString(string: String(Int(round(myMatrix[i][j])))))
                } else {
                    myText.append(NSMutableAttributedString(string: String(round(100 * myMatrix[i][j]) / 100)))
                }
                
                // after
//                print("MARK 2: \((longestDigits[j].0 - arrayOfDigits[i][j].0) / 2 + 1)")
                for _ in 0..<((longestDigits[j].0 - arrayOfDigits[i][j].0) / 2) {
                    myText.append(NSMutableAttributedString(string: "0", attributes: [NSAttributedStringKey.foregroundColor : UIColor(red: 10/255, green: 190/255, blue: 50/255, alpha: 0)]))
                }
                
//                print(myText.string)
                
                for _ in 1...2 {
                    myText.append(NSAttributedString(string: " "))
                }
                
//                print(myText.string)
            }
            if (count == myMatrix.count) {
                myText.append(NSAttributedString(string: "\n"))
            } else {
                myText.append(NSAttributedString(string: "\n\(tmp)\n", attributes: [NSAttributedStringKey.foregroundColor : UIColor(red: 10/255, green: 190/255, blue: 50/255, alpha: 0)]))
                
            }
        }
        
        
        
        
        // Upper bound
        
        myText.insert(NSMutableAttributedString(string: "┓\n"), at: 0)
        myText.insert(NSMutableAttributedString(string: tmp, attributes: [NSAttributedStringKey.foregroundColor : UIColor(red: 10/255, green: 190/255, blue: 50/255, alpha: 0)]), at: 0)
        myText.insert(NSMutableAttributedString(string: "┏"), at: 0)
        
        // Lower bound
        myText.append(NSMutableAttributedString(string: "┗"))
        myText.append(NSMutableAttributedString(string: tmp, attributes: [NSAttributedStringKey.foregroundColor : UIColor(red: 10/255, green: 190/255, blue: 50/255, alpha: 0)]))
        myText.append(NSMutableAttributedString(string: "┛"))
                
        return myText
    }
    
    
    // Helpers:
    func countDigitsOfDouble(x: Double) -> (Int, Int) {
        
        var bckup = abs(x)
        var secondBckup = abs(x)
        var count: Int = 0
        
        while (bckup >= 1) {
            bckup = bckup / 10
            count = count + 1
        }
        
        secondBckup = secondBckup - Double(Int(bckup * Double(tenthPower(x: count))))
        
//        var y: Int = 0
//
//        // Avoid rounding error
//        if (Int(secondBckup * 1000) % 10 >= 5) {
//            y = Int(secondBckup * 100) + 1
//        } else {
//            y = Int(secondBckup * 100)
//        }
        
        let y: Int = Int(round(secondBckup * 100))
        var digit = 0
        
        if (y % 100 == 0) {
            digit = 0
        } else if (y % 10 == 0) {
            digit = 1
            // the dot
            count += 1
        } else {
            digit = 2
            // the dot
            count += 1
        }
        
//        print(count)
        if (x <= 0) {
            count += 1
        }
        
        return (count + digit, digit)
    }
    
    func tenthPower(x: Int) -> Int {
        if (x == 0) {
            return 1
        }
        var result = 1
        for _ in 1...x {
            result = result * 10
        }
        return result
    }
    
    func theLongestString(myMatrix: [[Double]], arrayOfDigits: [[(Int, Int)]]) -> String {
        var tmp = ""
//        print(arrayOfDigits)
//        print(myMatrix)
        for i in 0...(arrayOfDigits[0].count - 1) {
            var myMax = 0
            var correspondingDigit: Int = 0
            var correspondingNumber: Double = 0
            for j in 0...(arrayOfDigits.count - 1) {
                // Find the maximum
                if (myMax < arrayOfDigits[j][i].0) {
                    correspondingDigit = arrayOfDigits[j][i].1
                    correspondingNumber = myMatrix[j][i]
                    myMax = arrayOfDigits[j][i].0
                }
            }
//            print("myMax is \(myMax)")
            
            //            for _ in 1...(2 + myMax) {
            //                count += 1
            //                tmp += " "
            //            }
            if (i != 0) {
                tmp += "  "
            }
            if (correspondingDigit == 0) {
                tmp += "\(Int(round(correspondingNumber)))"
            } else {
                tmp += "\(round(100 * correspondingNumber) / 100)"
            }
        }
        return tmp
    }
    
    func theLongestDigits(arrayOfDigits: [[(Int, Int)]]) -> [(Int, Int)] {
        var tmp: [(Int, Int)] = []
        for i in 0...(arrayOfDigits[0].count - 1) {
            var myMax: (Int, Int) = (0, 0)
            for j in 0...(arrayOfDigits.count - 1) {
                if (myMax.0 < arrayOfDigits[j][i].0) {
                    myMax = arrayOfDigits[j][i]
                }
            }
            tmp.append(myMax)
        }
        return tmp
    }
}


