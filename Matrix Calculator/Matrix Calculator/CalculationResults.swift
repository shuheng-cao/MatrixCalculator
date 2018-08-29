//
//  CalculationResults.swift
//  Matrix!
//
//  Created by shuster on 2018/8/10.
//  Copyright © 2018 曹书恒. All rights reserved.
//

import Foundation
import UIKit

enum myOperations {
    case inverse
    case power
    case determinate
    case diagonal
    case RREF
    case eigenvalue
    case transpose
    case addition
    case substraction
    case multiplication
}

// For debugging use
var count = 0

//func convertOperationIntoString(op: myOperations) -> String {
//    switch op {
//    case .inverse:
//        return "inverse"
//    case .power:
//        return "power"
//    case .determinate:
//        return "determinate"
//    case .diagonal:
//        return "diagoanl"
//    case .RREF:
//        return "RREF"
//    case .eigenvalue:
//        return "eigenvalue"
//    case .transpose:
//        return "transpose"
//    case .addition:
//        return "+"
//    case .substraction:
//        return "-"
//    case .multiplication:
//        return "*"
//    }
//}

//class myMatrix {
//    var row: Int
//    var col: Int
//    var matrixEntries: [[Double]]
//    init(_ input: [[Double]]) {
//        row = input.count
//        col = input[0].count
//        matrixEntries = input
//    }
//}

class myCalculationResult {
    var operationType: myOperations
    var degreeOfPower = 0
    // For power operation only
    var inputMatrix: [[Double]]
    var outputMatrix: [[Double]] = [[0]]
    init(_ input: [[Double]],_ operation: myOperations,_ power: Int = 0) {
        operationType = operation
        degreeOfPower = power
        inputMatrix = input
        switch operation {
        case .RREF:
            outputMatrix = calRREF(myMatrix: input)
            print("RREF: \(calRREF(myMatrix: input))")
        case .inverse:
            print("inverse: ")
        case .power:
            print("power: ")
        case .determinate:
            print("det: \(calDeterminant(myMatrix: input))")
        case .diagonal:
            print("diagonal: ")
        case .eigenvalue:
            print("eigenvalue: ")
        case .transpose:
            print("transpose: ")
        case .addition:
            print("addition: ")
        case .substraction:
            print("substraction: ")
        case .multiplication:
            print("multiplication: ")
        }
    }
}

// find the determinant
func calDeterminant(myMatrix: [[Double]]) -> Double {
    if (myMatrix.count == 2) {
        return myMatrix[0][0] * myMatrix[1][1] - myMatrix[0][1] * myMatrix[1][0]
    } else {
        var answer: Double = 0
        for i in 0..<myMatrix.count {
            if (i % 2 == 0) {
                answer += myMatrix[i][0] * calDeterminant(myMatrix: deleteRowAndColumn(myMatrix: myMatrix, x: i, y: 0))
            } else {
                answer -= myMatrix[i][0] * calDeterminant(myMatrix: deleteRowAndColumn(myMatrix: myMatrix, x: i, y: 0))
            }
        }
        return answer
    }
}

// helper for calDeterminant
func deleteRowAndColumn(myMatrix: [[Double]], x: Int, y: Int) -> [[Double]] {
    var newMatrix: [[Double]] = []
    for i in 0..<myMatrix.count {
        var tmp: [Double] = []
        for j in 0..<myMatrix[0].count {
            if (i != x && j != y) {
                tmp.append(myMatrix[i][j])
            }
        }
        if (tmp != []) {
            newMatrix.append(tmp)
        }
    }
    print(newMatrix)
    return newMatrix
}

