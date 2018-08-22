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

func convertOperationIntoString(op: myOperations) -> String {
    switch op {
    case .inverse:
        return "inverse"
    case .power:
        return "power"
    case .determinate:
        return "determinate"
    case .diagonal:
        return "diagoanl"
    case .RREF:
        return "RREF"
    case .eigenvalue:
        return "eigenvalue"
    case .transpose:
        return "transpose"
    case .addition:
        return "+"
    case .substraction:
        return "-"
    case .multiplication:
        return "*"
    }
}

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
    var degreeOfPower = 0 // For power operation only
    var inputMatrix: [[Double]]
    var outputMatrix: [[Double]] = [[0]]
    init(_ input: [[Double]],_ operation: myOperations,_ power: Int = 0) {
        operationType = operation
//        if (operation == myOperations.power) {
        degreeOfPower = power
//        }
        inputMatrix = input
    }
}
