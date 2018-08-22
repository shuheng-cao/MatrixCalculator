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

    @IBOutlet weak var displayMatrix: UILabel!
    @IBOutlet weak var setToA: UIButton!
    @IBOutlet weak var setToB: UIButton!
    
    func setHistoryCell(myResult: myCalculationResult) {
        
        setToA.layer.cornerRadius = 5
        setToB.layer.cornerRadius = 5
        
        displayMatrix.text = convertOperationIntoString(op: myResult.operationType) + " of "
        + convertArrayIntoString(myMatrix: myResult.inputMatrix) + " is " + convertArrayIntoString(myMatrix: myResult.outputMatrix)
    }
    
    func convertArrayIntoString(myMatrix: [[Double]]) -> String {
        var tmp = ""
        
        return tmp
    }
}

