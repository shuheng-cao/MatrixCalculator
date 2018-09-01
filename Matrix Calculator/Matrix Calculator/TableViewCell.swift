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
    var detailedAttributedString: NSMutableAttributedString?
    @IBOutlet weak var displayMatrix: UILabel!
    @IBOutlet weak var setToA: UIButton!
    @IBOutlet weak var setToB: UIButton!
    @IBOutlet weak var buttonStack: UIStackView!
    
    // Constraint to be mutated
    @IBOutlet weak var stackConstraint: NSLayoutConstraint!
    @IBOutlet weak var setAConstraint: NSLayoutConstraint!
    @IBOutlet weak var setBConstraint: NSLayoutConstraint!
    
    func setHistoryCell(myResult: myCalculationResult,_ isPortrait: Bool) {

        setToA.layer.cornerRadius = 5
        setToB.layer.cornerRadius = 5
        resultToPrsent = myResult
        
        
        var fitted: Bool = false
        var size = 20
        
        if (isPortrait) {
            while (!fitted) {
                
                displayMatrix.attributedText = convertArrayIntoString(myMatrix: myResult.outputMatrix, size)
                
                
                if (myResult.operationType == .inverse && myResult.invertible == false) {
                    displayMatrix.attributedText = makeAttributedString("The matrix is not invertibele.", size)
                    disableButton()
                } else if (myResult.operationType == .diagonal) {
                    if (myResult.diagonalizable == false) {
                        displayMatrix.attributedText = makeAttributedString("The matrix is not diagonalizable.", size)
                    } else {
                        displayMatrix.attributedText = makeAttributedString("The matrix is diagonalizable.", size)
                    }
                    disableButton()
                } else if (myResult.operationType == .eigenvalue) {
                    if (myResult.outputMatrix[0].count == 0) {
                        displayMatrix.attributedText = makeAttributedString("The matrix doesn't have real eigenvalue.", size)
                    } else {
                        let tmp = makeAttributedString("Eigenvalues of the matrix are ", size)
                        for i in 0..<myResult.outputMatrix[0].count {
                            if (i != 0) {
                                tmp.append(makeAttributedString(", \(round(myResult.outputMatrix[0][i] * 1000) / 1000)", size))
                            } else {
                                tmp.append(makeAttributedString("\(round(myResult.outputMatrix[0][i] * 1000) / 1000)", size))
                            }
                            
                        }
                        displayMatrix.attributedText = tmp
                    }
                    disableButton()
                } else if (myResult.operationType == .determinate) {
                    displayMatrix.attributedText = makeAttributedString("Determinant of the matrix is \(round(myResult.outputMatrix[0][0] * 1000) / 1000)", size)
                    disableButton()
                } else {
                    enableButton()
                }
                
                let correctNumOfLines: Int = correspondingLines(myResult.outputMatrix.count)
                
                
                if (displayMatrix.numberOfVisibleLines <= correctNumOfLines) {
                    fitted = true
                } else {
                    fitted = false
                    size -= 1
                }
                
                if (size <= 10) {fitted = true}
                print(displayMatrix.numberOfVisibleLines)
            }
            
            
            // MARK: remember to reset it for landscape mode -> No Need, landscape mode won't have buttons
            buttonStack.spacing = CGFloat(10 * (myResult.outputMatrix.count - 1))
            
            
            
        } else {
            displayMatrix.attributedText = convertArrayIntoString(myMatrix: myResult.outputMatrix, size)
            while (!fitted) {
                // Component of my detailed string
                var inputStringArray = breakIntoPieces(convertArrayIntoString(myMatrix: myResult.inputMatrix, size))
                var outputStringArray = breakIntoPieces(convertArrayIntoString(myMatrix: myResult.outputMatrix, size))
                var prefixString: [NSMutableAttributedString] = []
                var postfixString: [NSMutableAttributedString] = []
                
                switch myResult.operationType {
                case .addition:
                    // MARK: Addition
                    let secondStringArray = breakIntoPieces(convertArrayIntoString(myMatrix: myResult.secondMatrix, size))
                    var transPlus = makeTransparent(" + ", size)
                    let concretePlus = makeAttributedString(" + ", size)
                    let transEqual = makeTransparent(" = ", size)
                    let concreteEqual = makeAttributedString(" = ", size)
                    
                    let correctNumOfLines = inputStringArray.count
                    for i in 0..<(correctNumOfLines / 2) {
                        transPlus.append(secondStringArray[i])
                        transPlus.append(transEqual)
                        postfixString.append(transPlus)
                        transPlus = makeTransparent(" + ", size)
                    }
                    
                    concretePlus.append(secondStringArray[correctNumOfLines / 2])
                    concretePlus.append(concreteEqual)
                    postfixString.append(concretePlus)
                    
                    for i in (correctNumOfLines / 2 + 1)..<(correctNumOfLines) {
                        transPlus.append(secondStringArray[i])
                        transPlus.append(transEqual)
                        postfixString.append(transPlus)
                        transPlus = makeTransparent(" + ", size)
                    }
                    
                    
                    let newString = mergeArrayOfString(prefixString, inputStringArray, postfixString, outputStringArray)
                    displayMatrix.attributedText = newString
                    
                case .inverse:
                    // MARK: Inverse
                    if (myResult.invertible) {
                    for i in 0..<inputStringArray.count {

                        if (i == inputStringArray.count / 2) {
                            let tmp = makeTransparent("-1", size)
                            tmp.append(makeAttributedString(" = ", size))
                            postfixString.append(tmp)
                        } else {
                            let tmp = makeTransparent("-1", size)
                            tmp.append(makeTransparent(" = ", size))
                            postfixString.append(tmp)
                        }
                    }
                    inputStringArray.insert(makeTransparent(inputStringArray[0].string, size), at: 0)
                    outputStringArray.insert(makeTransparent(outputStringArray[0].string, size), at: 0)
                    let tmp = makeAttributedString("-1", size)
                    tmp.append(makeTransparent(" = ", size))
                    postfixString.insert(tmp, at: 0)
                    
                        let newString = mergeArrayOfString(prefixString, inputStringArray, postfixString, outputStringArray)
                    displayMatrix.attributedText = newString
                    
                    } else {
                        for i in 0..<inputStringArray.count {
                            if (i == inputStringArray.count / 2) {
                                prefixString.append(makeAttributedString("The matrix ", size))
                                postfixString.append(makeAttributedString(" is not invertible", size))
                            } else {
                                prefixString.append(makeTransparent("The matrix ", size))
                                postfixString.append(makeTransparent(" is not invertible", size))
                            }
                        }
                        outputStringArray = []
                        var newString = mergeArrayOfString(prefixString, inputStringArray, postfixString, outputStringArray)
                        displayMatrix.attributedText = newString
                    }
                case .power:
                    // MARK: Power
                    // copy from inverse
                    
                    for i in 0..<inputStringArray.count {
                        
                        if (i == inputStringArray.count / 2) {
                            let tmp = makeTransparent("\(myResult.degreeOfPower)", size)
                            tmp.append(makeAttributedString(" = ", size))
                            postfixString.append(tmp)
                        } else {
                            let tmp = makeTransparent("\(myResult.degreeOfPower)", size)
                            tmp.append(makeTransparent(" = ", size))
                            postfixString.append(tmp)
                        }
                    }
                    inputStringArray.insert(makeTransparent(inputStringArray[0].string, size), at: 0)
                    outputStringArray.insert(makeTransparent(outputStringArray[0].string, size), at: 0)
                    let tmp = makeAttributedString("\(myResult.degreeOfPower)", size)
                    tmp.append(makeTransparent(" = ", size))
                    postfixString.insert(tmp, at: 0)
                    
                    var newString = mergeArrayOfString(prefixString, inputStringArray, postfixString, outputStringArray)
                    displayMatrix.attributedText = newString
                    
                case .determinate:
                    // MARK: Determinant
                    var answer: Double = round(myResult.outputMatrix[0][0] * 1000) / 1000
                    
                    for i in 0..<inputStringArray.count {
                        if (i == inputStringArray.count / 2) {
                            prefixString.append(makeAttributedString("Determinant of matrix ", size))
                            postfixString.append(makeAttributedString(" is \(answer)", size))
                        } else {
                            prefixString.append(makeTransparent("Determinant of matrix ", size))
                            postfixString.append(makeTransparent(" is \(answer)", size))
                        }
                    }
                    outputStringArray = []
                    let newString = mergeArrayOfString(prefixString, inputStringArray, postfixString, outputStringArray)
                    displayMatrix.attributedText = newString
                    
                case .diagonal:
                    // MARK: Diagonalization
                    outputStringArray = breakIntoPieces(convertArrayIntoString(myMatrix: createDiagonalMatrix(myResult.outputMatrix[0]), size))
                    // make a new calculation result to get transpose
                    let leftOrthgonalMatrix: [[Double]] = myResult.eigenvectors
                    let rightOrthgonalMatrix: [[Double]] = myCalculationResult(leftOrthgonalMatrix, myOperations.transpose).outputMatrix
                    
                    prefixString = breakIntoPieces(convertArrayIntoString(myMatrix: rightOrthgonalMatrix, size))
                    for i in prefixString {
                        i.append(makeAttributedString("  ", size))
                    }
                    postfixString = breakIntoPieces(convertArrayIntoString(myMatrix: leftOrthgonalMatrix, size))
                    for i in 0..<postfixString.count {
                        postfixString[i].insert(makeAttributedString("  ", size), at: 0)
                        if (i == postfixString.count / 2) {
                            postfixString[i].append(makeAttributedString(" = ", size))
                        } else {
                            postfixString[i].append(makeTransparent(" = ", size))
                        }
                    }
                    
                    let newString = mergeArrayOfString(prefixString, inputStringArray, postfixString, outputStringArray)
                    displayMatrix.attributedText = newString
                    
                case .RREF:
                    // MARK: RREF
                    // copy from determinant
                    for i in 0..<inputStringArray.count {
                        if (i == inputStringArray.count / 2) {
                            prefixString.append(makeAttributedString("RREF of matrix ", size))
                            postfixString.append(makeAttributedString(" is ", size))
                        } else {
                            prefixString.append(makeTransparent("RREF of matrix ", size))
                            postfixString.append(makeTransparent(" is ", size))
                        }
                    }
                    let newString = mergeArrayOfString(prefixString, inputStringArray, postfixString, outputStringArray)
                    displayMatrix.attributedText = newString
                    
                case .eigenvalue:
                    // MARK: Eigenvalue
                    
                    if (myResult.outputMatrix[0].count == 0) {
                        
                        for i in 0..<inputStringArray.count {
                            if (i == inputStringArray.count / 2) {
                                prefixString.append(makeAttributedString("The matrix ", size))
                                postfixString.append(makeAttributedString(" doesn't have real eigenvalue.", size))
                            } else {
                                prefixString.append(makeTransparent("The matrix ", size))
                                postfixString.append(makeTransparent(" doesn't have real eigenvalue.", size))
                            }
                        }
                    } else {
                        let answer = makeAttributedString(" ", size)
                        for i in 0..<myResult.outputMatrix[0].count {
                            if (i != 0) {
                                answer.append(makeAttributedString(", \(round(myResult.outputMatrix[0][i] * 1000) / 1000)", size))
                            } else {
                                answer.append(makeAttributedString("\(round(myResult.outputMatrix[0][i] * 1000) / 1000)", size))
                            }
                        }
                        
                        for i in 0..<inputStringArray.count {
                            if (i == inputStringArray.count / 2) {
                                prefixString.append(makeAttributedString("Eigenvalues of the matrix ", size))
                                postfixString.append(makeAttributedString(" are \(answer.string)", size))
                            } else {
                                prefixString.append(makeTransparent("Eigenvalues of the matrix ", size))
                                postfixString.append(makeTransparent(" are \(answer.string)", size))
                            }
                        }
                        
                    }
                    outputStringArray = []
                    
                    
                    var newString = mergeArrayOfString(prefixString, inputStringArray, postfixString, outputStringArray)
                    displayMatrix.attributedText = newString
                case .transpose:
                    // MARK: Transpose
                    // combining inverse and multiplication
                    var transPlus = makeTransparent("T", size)
                    let concretePlus = makeAttributedString("T", size)
                    var transEqual = makeTransparent(" = ", size)
                    let concreteEqual = makeAttributedString(" = ", size)
                    
                    let correctNumOfLines = max(inputStringArray.count, outputStringArray.count)
                    
                    if (inputStringArray.count == correctNumOfLines) {
                        // The left matrix is larger
                        let tmp = outputStringArray.count
                        for i in 0..<correctNumOfLines {
                            
                            if (i < (correctNumOfLines - tmp) / 2
                                || i >= ((correctNumOfLines - tmp) / 2) + tmp) {
                                
                                transPlus.append(transEqual)
                                postfixString.append(transPlus)
                                transPlus = makeTransparent("T", size)
                                
                                var placeholder = makeTransparent(outputStringArray[0].string, size)
                                if (i < (correctNumOfLines - tmp) / 2) {
                                    outputStringArray.insert(placeholder, at: 0)
                                } else {
                                    outputStringArray.append(placeholder)
                                }
                                
                            } else {
                                if (i == correctNumOfLines / 2) {
                                    transPlus.append(concreteEqual)
                                    postfixString.append(transPlus)
                                    transPlus = makeTransparent("T", size)
                                } else {
                                    transPlus.append(transEqual)
                                    postfixString.append(transPlus)
                                    transPlus = makeTransparent("T", size)
                                }
                            }

                        }
                        
                        var placeholder = makeTransparent(inputStringArray[0].string, size)
                        placeholder.append(makeAttributedString("T", size))
                        inputStringArray.insert(placeholder, at: 0)
                        
                        placeholder = makeTransparent(" = ", size)
                        postfixString.insert(placeholder, at: 0)
                        
                        placeholder = makeTransparent(outputStringArray[0].string, size)
                        outputStringArray.insert(placeholder, at: 0)
                    } else {
                        // The right matrix is larger
                        // input count will change during the for loop
                        let tmp = inputStringArray.count
                        for i in 0..<correctNumOfLines {
                            
                            if (i < (correctNumOfLines - tmp) / 2) {
                                
                                var placeholder = makeTransparent(inputStringArray[0].string, size)
                                inputStringArray.insert(placeholder, at: 0)
                                
                                if (i == (correctNumOfLines - tmp) / 2 - 1) {
                                    concretePlus.append(transEqual)
                                    postfixString.append(concretePlus)
                                } else {
                                    transPlus.append(transEqual)
                                    postfixString.append(transPlus)
                                    transPlus = makeTransparent("T", size)
                                }
                            } else if (i >= (correctNumOfLines + tmp) / 2) {
                                
                                var placeholder = makeTransparent(inputStringArray[0].string, size)
                                inputStringArray.append(placeholder)
                                
                                transPlus.append(transEqual)
                                postfixString.append(transPlus)
                                transPlus = makeTransparent("T", size)
                            } else {
                                if (i == correctNumOfLines / 2) {
                                    transPlus.append(concreteEqual)
                                    postfixString.append(transPlus)
                                    transPlus = makeTransparent("T", size)
                                } else {
                                    transPlus.append(transEqual)
                                    postfixString.append(transPlus)
                                    transPlus = makeTransparent("T", size)
                                }
                            }
                        }
                    }
                    
                    var newString = mergeArrayOfString(prefixString, inputStringArray, postfixString, outputStringArray)
                    displayMatrix.attributedText = newString
                case .substraction:
                    // MARK: Substraction
                    // Copy from Addition, should do this using helper
                    let secondStringArray = breakIntoPieces(convertArrayIntoString(myMatrix: myResult.secondMatrix, size))
                    var transPlus = makeTransparent(" - ", size)
                    let concretePlus = makeAttributedString(" - ", size)
                    var transEqual = makeTransparent(" = ", size)
                    let concreteEqual = makeAttributedString(" = ", size)
                    
                    let correctNumOfLines = inputStringArray.count
                    for i in 0..<(correctNumOfLines / 2) {
                        transPlus.append(secondStringArray[i])
                        transPlus.append(transEqual)
                        postfixString.append(transPlus)
                        transPlus = makeTransparent(" - ", size)
                    }
                    
                    concretePlus.append(secondStringArray[correctNumOfLines / 2])
                    concretePlus.append(concreteEqual)
                    postfixString.append(concretePlus)
                    
                    for i in (correctNumOfLines / 2 + 1)..<(correctNumOfLines) {
                        transPlus.append(secondStringArray[i])
                        transPlus.append(transEqual)
                        postfixString.append(transPlus)
                        transPlus = makeTransparent(" - ", size)
                    }
                    
                    
                    var newString = mergeArrayOfString(prefixString, inputStringArray, postfixString, outputStringArray)
                    displayMatrix.attributedText = newString
                    
                case .multiplication:
                    // MARK: Multiplication
                    // Copy from Addition, should do this using helper
                    let secondStringArray = breakIntoPieces(convertArrayIntoString(myMatrix: myResult.secondMatrix, size))
                    var transPlus = makeTransparent(" * ", size)
                    let concretePlus = makeAttributedString(" * ", size)
                    var transEqual = makeTransparent(" = ", size)
                    let concreteEqual = makeAttributedString(" = ", size)
                    
                    let correctNumOfLines = max(inputStringArray.count, secondStringArray.count)
                    
                    if (inputStringArray.count == correctNumOfLines) {
                        // MARK: The left matrix and output matrix is larger
                        for i in 0..<correctNumOfLines {
                            
                            if (i < (correctNumOfLines - secondStringArray.count) / 2
                                || i >= ((correctNumOfLines - secondStringArray.count) / 2) + secondStringArray.count) {
                                
                                transPlus.append(makeTransparent(secondStringArray[0].string, size))
                                transPlus.append(transEqual)
                                postfixString.append(transPlus)
                                transPlus = makeTransparent(" * ", size)
                                
                            } else {
                                if (i == correctNumOfLines / 2) {
                                    concretePlus.append(secondStringArray[i - (correctNumOfLines - secondStringArray.count) / 2])
                                    concretePlus.append(concreteEqual)
                                    postfixString.append(concretePlus)
                                } else {
                                    transPlus.append(secondStringArray[i - (correctNumOfLines - secondStringArray.count) / 2])
                                    transPlus.append(transEqual)
                                    postfixString.append(transPlus)
                                    transPlus = makeTransparent(" * ", size)
                                }
                            }
                        }
                    } else {
                        // MARK: The right matrix is larger
                        // input count will change during the for loop
                        let tmp = inputStringArray.count
                        for i in 0..<secondStringArray.count {
                            
                            if (i < (correctNumOfLines - tmp) / 2) {
                                
                                var placeholder = makeTransparent(inputStringArray[0].string, size)
                                inputStringArray.insert(placeholder, at: 0)
                                placeholder = makeTransparent(outputStringArray[0].string, size)
                                outputStringArray.insert(placeholder, at: 0)
                                
                                transPlus.append(secondStringArray[i])
                                transPlus.append(transEqual)
                                postfixString.append(transPlus)
                                // debug
                                print(transPlus.string)
                                transPlus = makeTransparent(" * ", size)
                                
                            } else if (i >= (correctNumOfLines + tmp) / 2) {
                                
                                var placeholder = makeTransparent(inputStringArray[0].string, size)
                                inputStringArray.append(placeholder)
                                placeholder = makeTransparent(outputStringArray[0].string, size)
                                outputStringArray.append(placeholder)
                                
                                transPlus.append(secondStringArray[i])
                                transPlus.append(transEqual)
                                postfixString.append(transPlus)
                                // debug
                                print(transPlus.string)
                                transPlus = makeTransparent(" * ", size)
                                
                            } else {
                                if (i == correctNumOfLines / 2) {
                                    concretePlus.append(secondStringArray[i])
                                    concretePlus.append(concreteEqual)
                                    postfixString.append(concretePlus)
                                    // debug
                                    print(concretePlus.string)
                                } else {
                                    transPlus.append(secondStringArray[i])
                                    transPlus.append(transEqual)
                                    postfixString.append(transPlus)
                                    // debug
                                    print(transPlus.string)
                                    transPlus = makeTransparent(" * ", size)
                                }
                            }
                        }
                    }
                    var newString = mergeArrayOfString(prefixString, inputStringArray, postfixString, outputStringArray)
                    displayMatrix.attributedText = newString
                   
                }
                
                
                let correctNumOfLines: Int = correspondingLines(max(max(myResult.outputMatrix.count, myResult.secondMatrix.count),
                                                                    myResult.inputMatrix.count))
                
                print("actual number: \(displayMatrix.numberOfVisibleLines)")
                print("wanted number: \(correctNumOfLines)")
                
                if (displayMatrix.numberOfVisibleLines <= correctNumOfLines) {
                    fitted = true
                } else {
                    if (myResult.operationType == .inverse
                        || myResult.operationType == .transpose
                        || myResult.operationType == .power) {
                        if (displayMatrix.numberOfVisibleLines <= correctNumOfLines + 2) {
                            fitted = true
                        }
                    }
                    size -= 1
                }

                if (size <= 10) {fitted = true}
                
                
            }
            print(displayMatrix.numberOfVisibleLines)
        }
       
    }

    func mergeArrayOfString(_ prefixArray: [NSMutableAttributedString],_ firstMatrix: [NSMutableAttributedString],
                            _ postfixArray: [NSMutableAttributedString],_ secondMatrix: [NSMutableAttributedString]) -> NSMutableAttributedString {
        
        var newArray: [NSMutableAttributedString] = []
        if (prefixArray != []) {
            newArray = prefixArray
            for i in 0..<prefixArray.count {
                newArray[i].append(firstMatrix[i])
                if (postfixArray != []) {
                    newArray[i].append(postfixArray[i])
                }
                if (secondMatrix != []) {
                    newArray[i].append(secondMatrix[i])
                }
            }
        } else {
            newArray = firstMatrix
            for i in 0..<firstMatrix.count {
                if (postfixArray != []) {
                    newArray[i].append(postfixArray[i])
                }
                if (secondMatrix != []) {
                    newArray[i].append(secondMatrix[i])
                }
            }
        }
        
        var newString = NSMutableAttributedString(string: "")
        for i in 0..<newArray.count {
            newString.append(newArray[i])
            if (i != newArray.count - 1) {
                newString.append(NSMutableAttributedString(string: "\n"))
            }
        }
        
        return newString
    }

    
    func correspondingLines(_ x: Int) -> Int {
        
        if (x == 1) {
            return 4
        } else if (x == 2) {
            return 7
        } else if (x == 3) {
            return 9
        } else {
            return 12
        }
        
    }
    
    func disableButton() {
//        stackBckup = stackConstraint
//        setABckup = setAConstraint
//        setBBckup = setBConstraint
//        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        stackConstraint.constant = 0
//        stackConstraint = buttonStack.widthAnchor.constraint(equalToConstant: 0)
//        buttonStack.addConstraint(buttonStack.widthAnchor.constraint(equalToConstant: 0))
//        setToA.translatesAutoresizingMaskIntoConstraints = false
        setAConstraint.constant = 0
//            = setToA.widthAnchor.constraint(equalToConstant: 0)
//        setToA.removeConstraint(setAConstraint)
//        setToA.addConstraint()
//        setToB.translatesAutoresizingMaskIntoConstraints = false
        setBConstraint.constant = 0
//            = setToB.widthAnchor.constraint(equalToConstant: 0)
//        setToB.removeConstraint(setBConstraint)
//        setToB.addConstraint()
//        displayMatrix.addConstraint(displayMatrix.trailingAnchor.constraintEqualToSystemSpacingAfter(buttonStack.trailingAnchor, multiplier: 0))
        
//        displayMatrix.translatesAutoresizingMaskIntoConstraints = true
//        displayMatrix.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//        setToA.backgroundColor = UIColor(red: 240/255, green: 161/255, blue: 61/255, alpha: 1)
//        setToA.isEnabled = false
//        setToA.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0), for: UIControlState.normal)
//        setToB.backgroundColor = UIColor(red: 240/255, green: 161/255, blue: 61/255, alpha: 1)
//        setToB.isEnabled = false
//        setToB.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0), for: UIControlState.normal)
    }
    
    func enableButton() {
//        if (setABckup != nil) {
//            buttonStack.addConstraint(stackBckup!)
//            setToA.addConstraint(setABckup!)
//            setToB.addConstraint(setBBckup!)
////            buttonStack.translatesAutoresizingMaskIntoConstraints = false
////            setToA.translatesAutoresizingMaskIntoConstraints = false
////            setToB.translatesAutoresizingMaskIntoConstraints = false
////            stackConstraint = stackBckup
////            setAConstraint = setABckup
////            setBConstraint = setBBckup
//        }

        stackConstraint.constant = 70
        setAConstraint.constant = 70
        setBConstraint.constant = 70
//        stackConstraint = buttonStack.widthAnchor.constraint(equalToConstant: 70)
//        setAConstraint = setToA.widthAnchor.constraint(equalToConstant: 70)
//        setBConstraint = setToB.widthAnchor.constraint(equalToConstant: 70)
//        buttonStack.addConstraint(buttonStack.widthAnchor.constraint(equalToConstant: 70))
//        setToA.addConstraint(setToA.widthAnchor.constraint(equalToConstant: 70))
//        setToB.addConstraint(setToB.widthAnchor.constraint(equalToConstant: 70))
//        setToA.backgroundColor = UIColor(red: 240/255, green: 161/255, blue: 61/255, alpha: 1)
//        setToA.isEnabled = true
//        setToA.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: UIControlState.normal)
//        setToB.backgroundColor = UIColor(red: 240/255, green: 161/255, blue: 61/255, alpha: 1)
//        setToB.isEnabled = true
//        setToB.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: UIControlState.normal)
    }
    
    @IBAction func setAButton(_ sender: UIButton) {
        //        MARK: it should be output here
        delegate?.updateCurentMatrix(newMatrix: (resultToPrsent?.outputMatrix)!)
    }
    
    @IBAction func setBButton(_ sender: UIButton) {
        //        MARK: it should be output here
        delegate?.updateSeconderyMatrix(newMatrix: (resultToPrsent?.outputMatrix)!)
    }
    
    
    // MARK: Simple Matrix String
    func convertArrayIntoString(myMatrix: [[Double]],_ size: Int) -> NSMutableAttributedString {
        let myText = makeAttributedString("", size)
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
            // count for row
            count += 1
            // count for col
            var newTmp = 0
            myText.append(makeTransparent("┏", size))
            for j in 0...(myMatrix[0].count - 1) {
                newTmp += 1
                // for decimal digit
                var firstTime = true
                
                // before
                for _ in 0..<((longestDigits[j].0 - arrayOfDigits[i][j].0) - (longestDigits[j].0 - arrayOfDigits[i][j].0) / 2) {
                    
                    if (longestDigits[j].1 != 0 && arrayOfDigits[i][j].1 == 0 && firstTime) {
                        myText.append(makeTransparent(".", size))
                        firstTime = false
                        continue
                    }
                    myText.append(makeTransparent("0", size))
                }
                
                // In the middle
                if (countDigitsOfDouble(x: myMatrix[i][j]).1 == 0) {
                    myText.append(makeAttributedString(String(Int(round(myMatrix[i][j]))), size))
                } else {
                    myText.append(makeAttributedString(String(round(100 * myMatrix[i][j]) / 100), size))
                }
                
                // after
//                print("MARK 2: \((longestDigits[j].0 - arrayOfDigits[i][j].0) / 2 + 1)")
                for _ in 0..<((longestDigits[j].0 - arrayOfDigits[i][j].0) / 2) {
                    myText.append(makeTransparent("0", size))
                }
                
//                print(myText.string)
                if (newTmp != myMatrix[0].count) {
                    for _ in 1...2 {
                        myText.append(makeTransparent(" ", size))
                    }
                }
//                print(myText.string)
            }
            if (count == myMatrix.count) {
                myText.append(makeTransparent("┓", size))
                myText.append(makeAttributedString("\n", size))
            } else {
                myText.append(makeTransparent("┓\n┏\(tmp)┓\n", size))
                
            }
        }
        
        
        
        
        // Upper bound
        
        myText.insert(makeAttributedString("┓\n", size), at: 0)
        myText.insert(makeTransparent(tmp, size), at: 0)
        myText.insert(makeAttributedString("┏", size), at: 0)
        
        // Lower bound
        myText.append(makeAttributedString("┗", size))
        myText.append(makeTransparent(tmp, size))
        myText.append(makeAttributedString("┛", size))
                
        return myText
    }
    
    // convert a whole Attributed String into array of strings
    func breakIntoPieces(_ input: NSMutableAttributedString) -> [NSMutableAttributedString] {
        
        
        var myArrayOfAString: [NSMutableAttributedString] = []
        let originalString = input.string



        var start = 0
        let tmpArray = originalString.split(separator: "\n")
        var count = 0
        for i in tmpArray {
            count += 1
            myArrayOfAString.append(input.attributedSubstring(from: NSRange(start...start + i.count - 1)) as! NSMutableAttributedString)
            start = i.count + start + 1
            if (count == tmpArray.count - 1) {
                myArrayOfAString.append(input.attributedSubstring(from: NSRange(start...start + i.count - 1)) as! NSMutableAttributedString)
                break
            }
        }

        return myArrayOfAString
    }
    
    
    // Helpers:
    func countDigitsOfDouble(x: Double) -> (Int, Int) {
        
        if (x == 0) {
            return (1, 0)
        }
        
        var bckup = abs(x)
        var secondBckup = abs(x)
        var count: Int = 0
        
        // 0 still hold 1 decimal place
        
        if (bckup < 1) {
            count = 1
        }
        
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
        
        // 1 is shorter than normal digit
        
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
    
    func createDiagonalMatrix(_ eigenvals: [Double]) -> [[Double]] {
        var newMatrix: [[Double]] = []
        
        for i in 0..<eigenvals.count {
            
            var tmp: [Double] = []
            for j in 0..<eigenvals.count {
                if (i == j) {
                    tmp.append(eigenvals[i])
                } else {
                    tmp.append(0)
                }
            }
            newMatrix.append(tmp)
        }
        
        return newMatrix
    }
    
    func makeAttributedString(_ str: String,_ size: Int) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: str, attributes: [NSAttributedStringKey.font : UIFont(name: "ChalkboardSE-Regular", size: CGFloat(size)) as Any])
    }
    
    func makeTransparent(_ str: String,_ size: Int) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: str, attributes: [NSAttributedStringKey.foregroundColor : UIColor(red: 10/255, green: 190/255, blue: 50/255, alpha: 0), NSAttributedStringKey.font : UIFont(name: "ChalkboardSE-Regular", size: CGFloat(size)) as Any])
    }
}

extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}


