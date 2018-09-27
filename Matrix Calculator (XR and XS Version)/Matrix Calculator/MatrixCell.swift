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
    var needHelight: Bool = false
    var userInput: Bool = false
    var pointer: UITextField
    
    init(_ x: Int,_ y: Int,_ myPointer: UITextField) {
        col = y
        row = x
        pointer = myPointer
        initialize()
    }
    
    func initialize() {
        // The default occupied cells are 2 * 2 array
        if (col < 2 && row < 2) {
            value = 0
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
        if (value - Double(Int(value)) == 0) {
            pointer.text = "\(Int(value))"
        } else {
            pointer.text = "\(Double(avoidRoundingError(x: value, precise: 2)) / 100)"
//            No need for this, at least for now
//            "\(String(format: "%.2f", Double(round(1000*value)/1000)))"
        }
        pointer.textColor = UIColor.white
        pointer.backgroundColor = UIColor.lightGray
        if needHelight {
            pointer.alpha = 0.9
        } else {
            pointer.alpha = 0.3
        }
    }
    
    func updateHighlight(_ x: Int,_ y: Int) {
        if (col <= y && row <= x) {
            needHelight = true
        }
    }
    
    func cancelHighlight(_ x: Int,_ y: Int) {
        if (col > y || row > x) {
            needHelight = false
        }
    }
    
    func entryInput(_ message: String) {
        userInput = true
        value = Double(message)!
    }
    
    func deleteInput() {
        if (row > 1 || col > 1) {
            userInput = false
        }
        value = 0
    }
    
}

