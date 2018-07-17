//
//  ViewController.swift
//  Matrix Calculator
//
//  Created by shuster on 2018/7/16.
//  Copyright © 2018 曹书恒. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var matrixCells: [[myCellType]] = [[], [], [], []]
    // Can be improved, it's too detious:
    // Row 1:
    @IBOutlet weak var Entry11: UITextField!
    @IBOutlet weak var Entry12: UITextField!
    @IBOutlet weak var Entry13: UITextField!
    @IBOutlet weak var Entry14: UITextField!
    // Row 2:
    @IBOutlet weak var Entry21: UITextField!
    @IBOutlet weak var Entry22: UITextField!
    @IBOutlet weak var Entry23: UITextField!
    @IBOutlet weak var Entry24: UITextField!
    // Row 3:
    @IBOutlet weak var Entry31: UITextField!
    @IBOutlet weak var Entry32: UITextField!
    @IBOutlet weak var Entry33: UITextField!
    @IBOutlet weak var Entry34: UITextField!
    // Row 4:
    @IBOutlet weak var Entry41: UITextField!
    @IBOutlet weak var Entry42: UITextField!
    @IBOutlet weak var Entry43: UITextField!
    @IBOutlet weak var Entry44: UITextField!
    

    
    
    override func viewDidLoad() {
        
        // Way too tedious
        // Bad style but success initialization:
        matrixCells[0].append(myCellType(1, 1, Entry11))
        matrixCells[0].append(myCellType(1, 2, Entry12))
        matrixCells[0].append(myCellType(1, 3, Entry13))
        matrixCells[0].append(myCellType(1, 4, Entry14))
        matrixCells[1].append(myCellType(2, 1, Entry21))
        matrixCells[1].append(myCellType(2, 2, Entry22))
        matrixCells[1].append(myCellType(2, 3, Entry23))
        matrixCells[1].append(myCellType(2, 4, Entry24))
        matrixCells[2].append(myCellType(3, 1, Entry31))
        matrixCells[2].append(myCellType(3, 2, Entry32))
        matrixCells[2].append(myCellType(3, 3, Entry33))
        matrixCells[2].append(myCellType(3, 4, Entry34))
        matrixCells[3].append(myCellType(4, 1, Entry41))
        matrixCells[3].append(myCellType(4, 2, Entry42))
        matrixCells[3].append(myCellType(4, 3, Entry43))
        matrixCells[3].append(myCellType(4, 4, Entry44))
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
    }
    
    @objc func tap(sender: UITapGestureRecognizer){
        print("tapped")
        view.endEditing(true)
    }
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}



