////
////  HistoryTable.swift
////  Matrix!
////
////  Created by shuster on 2018/8/9.
////  Copyright © 2018 曹书恒. All rights reserved.
////
//
import UIKit

class HistoryTable: UIViewController {
    
    var history: [myCalculationResult] = []
    var delegate: DataPassingDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func dismissTableView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTestArray()
        
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                
                
                
                self.dismiss(animated: true, completion: nil)
                
            default:
                break
            }
        }
    }
    
    
    
    
    func createTestArray() {
        let test1 = myCalculationResult([[1, 2.499999999], [3.2, 4]], myOperations.inverse)
        let test2 = myCalculationResult([[2, 3], [4.239995, 5], [6, 7.999999]], myOperations.diagonal)
        let test3 = myCalculationResult([[-1, 2, 3, 4.234], [1.128, 2, 3, -4], [1, 222, 3, 4], [1, 2, 3, 4.22]], myOperations.eigenvalue)
        let test4 = myCalculationResult([[2, 1, 1, 4],
                                         [1, 3, 1, 3],
                                         [0, 5, 1, 2],
                                         [2.5, 3, 1.5, 4]], myOperations.RREF)
        let test5 = myCalculationResult([[3, 2, -1, 1],
                                         [1, 1, 0, 3],
                                         [2, 3, -4, -7],
                                         [3, -4, 3, -9]], myOperations.RREF)
        let test6 = myCalculationResult([[2, 1.3, 1, 4],
                                         [1.3, 3, 4.23, 0.34],
                                         [0.2, 32, 12.3, 23.4]], myOperations.RREF)
        
        history.append(test1)
        history.append(test2)
        history.append(test3)
        history.append(test4)
        history.append(test5)
        history.append(test6)
    }
    
}

extension HistoryTable: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let result = history[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
        cell.setHistoryCell(myResult: result)
        cell.delegate = self
        
        return cell
    }
    
}

extension HistoryTable: DataPassingDelegate {
    func updateCurentMatrix(newMatrix: [[Double]]) {
        delegate?.updateCurentMatrix(newMatrix: newMatrix)
        self.dismiss(animated: true, completion: nil)
    }
}