// helper for RREF
func calRREF(myMatrix: [[Double]]) -> [[Double]] {
    
    count += 1
    print("round \(count): \(myMatrix)")
    
    if (myMatrix.count == 1) {
//      Base Case I
        var tmp: [Double] = []
        var pivot: Double = 1
        for i in myMatrix[0] {
            // To avoid rounding error
            if (avoidRoundingError(x: i, precise: 5) != 0) {
                pivot = i
                break
            }
        }
        for i in myMatrix[0] {
            tmp.append(i / pivot)
        }
        return [tmp]
    } else if (myMatrix[0].count == 1) {
//      Base Case II
        var allZero = true
        for i in myMatrix {
            // To avoid rounding error
            if (avoidRoundingError(x: i[0], precise: 5) != 0) {
                allZero = false
            }
        }
        
        var tmp: [[Double]] = []
        if (allZero) {
            tmp.append([0])
        } else {
            tmp.append([1])
        }
        
        for _ in 1..<myMatrix.count {
            tmp.append([0])
        }
        return tmp
    } else {
//        Recursive Case
//        Firstly, we need to keep everything in order
        var newMatrix: [[Double]] = []
        for i in myMatrix {
            if (newMatrix == []) {
                newMatrix.append(i)
            } else {
                // Make sure the smallest non-zero is at first line
                if ((abs(i[0]) < abs(newMatrix[0][0]) && avoidRoundingError(x: i[0], precise: 5) != 0)
                    || avoidRoundingError(x: newMatrix[0][0], precise: 5) == 0) {
                    newMatrix.insert(i, at: 0)
                } else {
                    newMatrix.append(i)
                }
            }
        }
        
//        Secondly, make the first column a RREF
//        If the top left corner is non-zero
        if (avoidRoundingError(x: newMatrix[0][0], precise: 5) != 0) {
            // make sure entry (0, 0) is 1
            for i in 1..<newMatrix[0].count {
                newMatrix[0][i] = ( newMatrix[0][i] / newMatrix[0][0] )
            }
            newMatrix[0][0] = 1
            
            for j in 1..<newMatrix.count {
                newMatrix[j] = makeTheFisrtZero(newMatrix[0], rowToBeMutate: newMatrix[j], p: 0)
            }
        }
        
        // the remaining should be in RREF form
        let theRemaining: [[Double]] = calRREF(myMatrix: ingnoreTheFirstColAndRow(aMatrix: newMatrix))
        
        newMatrix = [newMatrix[0]]
//        Adding zeros to the first col
        for i in theRemaining {
            var tmp: [Double] = i
            tmp.insert(0, at: 0)
            newMatrix.append(tmp)
        }
        
        count += 1
        print("round \(count): \(newMatrix)")
        
//         TODO: erase the non-zero number in first line
        for i in 1..<newMatrix.count {
            let indexOfLeadingOne = leadingOne(aRow: newMatrix[i])
            if (indexOfLeadingOne == -1) {
                continue
            } else {
                let newFirstRow = makeTheFisrtZero(newMatrix[i], rowToBeMutate: newMatrix[0], p: indexOfLeadingOne)
                newMatrix[0] = newFirstRow
            }
        }
        
        count += 1
        print("round \(count): \(newMatrix)")
        
//        At last, orgonize it in the correct order
        for i in 0..<newMatrix.count {
            if (allZero(aRow: newMatrix[i])) {
                newMatrix.append(newMatrix[i])
                newMatrix.remove(at: i)
            }
        }
        
        return newMatrix
    }
}

//    helper for RREF
//    Require: the first item must be 1 at index p
func makeTheFisrtZero(_ rowWithLeadingOne: [Double], rowToBeMutate: [Double], p: Int) -> [Double] {
    var newRow: [Double] = []
    
    for i in 0..<p {
        newRow.append(rowToBeMutate[i])
    }
    
    for i in p..<rowWithLeadingOne.count {
        newRow.append(rowToBeMutate[i] - rowWithLeadingOne[i] * rowToBeMutate[p])
    }
    
    return newRow
}

func ingnoreTheFirstColAndRow(aMatrix: [[Double]]) -> [[Double]] {
    var newMatrix: [[Double]] = []
    var firstTIme = true
    for i in aMatrix {
        if (firstTIme) {
            firstTIme = false
            continue
        }
        var tmp: [Double] = []
        for j in 1..<i.count {
            tmp.append(i[j])
        }
        newMatrix.append(tmp)
    }
    
    return newMatrix
}

func leadingOne(aRow: [Double]) -> Int {
    
    for i in 0..<aRow.count {
        if ( avoidRoundingError(x: aRow[i], precise: 5) == 100000 ) {
            return i
        }
        // For debugging only
        assert( avoidRoundingError(x: aRow[i], precise: 5) == 0 )
    }
    
    return -1
}

// To avoid rounding error, we multiply the double by 10...0 times
func avoidRoundingError(x: Double, precise: Int) -> Int {
    var tmp = x
    // Off by one
    for _ in 0...precise {
        tmp = tmp * 10
    }
    
    var intTmp = Int(tmp)
    if (intTmp % 10 >= 5) {
        intTmp += 1
    }
    
    return ( intTmp / 10 )
}

func allZero(aRow: [Double]) -> Bool {
    for i in aRow {
        if (avoidRoundingError(x: i, precise: 5) != 0) {
            return false
        }
    }
    return true
}

// very useful tool but not shown in my APP
func calRank(myMatrix: [[Double]]) -> Int {
    
    var count = 0
    let rrefForm = calRREF(myMatrix: myMatrix)
    
    for i in rrefForm {
        if (leadingOne(aRow: i) != -1) {
            count += 1
        }
    }
    
    return count
}



