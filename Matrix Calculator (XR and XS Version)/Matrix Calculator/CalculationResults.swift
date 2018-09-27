//
//  CalculationResults.swift
//  Matrix!
//
//  Created by shuster on 2018/8/10.
//  Copyright © 2018 曹书恒. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

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

class myCalculationResult {
    // For inverse operation only
    var invertible = false
    // For power operation only
    var degreeOfPower = 0
    // For eigenvalues only
    var eigenvectors: [[Double]] = []
    // For diagonalizable only
    var diagonalizable: Bool = false
    // For landscape mode only
    var secondMatrix: [[Double]] = []
    // General Case:
    var operationType: myOperations
    var inputMatrix: [[Double]]
    var outputMatrix: [[Double]]
    init(_ input: [[Double]],_ operation: myOperations,_ power: Int = 0,_ secondInput: [[Double]] = []) {
        operationType = operation
        degreeOfPower = power
        inputMatrix = input
        secondMatrix = secondInput
        switch operation {
        case .RREF:
            outputMatrix = calRREF(myMatrix: input)
        case .inverse:
            if (calDeterminant(myMatrix: input) != 0) {
                invertible = true
            }
            outputMatrix = calInverse(input)
        case .power:
            outputMatrix = calPower(myMatrix: input, toPower: power)
        case .determinate:
            outputMatrix = [[calDeterminant(myMatrix: input)]]
        case .diagonal:
            let tmp = calDiagonal(myMatrix: input)
            outputMatrix = [tmp.1]
            eigenvectors = tmp.0
            diagonalizable = tmp.2
        case .eigenvalue:
            outputMatrix = [calEigenvalue(myMatrix: input)]
        case .transpose:
            outputMatrix = calTranspose(myMatrix: input)
        case .addition:
            outputMatrix = calAddition(leftMatrix: inputMatrix, rightMatrix: secondMatrix)
        case .substraction:
            outputMatrix = calSubstrraction(leftMatrix: inputMatrix, rightMatrix: secondMatrix)
        case .multiplication:
            outputMatrix = calMultiplication(leftMatrix: inputMatrix, rightMatrix: secondMatrix)
        }
    }
}

// MARK: Determinant
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
//    print(newMatrix)
    return newMatrix
}

// MARK: RREF
func calRREF(myMatrix: [[Double]]) -> [[Double]] {
//
//    count += 1
//    print("round \(count): \(myMatrix)")
    
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
        
            
            // the remaining should be in RREF form
            let theRemaining: [[Double]] = calRREF(myMatrix: ingnoreTheFirstColAndRow(aMatrix: newMatrix))
            
            newMatrix = [newMatrix[0]]
            //        Adding zeros to the first col
            for i in theRemaining {
                var tmp: [Double] = i
                tmp.insert(0, at: 0)
                newMatrix.append(tmp)
            }
            
            //        count += 1
            //        print("round \(count): \(newMatrix)")
            
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
        } else {
            // when the first col are all zeros
            let theRemaining: [[Double]] = calRREF(myMatrix: ignoreTheFirstCol(aMatrix: newMatrix))
            newMatrix = []
            newMatrix = addingZerosAsFirstCol(aMatrix: theRemaining)
        }
        
//        count += 1
//        print("round \(count): \(newMatrix)")
        
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
func addingZerosAsFirstCol(aMatrix: [[Double]]) -> [[Double]] {
    var newMatrix: [[Double]] = []
    
    for i in aMatrix {
        var tmp = i
        tmp.insert(0, at: 0)
        newMatrix.append(tmp)
    }
    
    return newMatrix
}

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

