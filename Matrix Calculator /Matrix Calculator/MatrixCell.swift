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
    
    var value: Int = 0
    var needHelight: Bool = false
    var userInput: Bool = false
    var pointer: UITextField
    
    init(_ x: Int,_ y: Int,_ myPointer: UITextField) {
        col = x
        row = y
        pointer = myPointer
        initialize(x, y)
    }
    
    func initialize(_ x: Int,_ y: Int) {
        // The default occupied cells are 2 * 2 array
        if (x < 2 && y < 2) {
            userInput = true
            needHelight = true
        } else {
            value = 0
            userInput = false
            needHelight = false
        }
        //initialization for UITextField
        updateAfterTouched()
    }
    
    func updateAfterTouched() {
        pointer.text = "\(Int(value))"
        pointer.textColor = UIColor.white
        pointer.backgroundColor = UIColor.lightGray
        if needHelight {
            pointer.alpha = 0.9
        } else {
            pointer.alpha = 0.3
        }
    }
    
    func updateHighlight(_ x: Int,_ y: Int) {
        if (col <= x && row <= y) {
            needHelight = true
        }
    }
    
    func cancelHighlight(_ x: Int,_ y: Int) {
        if (col > x || row > y) {
            needHelight = false
        }
    }
    
    func entryInput(_ message: String) {
        userInput = true
        value = Int(message)!
    }
    
    func deleteInput() {
        if (row > 1 || col > 1) {
            userInput = false
        }
        value = 0
    }
    
}

