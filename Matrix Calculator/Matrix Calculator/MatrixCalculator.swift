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
    var secondMatrixCells: [[myCellType]] = [[], [], [], []]
    var history: [myCalculationResult] = []
    
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
    
    // for second matrix
    // Row 1:
    @IBOutlet weak var secondEntry11: UITextField!
    @IBOutlet weak var secondEntry12: UITextField!
    @IBOutlet weak var secondEntry13: UITextField!
    @IBOutlet weak var secondEntry14: UITextField!
    // Row 2:
    @IBOutlet weak var secondEntry21: UITextField!
    @IBOutlet weak var secondEntry22: UITextField!
    @IBOutlet weak var secondEntry23: UITextField!
    @IBOutlet weak var secondEntry24: UITextField!
    // Row 3:
    @IBOutlet weak var secondEntry31: UITextField!
    @IBOutlet weak var secondEntry32: UITextField!
    @IBOutlet weak var secondEntry33: UITextField!
    @IBOutlet weak var secondEntry34: UITextField!
    // Row 4:
    @IBOutlet weak var secondEntry41: UITextField!
    @IBOutlet weak var secondEntry42: UITextField!
    @IBOutlet weak var secondEntry43: UITextField!
    @IBOutlet weak var secondEntry44: UITextField!
    
    // Power Text Button
    @IBOutlet weak var powerText: UITextField!
    
    
    // Single Matrix Buttons:
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var powerButton: UIButton!
    @IBOutlet weak var inverseButton: UIButton!
    @IBOutlet weak var nullSpaceButton: UIButton!
    @IBOutlet weak var eigenVectorButton: UIButton!
    @IBOutlet weak var eigenValuebutton: UIButton!
    @IBOutlet weak var colSpaceButton: UIButton!
    @IBOutlet weak var transposeButton: UIButton!
    
    // Double Matrix Button
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var multipleButton: UIButton!
    @IBOutlet weak var clearLeftButton: UIButton!
    @IBOutlet weak var doubleHistoryButton: UIButton!
    @IBOutlet weak var clearRightButton: UIButton!
    @IBOutlet weak var exchangeButton: UIButton!
    
    
    // MARK: for debugging use
    func createTestArray() {
        let test0 = myCalculationResult([[0, 0], [0, 6], [4, 0]], myOperations.multiplication, 0, [[1, 2, 3], [3, 0, 9]])
        let test1 = myCalculationResult([[1, 1, 3, 4],
                                         [3, 4, 2, 5],
                                         [3, 3, 3, 6],
                                         [4, 6, 3, 2]], myOperations.inverse)
        let test2 = myCalculationResult([[-1, 2, 3], [2, 4, 2], [1, 3, 5]], myOperations.diagonal)
        let test3 = myCalculationResult([[-1, 2, 3], [2, 4, 2], [1, 3, 5]], myOperations.eigenvalue)
        let test4 = myCalculationResult([[2, 1, 1, 4],
                                         [1, 3, 1, 3],
                                         [0, 5, 1, 2],
                                         [2.5, 3, 1.5, 4]], myOperations.transpose)
        let test5 = myCalculationResult([[3, 2, -1, 1],
                                         [1, 1, 0, 3],
                                         [2, 3, -4, -7],
                                         [3, -4, 3, -9]], myOperations.transpose)
        let test6 = myCalculationResult([[2, 1.3, 1, 4],
                                         [1.3, 3, 4.23, 0.34],
                                         [0.2, 32, 12.3, 23.4]], myOperations.RREF)
        let test7 = myCalculationResult([[3, 2, -1, 1]], myOperations.transpose)
        let test8 = myCalculationResult([[3],
                                         [1],
                                         [2],
                                         [3]], myOperations.transpose)
        let test9 = myCalculationResult([[0, 0, 0],
                                         [0, 0, 6],
                                         [0, 6, 0]], myOperations.power, 2)
        let test10 = myCalculationResult([[1, 2, 3, 4],
                                          [1, 2, 3, 4],
                                          [1, 2, 3, 4],
                                          [1, 2, 3, 4]], myOperations.transpose)
        let test11 = myCalculationResult([[1, 2, 3, 4],
                                          [1, 2, 3, 4],
                                          [1, 2, 3, 4],
                                          [1, 2, 3, 4]], myOperations.determinate)
        let test12 = myCalculationResult([[1, 2, 3, 4],
                                          [1, 2, 3, 4],
                                          [1, 2, 3, 4],
                                          [1, 2, 3, 4]], myOperations.addition, 0, [[1, 2, 3, 4],
                                                                                    [1, 2, 3, 4],
                                                                                    [1, 2, 3, 4],
                                                                                    [1, 2, 3, 4]])
        let test13 = myCalculationResult([[1, 2, 3, 4],
                                          [1, 2, 3, 4]
                                          ], myOperations.substraction, 0, [[1, 2, 3, 4],
                                                                                    [1, 2, 3, 4]])

        history.append(test0)
        history.append(test1)
        history.append(test2)
        history.append(test3)
        history.append(test4)
        history.append(test5)
        history.append(test6)
        history.append(test7)
        history.append(test8)
        history.append(test9)
        history.append(test10)
        history.append(test11)
        history.append(test12)
        history.append(test13)
    }
    
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
        
        // initialization for second matrix
        secondMatrixCells[0].append(myCellType(1, 1, secondEntry11))
        secondMatrixCells[0].append(myCellType(1, 2, secondEntry12))
        secondMatrixCells[0].append(myCellType(1, 3, secondEntry13))
        secondMatrixCells[0].append(myCellType(1, 4, secondEntry14))
        secondMatrixCells[1].append(myCellType(2, 1, secondEntry21))
        secondMatrixCells[1].append(myCellType(2, 2, secondEntry22))
        secondMatrixCells[1].append(myCellType(2, 3, secondEntry23))
        secondMatrixCells[1].append(myCellType(2, 4, secondEntry24))
        secondMatrixCells[2].append(myCellType(3, 1, secondEntry31))
        secondMatrixCells[2].append(myCellType(3, 2, secondEntry32))
        secondMatrixCells[2].append(myCellType(3, 3, secondEntry33))
        secondMatrixCells[2].append(myCellType(3, 4, secondEntry34))
        secondMatrixCells[3].append(myCellType(4, 1, secondEntry41))
        secondMatrixCells[3].append(myCellType(4, 2, secondEntry42))
        secondMatrixCells[3].append(myCellType(4, 3, secondEntry43))
        secondMatrixCells[3].append(myCellType(4, 4, secondEntry44))
        
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
        plusButton.layer.cornerRadius = 5
        minusButton.layer.cornerRadius = 5
        multipleButton.layer.cornerRadius = 5
        clearLeftButton.layer.cornerRadius = 5
        clearRightButton.layer.cornerRadius = 5
        doubleHistoryButton.layer.cornerRadius = 5
        exchangeButton.layer.cornerRadius = 5
        
        super.viewDidLoad()
        
        // For debugging
        createTestArray()
        
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
                secondMatrixCells[i][j].pointer.inputAccessoryView = toolBar
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
        
        for i in secondMatrixCells {
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
        // Bool is true if and only if responser is Main Matrix
        var currentResponser: (Int, Int, Bool?) = (1, 1, nil)
        
        
        for i in matrixCells {
            for j in i {
                if (j.pointer.isEditing) {
                    currentResponser = (j.row, j.col, true)
                }
            }
        }
        
        for i in secondMatrixCells {
            for j in i {
                if (j.pointer.isEditing) {
                    currentResponser = (j.row, j.col, false)
                }
            }
        }
        
        if (currentResponser.2)! {
            if (currentResponser.1 != 4) {
                matrixCells[currentResponser.0 - 1][currentResponser.1].pointer.becomeFirstResponder()
            } else if (currentResponser.0 != 4) {
                matrixCells[currentResponser.0][0].pointer.becomeFirstResponder()
            } else {
                matrixCells[0][0].pointer.becomeFirstResponder()
            }
        } else {
            if (currentResponser.1 != 4) {
                secondMatrixCells[currentResponser.0 - 1][currentResponser.1].pointer.becomeFirstResponder()
            } else if (currentResponser.0 != 4) {
                secondMatrixCells[currentResponser.0][0].pointer.becomeFirstResponder()
            } else {
                secondMatrixCells[0][0].pointer.becomeFirstResponder()
            }
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
   
    func showHistoryVC() {
        //change view controllers
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HistoryTable") as! HistoryTable
        
        // passing history table
        resultViewController.history = history
        
        resultViewController.modalTransitionStyle = .flipHorizontal
        resultViewController.delegate = self
        
        self.present(resultViewController, animated: true, completion: nil)
    }
    
    // To swipe from left to right
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.left:
                
                showHistoryVC()
                
            default:
                break
            }
        }
    }
    
    // MARK: To change VC using button
    
    @IBAction func historyButton(_ sender: UIButton) {
        
        showHistoryVC()
        
    }
    
    // Helper for editing text
    func helperForEdit(_ x: Int,_ y: Int,_ sender: UITextField) {
        
        if (containedInArray(sender, matrixCells)) {
            matrixCells[x-1][y-1].initialize()
        } else {
            secondMatrixCells[x-1][y-1].initialize()
        }
        sender.text = ""
    }
    
    func containedInArray(_ sender: UITextField,_ doubleArray: [[myCellType]]) -> Bool {
        for i in doubleArray {
            for j in i {
                if (sender == j.pointer) {
                    return true
                }
            }
        }
        return false
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
    func helperForTouch(_ x: Int,_ y: Int, _ sender: UITextField) {
        
        if (containedInArray(sender, matrixCells)) {
            secondhelperForTouch(x, y, sender.text!, matrixCells: matrixCells)
        } else {
            secondhelperForTouch(x, y, sender.text!, matrixCells: secondMatrixCells)
        }
        
    }
    
    func secondhelperForTouch(_ x: Int,_ y: Int, _ message: String, matrixCells: [[myCellType]]) {
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
        helperForTouch(1, 1, sender)
    }
    
    @IBAction func touchEntry12(_ sender: UITextField) {
        helperForTouch(1, 2, sender)
    }
    
    @IBAction func touchEntry13(_ sender: UITextField) {
        helperForTouch(1, 3, sender)
    }
    
    @IBAction func touchEntry14(_ sender: UITextField) {
        helperForTouch(1, 4, sender)
    }
    
    @IBAction func touchEntry21(_ sender: UITextField) {
        helperForTouch(2, 1, sender)
    }
    
    @IBAction func touchEntry22(_ sender: UITextField) {
        helperForTouch(2, 2, sender)
    }
    
    @IBAction func touchEntry23(_ sender: UITextField) {
        helperForTouch(2, 3, sender)
    }
    
    @IBAction func toouchEntry24(_ sender: UITextField) {
        helperForTouch(2, 4, sender)
    }
    
    @IBAction func touchEntry31(_ sender: UITextField) {
        helperForTouch(3, 1, sender)
    }
    
    @IBAction func touchEntry32(_ sender: UITextField) {
        helperForTouch(3, 2, sender)
    }
    
    @IBAction func touchEntry33(_ sender: UITextField) {
        helperForTouch(3, 3, sender)
    }
    
    @IBAction func touchEntry34(_ sender: UITextField) {
        helperForTouch(3, 4, sender)
    }
    
    @IBAction func touchEntry41(_ sender: UITextField) {
        helperForTouch(4, 1, sender)
    }
    
    @IBAction func touchEntry42(_ sender: UITextField) {
        helperForTouch(4, 2, sender)
    }
    
    @IBAction func touchEntry43(_ sender: UITextField) {
        helperForTouch(4, 3, sender)
    }
    
    @IBAction func touchEntry44(_ sender: UITextField) {
        helperForTouch(4, 4, sender)
    }
    
    // MARK: Calculate Area: all buttons and calculation belong here
    
    @IBAction func touchClearButton(_ sender: UIButton) {
        for i in matrixCells {
            for j in i {
                j.initialize()
            }
        }
    }
    
    @IBAction func clearRightButton(_ sender: Any) {
        for i in secondMatrixCells {
            for j in i {
                j.initialize()
            }
        }
    }
    
    func convertInputIntoMatrix(myCells: [[myCellType]]) -> [[Double]] {
        
        var col = 0
        var row = 0
        
        for i in 0...3 {
            for j in 0...3 {
                if (myCells[i][j].needHelight) {
                    col = max(col, i)
                    row = max(row, j)
                }
            }
        }
        
        var newMatrix: [[Double]] = []
        for i in 0...col {
            var tmp: [Double] = []
            for j in 0...row {
                tmp.append(myCells[i][j].value)
            }
            newMatrix.append(tmp)
        }
        
        return newMatrix
    }
    
    @IBAction func touchOperator(_ sender: UIButton) {
        
        var currentMatrix = convertInputIntoMatrix(myCells: matrixCells)
        var secondaryMatrix = convertInputIntoMatrix(myCells: secondMatrixCells)
        
        // different cases:
        switch sender.tag {
        case 1:
            if (currentMatrix.count != currentMatrix[0].count) {
                showAlert("Incorrect Matrix", "Only square matrices are invertible.")
            } else {
                history.insert(myCalculationResult(currentMatrix, myOperations.inverse), at: 0)
                showHistoryVC()
            }
            print("inverse\n")
        case 2:
            if (currentMatrix.count != currentMatrix[0].count) {
                showAlert("Incorrect Input", "Only square matrices can multiplied by itself.")
            } else if (powerText.text == "") {
                showAlert("Missing Input", "Please type in the power.")
            } else if (powerText.text == "0") {
                showAlert("Incorrect Input", "Power must be non-zero.")
            } else {
                history.insert(myCalculationResult(currentMatrix, myOperations.power, Int(powerText.text!)!), at: 0)
                showHistoryVC()
            }
            print("power")
        case 3:
            if (currentMatrix.count != currentMatrix[0].count) {
                showAlert("Incorrect Input", "Only square matrices have determinant.")
            } else {
                history.insert(myCalculationResult(currentMatrix, myOperations.determinate), at: 0)
                showHistoryVC()
            }
            print("determinant")
        case 4:
            if (currentMatrix.count != currentMatrix[0].count) {
                showAlert("Incorrect Input", "Only square matrices can be diagonalized.")
            } else {
                history.insert(myCalculationResult(currentMatrix, myOperations.diagonal), at: 0)
                showHistoryVC()
            }
            print("duagonal")
        case 5:
            history.insert(myCalculationResult(currentMatrix, myOperations.RREF), at: 0)
            showHistoryVC()
            print("rref")
        case 6:
            if (currentMatrix.count != currentMatrix[0].count) {
                showAlert("Incorrect Input", "Only square matrices have eigenvalues.")
            } else {
                history.insert(myCalculationResult(currentMatrix, myOperations.eigenvalue), at: 0)
                showHistoryVC()
            }
            print("eigencalue")
        case 7:
            history.insert(myCalculationResult(currentMatrix, myOperations.transpose), at: 0)
            showHistoryVC()
            print("transpose")
        case 8:
            if (currentMatrix.count != secondaryMatrix.count || currentMatrix[0].count != secondaryMatrix[0].count) {
                showAlert("Incorrect Input", "Two matrices should have same size.")
            } else {
                history.insert(myCalculationResult(currentMatrix, myOperations.addition, 0, secondaryMatrix), at: 0)
                showHistoryVC()
            }
            print("plus")
        case 9:
            if (currentMatrix.count != secondaryMatrix.count || currentMatrix[0].count != secondaryMatrix[0].count) {
                showAlert("Incorrect Input", "Two matrices should have same size.")
            } else {
                history.insert(myCalculationResult(currentMatrix, myOperations.substraction, 0, secondaryMatrix), at: 0)
                showHistoryVC()
            }
            print("minus")
        case 10:
            if (currentMatrix[0].count != secondaryMatrix.count) {
                showAlert("Incorrect Input", "Columns of left matrix should equals rows of right matrix.")
            } else {
                history.insert(myCalculationResult(currentMatrix, myOperations.multiplication, 0, secondaryMatrix), at: 0)
                showHistoryVC()
            }
            print("multiplication")
        default:
            print("error")
        }
        
        
    }
    
    func showAlert(_ title: String, _ message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func exchangeMatrix(_ sender: UIButton) {
        
        for i in 0...3 {
            for j in 0...3 {
                let bckupVal = matrixCells[i][j].value
                let bckupHighlight = matrixCells[i][j].needHelight
                let bckupUserInput = matrixCells[i][j].userInput
                matrixCells[i][j].value = secondMatrixCells[i][j].value
                matrixCells[i][j].needHelight = secondMatrixCells[i][j].needHelight
                matrixCells[i][j].userInput = secondMatrixCells[i][j].userInput
                secondMatrixCells[i][j].value = bckupVal
                secondMatrixCells[i][j].needHelight = bckupHighlight
                secondMatrixCells[i][j].userInput = bckupUserInput
                matrixCells[i][j].updateAfterTouched()
                secondMatrixCells[i][j].updateAfterTouched()
            }
        }
        
        
    }
    
    
    
    
    
}

extension ViewController: DataPassingDelegate {
    func updateHistory(newHistory: [myCalculationResult]) {
        history = newHistory
    }
    
    
    func updateCurentMatrix(newMatrix: [[Double]]) {
        for i in matrixCells {
            for j in i {
                j.initialize()
            }
        }
        
        for i in 0..<newMatrix.count {
            
            for j in 0..<newMatrix[0].count {
                
                matrixCells[i][j].value = newMatrix[i][j]
//                    Double(avoidRoundingError(x: newMatrix[i][j], precise: 2)) / 100
                matrixCells[i][j].userInput = true
                matrixCells[i][j].needHelight = true
                matrixCells[i][j].updateAfterTouched()
                
            }
            
        }
        
    }
    
    func updateSeconderyMatrix(newMatrix: [[Double]]) {
        
        for i in secondMatrixCells {
            for j in i {
                j.initialize()
            }
        }
        
        for i in 0..<newMatrix.count {
            
            for j in 0..<newMatrix[0].count {
                
                secondMatrixCells[i][j].value = newMatrix[i][j]
//                    Double(avoidRoundingError(x: newMatrix[i][j], precise: 2)) / 100
                secondMatrixCells[i][j].userInput = true
                secondMatrixCells[i][j].needHelight = true
                secondMatrixCells[i][j].updateAfterTouched()
                
            }
            
        }
    }
}