func ignoreTheFirstCol(aMatrix: [[Double]]) -> [[Double]] {
        var newMatrix: [[Double]] = []
        for i in aMatrix {
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

// MARK: Rank
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

// MARK: Transpose
func calTranspose(myMatrix: [[Double]]) -> [[Double]] {
    
    var newMatrix: [[Double]] = []
    
    for i in 0..<myMatrix[0].count {
        var tmp: [Double] = []
        for j in 0..<myMatrix.count {
            tmp.append(myMatrix[j][i])
        }
        newMatrix.append(tmp)
    }
    
    return newMatrix
}

// MARK: Inverse
//func calInverse(myMatrix: [[Double]]) -> [[Double]] {
//
//    var newMatrix: [[Double]] = []
//
//    var addingIdentity: [[Double]] = []
//    for i in 0..<myMatrix.count {
//        var tmp: [Double] = myMatrix[i]
//        for j in 0..<myMatrix[0].count {
//            if (j == i) {
//                tmp.append(1)
//            } else {
//                tmp.append(0)
//            }
//        }
//        addingIdentity.append(tmp)
//    }
//
//    let rrefForm = calRREF(myMatrix: addingIdentity)
//
//    for i in 0..<addingIdentity.count {
//        var tmp: [Double] = []
//        for j in myMatrix[0].count..<addingIdentity[0].count {
//            tmp.append(rrefForm[i][j])
//        }
//        newMatrix.append(tmp)
//    }
//
//    return newMatrix
//}

func calInverse(_ A: [[Double]]) -> [[Double]] {
//    precondition(A.rows == A.cols, "Matrix dimensions must agree")
    var M = __CLPK_integer(A.count)
    var N = M
    var LDA = N
    var pivot = [__CLPK_integer](repeating: 0, count: Int(N))
    
    var wkOpt = __CLPK_doublereal(0.0)
    var lWork = __CLPK_integer(-1)
    
    var error: __CLPK_integer = 0
    var flattenedMatrix = flattenMatrix(myMatrix: A)
    
    dgetrf_(&M, &N, &flattenedMatrix, &LDA, &pivot, &error)
    
//    precondition(error == 0, "Matrix is non invertible")
    
    /* Query and allocate the optimal workspace */
    
    dgetri_(&N, &flattenedMatrix, &LDA, &pivot, &wkOpt, &lWork, &error)
    
    lWork = __CLPK_integer(wkOpt)
//    var work = Vector(repeating: 0.0, count: Int(lWork))
    
    /* Compute inversed matrix */
    
    dgetri_(&N, &flattenedMatrix, &LDA, &pivot, &wkOpt, &lWork, &error)
    
//    precondition(error == 0, "Matrix is non invertible")
    var newMatrix: [[Double]] = []
    for i in 0..<A.count {
        var tmp: [Double] = []
        for j in 0..<A.count {
            tmp.append(flattenedMatrix[i * A.count + j])
        }
        newMatrix.append(tmp)
    }
    return newMatrix
}

// MARK: Multiplication
func calMultiplication(leftMatrix: [[Double]], rightMatrix: [[Double]]) -> [[Double]] {
    
    var newMatrix: [[Double]] = []
    
    
    for row in 0..<leftMatrix.count {
        var tmpRow: [Double] = []
        for col in 0..<rightMatrix[0].count {
            var sum: Double = 0
            for k in 0..<leftMatrix[0].count {
                sum += leftMatrix[row][k] * rightMatrix[k][col]
            }
            tmpRow.append(sum)
        }
        newMatrix.append(tmpRow)
    }
    
    return newMatrix
}

// MARK: Power
func calPower(myMatrix: [[Double]], toPower: Int) -> [[Double]] {
    
    var newMatrix: [[Double]] = myMatrix
    
    for _ in 1..<toPower {
        newMatrix = calMultiplication(leftMatrix: newMatrix, rightMatrix: myMatrix)
    }
    
    return newMatrix
}

// MARK: Diagonalization
func calDiagonal(myMatrix: [[Double]]) -> ([[Double]], [Double], Bool) {
    
    
    
    var matrix:[__CLPK_doublereal] = flattenMatrix(myMatrix: myMatrix)
    
    var N = __CLPK_integer(sqrt(Double(matrix.count)))
    //var pivots = [__CLPK_integer](repeating: 0, count: Int(N))
    
    var LDA = N
    
    var wkOpt = __CLPK_doublereal(0.0)
    var lWork = __CLPK_integer(-1)
    
    var jobvl: Int8 = 86 // 'V'
    var jobvr: Int8 = 86 // 'V'
    
    var error = __CLPK_integer(0)
    // Real parts of eigenvalues
    var wr = [Double](repeating: 0, count: Int(N))
    // Imaginary parts of eigenvalues
    var wi = [Double](repeating: 0, count: Int(N))
    // Left eigenvectors
    var vl = [__CLPK_doublereal](repeating: 0, count: Int(N*N))
    // Right eigenvectors
    var vr = [__CLPK_doublereal](repeating: 0, count: Int(N*N))
    
    var ldvl = N
    var ldvr = N
    
    /* Query and allocate the optimal workspace */
    var workspaceQuery: Double = 0.0
    dgeev_(&jobvl, &jobvr, &N, &matrix, &LDA, &wr, &wi, &vl, &ldvl, &vr, &ldvr, &workspaceQuery, &lWork, &error)
    
    
    // size workspace per the results of the query:
    var workspace = [Double](repeating: 0.0, count: Int(workspaceQuery))
    lWork = __CLPK_integer(workspaceQuery)
    
    /* Compute eigen vectors */
    dgeev_(&jobvl, &jobvr, &N, &matrix, &LDA, &wr, &wi, &vl, &ldvl, &vr, &ldvr, &workspace, &lWork, &error)
    
    var newMatrix: [[Double]] = myMatrix
    
    for i in 0..<myMatrix.count {
        for j in 0..<myMatrix[0].count {
            newMatrix[j][i] = vl[i * myMatrix.count + j]
        }
    }
    
    // To check whether the eigenvals are correct
    var count = 0
    var diagonalizable = true
    var acc: [Int] = []
    
    for i in 0..<wr.count {
        let tmp = calSubstrraction(leftMatrix: myMatrix, rightMatrix: scalarIdentityMatrix(dimension: myMatrix.count, scaler: wr[i]))
        let rank = calRank(myMatrix: tmp)
        if (rank == myMatrix.count) {
            acc.append(i)
            diagonalizable = false
        } else {
            count += myMatrix.count - rank
        }
    }
    
    for i in (0..<acc.count).reversed() {
        wr.remove(at: acc[i])
    }
    
    if (count != myMatrix.count) {
        diagonalizable = false
    }
    
    // To avoid repeat
    var arrayOfEigenvals: [Double] = []
    for i in wr {
        var tmp = Double(round(i * 1000) / 1000)
        if (!includedIn(tmp, arrayOfEigenvals)) {
            arrayOfEigenvals.append(tmp)
        }
    }
    
    // Special Case for matrix that already diagonalized
    var alreadyDiagonal: Bool = true
    for i in 0..<myMatrix.count {
        for j in 0..<myMatrix[0].count {
            if (i != j && avoidRoundingError(x: myMatrix[i][j], precise: 5) != 0) {
                alreadyDiagonal = false
            }
        }
    }
    
    if alreadyDiagonal {
        newMatrix.removeAll()
        newMatrix = scalarIdentityMatrix(dimension: myMatrix.count, scaler: 1)
        arrayOfEigenvals.removeAll()
        for i in 0..<myMatrix.count {
            if (!includedIn(myMatrix[i][i], arrayOfEigenvals)) {
                arrayOfEigenvals.append(myMatrix[i][i])
            }
        }
        diagonalizable = true
    }
    
    return (newMatrix, arrayOfEigenvals, diagonalizable);
}

// helper for egienvals
func includedIn(_ x: Double,_ arrayOfDouble: [Double]) -> Bool {
    for i in arrayOfDouble {
        if (x == i) { return true }
    }
    return false
}

func flattenMatrix(myMatrix: [[Double]]) -> [__CLPK_doublereal] {
    
    var tmp:[__CLPK_doublereal] = []
    
    for i in myMatrix {
        for j in i {
            tmp.append(__CLPK_doublereal(j))
        }
    }
    
    return tmp
}

func scalarIdentityMatrix(dimension: Int, scaler: Double) -> [[Double]] {
    var newMatrix: [[Double]] = []
    
    for i in 0..<dimension {
        var tmp: [Double] = []
        for j in 0..<dimension {
            if (i == j) {
                tmp.append(scaler)
            } else {
                tmp.append(0)
            }
        }
        newMatrix.append(tmp)
    }
    
    return newMatrix
}

// MARK: Eigenvalues
func calEigenvalue(myMatrix: [[Double]]) -> [Double] {
    return calDiagonal(myMatrix: myMatrix).1
}

// MARK: Addition and Substraction
func calAddition(leftMatrix:[[Double]], rightMatrix: [[Double]]) -> [[Double]] {
    var newMatrix: [[Double]] = []
    for i in 0..<leftMatrix.count {
        var tmp: [Double] = []
        for j in 0..<leftMatrix[0].count {
            tmp.append(leftMatrix[i][j] + rightMatrix[i][j])
        }
        newMatrix.append(tmp)
    }
    
    return newMatrix
}

func calSubstrraction(leftMatrix:[[Double]], rightMatrix: [[Double]]) -> [[Double]] {
    var newMatrix: [[Double]] = []
    for i in 0..<leftMatrix.count {
        var tmp: [Double] = []
        for j in 0..<leftMatrix[0].count {
            tmp.append(leftMatrix[i][j] - rightMatrix[i][j])
        }
        newMatrix.append(tmp)
    }
    
    return newMatrix
}


