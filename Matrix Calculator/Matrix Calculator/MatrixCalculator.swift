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
    
    // Buttons:
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var powerButton: UIButton!
    @IBOutlet weak var inverseButton: UIButton!
    @IBOutlet weak var nullSpaceButton: UIButton!
    @IBOutlet weak var eigenVectorButton: UIButton!
    @IBOutlet weak var eigenValuebutton: UIButton!
    @IBOutlet weak var colSpaceButton: UIButton!
    @IBOutlet weak var transposeButton: UIButton!
    
    

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
        
        // Set up shape of button
        clearButton.layer.cornerRadius = 5
        historyButton.layer.cornerRadius = 5
        powerButton.layer.cornerRadius = 5
        inverseButton.layer.cornerRadius = 5
        nullSpaceButton.layer.cornerRadius = 5
        eigenValuebutton.layer.cornerRadius = 5
        eigenVectorButton.layer.cornerRadius = 5
        colSpaceButton.layer.cornerRadius = 5
        transposeButton.layer.cornerRadius = 5
        
        super.viewDidLoad()
        
        // go to History Table by swipping
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        // Adding extra feature to existing keyboard
        for i in 0...3 {
            for j in 0...3 {
                let toolBar = UIToolbar()
                toolBar.sizeToFit()
                
                let plusOrminusButton = UIBarButtonItem(title: "+ / -", style: .done, target: self, action: #selector(plusOrMinus))
                
                let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
                
                let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(self.nextCell))
                
                let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
                
                toolBar.setItems([doneButton, flexibleSpace, plusOrminusButton, flexibleSpace, nextButton], animated: false)
                
                matrixCells[i][j].pointer.inputAccessoryView = toolBar
            }
        }
        
        self.navigationController?.isNavigationBarHidden = true
        
        // Hid the keyboard by touching outside
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
        
        
    }
    
    // For the use of additional feature in keyboard
    @objc func plusOrMinus() {
        for i in matrixCells {
            for j in i {
                if (j.pointer.isEditing) {
                    let tmp = Double(j.pointer.text!)
                    if (tmp != nil) {
                        j.value = -tmp!
                        j.updateAfterTouched()
                    }
                }
            }
        }
    }
    
    @objc func nextCell() {
        var currentResponser: (Int, Int) = (1, 1)
        for i in matrixCells {
            for j in i {
                if (j.pointer.isEditing) {
                    currentResponser = (j.row, j.col)
                }
            }
        }
        if (currentResponser.1 != 4) {
            matrixCells[currentResponser.0 - 1][currentResponser.1].pointer.becomeFirstResponder()
        } else if (currentResponser.0 != 4) {
            matrixCells[currentResponser.0][0].pointer.becomeFirstResponder()
        } else {
            matrixCells[0][0].pointer.becomeFirstResponder()
        }
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    @objc func tap(sender: UITapGestureRecognizer){
        print("tapped")
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Control Center: Any change in text field will be handled by this part
   
    // To swipe from left to right
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.left:
                
                //change view controllers
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HistoryTable") as! HistoryTable
                
                resultViewController.modalTransitionStyle = .flipHorizontal
                resultViewController.delegate = self
                
                self.present(resultViewController, animated: true, completion: nil)
                
            default:
                break
            }
        }
    }
    
    // TODO: To change VC using button
    
    @IBAction func historyButton(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HistoryTable") as! HistoryTable
        
        resultViewController.modalTransitionStyle = .flipHorizontal
        resultViewController.delegate = self
        
        self.present(resultViewController, animated: true, completion: nil)
        
    }
    
    
    // Helper for editing text
    func helperForEdit(_ x: Int,_ y: Int,_ sender: UITextField) {
        matrixCells[x-1][y-1].initialize()
        sender.text = ""
    }
    
    // When you enter value, you should not see anything
    @IBAction func editEntry11(_ sender: UITextField) {
        helperForEdit(1, 1, sender)
    }
    
    @IBAction func editEntry12(_ sender: UITextField) {
        helperForEdit(1, 2, sender)
    }
    
    @IBAction func editEntry13(_ sender: UITextField) {
        helperForEdit(1, 3, sender)
    }
    
    @IBAction func editEntry14(_ sender: UITextField) {
        helperForEdit(1, 4, sender)
    }
    
    @IBAction func editEntry21(_ sender: UITextField) {
        helperForEdit(2, 1, sender)
    }
    
    @IBAction func editEntry22(_ sender: UITextField) {
        helperForEdit(2, 2, sender)
    }
    
    @IBAction func editEntry23(_ sender: UITextField) {
        helperForEdit(2, 3, sender)
    }
    
    @IBAction func editEntry24(_ sender: UITextField) {
        helperForEdit(2, 4, sender)
    }
    
    
    @IBAction func editEntry31(_ sender: UITextField) {
        helperForEdit(3, 1, sender)
    }
    
    @IBAction func editEntry32(_ sender: UITextField) {
        helperForEdit(3, 2, sender)
    }
    
    @IBAction func editEntry33(_ sender: UITextField) {
        helperForEdit(3, 3, sender)
    }
    
    @IBAction func editEntry34(_ sender: UITextField) {
        helperForEdit(3, 4, sender)
    }
    
    @IBAction func editEntry41(_ sender: UITextField) {
        helperForEdit(4, 1, sender)
    }
    
    @IBAction func editEntry42(_ sender: UITextField) {
        helperForEdit(4, 2, sender)
    }
    
    @IBAction func editEntry43(_ sender: UITextField) {
        helperForEdit(4, 3, sender)
    }
    
    @IBAction func editEntry44(_ sender: UITextField) {
        helperForEdit(4, 4, sender)
    }
    
    
    
    
    // Helper: I should have do this using loop but I don't know how.
    // This helper is uncessary
    func helperForTouch(_ x: Int,_ y: Int, _ message: String) {
        if (message != "") {
            matrixCells[x-1][y-1].entryInput(message)
            
            var maxx = x, maxy = y
            for i in 0...3 {
                for j in 0...3 {
                    if (matrixCells[i][j].userInput) {
                        if (maxx <= i) {
                            maxx = i + 1
                        }
                        if (maxy <= j) {
                            maxy = j + 1
                        }
                    }
                }
            }
            
            for i in matrixCells {
                for j in i {
                    j.updateHighlight(maxx, maxy)
                    j.cancelHighlight(maxx, maxy)
                    j.updateAfterTouched()
                }
            }
            print("\(maxx), \(maxy)")
        } else {
            matrixCells[x-1][y-1].deleteInput()
            var maxx = 1, maxy = 1
            for i in 0...3 {
                for j in 0...3 {
                    if (matrixCells[i][j].userInput) {
                        if (maxx <= i) {
                            maxx = i + 1
                        }
                        if (maxy <= j) {
                            maxy = j + 1
                        }
                    }
                }
            }
            
            for i in matrixCells {
                for j in i {
                    j.updateHighlight(maxx, maxy)
                    j.cancelHighlight(maxx, maxy)
                    j.updateAfterTouched()
                }
            }
        }
    }
    
    // While you finishing editing text field
    // This is very bad format, I will fix this one day
    @IBAction func touchEntry11(_ sender: UITextField) {
        helperForTouch(1, 1, sender.text!)
    }
    
    @IBAction func touchEntry12(_ sender: UITextField) {
        helperForTouch(1, 2, sender.text!)
    }
    
    @IBAction func touchEntry13(_ sender: UITextField) {
        helperForTouch(1, 3, sender.text!)
    }
    
    @IBAction func touchEntry14(_ sender: UITextField) {
        helperForTouch(1, 4, sender.text!)
    }
    
    @IBAction func touchEntry21(_ sender: UITextField) {
        helperForTouch(2, 1, sender.text!)
    }
    
    @IBAction func touchEntry22(_ sender: UITextField) {
        helperForTouch(2, 2, sender.text!)
    }
    
    @IBAction func touchEntry23(_ sender: UITextField) {
        helperForTouch(2, 3, sender.text!)
    }
    
    @IBAction func toouchEntry24(_ sender: UITextField) {
        helperForTouch(2, 4, sender.text!)
    }
    
    @IBAction func touchEntry31(_ sender: UITextField) {
        helperForTouch(3, 1, sender.text!)
    }
    
    @IBAction func touchEntry32(_ sender: UITextField) {
        helperForTouch(3, 2, sender.text!)
    }
    
    @IBAction func touchEntry33(_ sender: UITextField) {
        helperForTouch(3, 3, sender.text!)
    }
    
    @IBAction func touchEntry34(_ sender: UITextField) {
        helperForTouch(3, 4, sender.text!)
    }
    
    @IBAction func touchEntry41(_ sender: UITextField) {
        helperForTouch(4, 1, sender.text!)
    }
    
    @IBAction func touchEntry42(_ sender: UITextField) {
        helperForTouch(4, 2, sender.text!)
    }
    
    @IBAction func touchEntry43(_ sender: UITextField) {
        helperForTouch(4, 3, sender.text!)
    }
    
    @IBAction func touchEntry44(_ sender: UITextField) {
        helperForTouch(4, 4, sender.text!)
    }
    
    // Calculate Area: all buttons and calculation belong here
    
    @IBAction func touchClearButton(_ sender: UIButton) {
        for i in matrixCells {
            for j in i {
                j.initialize()
            }
        }
    }
    
    
    
}

extension ViewController: DataPassingDelegate {
    func updateCurentMatrix(newMatrix: [[Double]]) {
        for i in matrixCells {
            for j in i {
                j.initialize()
            }
        }
        
        for i in 0..<newMatrix.count {
            
            for j in 0..<newMatrix[0].count {
                
                matrixCells[i][j].value = Double(avoidRoundingError(x: newMatrix[i][j], precise: 2)) / 100
                matrixCells[i][j].userInput = true
                matrixCells[i][j].needHelight = true
                matrixCells[i][j].updateAfterTouched()
                
            }
            
        }
        
    }
}

