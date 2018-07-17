//
//  File.swift
//  Matrix Calculator
//
//  Created by shuster on 2018/7/16.
//  Copyright © 2018 曹书恒. All rights reserved.
//

import Foundation
import UIKit

class myCellType {
    var col: Int
    var row: Int
    
    var value: Double = 0
    var needHelight: Bool
    var pointer: UITextField
    
    init(_ x: Int,_ y: Int,_ myPointer: UITextField) {
        col = x
        row = y
        pointer = myPointer
        // The default occupied cells are 2 * 2 array
        if (x < 3 && y < 3) {
            needHelight = true
        } else {
            needHelight = false
        }
        //initialization for UITextField
        pointer.text = "\(Int(value))"
        pointer.textColor = UIColor.white
        pointer.backgroundColor = UIColor.lightGray
        if needHelight {
            pointer.alpha = 0.9
        } else {
            pointer.alpha = 0.3
        }
    }
}

