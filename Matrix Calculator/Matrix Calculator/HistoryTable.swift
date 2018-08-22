////
////  HistoryTable.swift
////  Matrix!
////
////  Created by shuster on 2018/8/9.
////  Copyright © 2018 曹书恒. All rights reserved.
////
//
//import UIKit
//import Foundation
//
//class HistoryTable: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//
//    @IBOutlet weak var historyTableView: UITableView!
//
//    var matrixCalculationHistory: [myCalculationResult] = []
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        createTestArray()
//        // Do any additional setup after loading the view.
//    }
//

//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(matrixCalculationHistory.count)
//        return matrixCalculationHistory.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: TableViewCell = historyTableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
//        print("ip: \(indexPath.row)")
//        cell.setHistoryCell(myResult: matrixCalculationHistory[indexPath.row])
//
//        return cell
//    }
//
//}

import UIKit

class HistoryTable: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    var history: [myCalculationResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTestArray()
        
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func createTestArray() {
        let test1 = myCalculationResult([[1, 2], [3, 4]], myOperations.inverse)
        let test2 = myCalculationResult([[2, 3], [4, 5], [6, 7]], myOperations.diagonal)
        let test3 = myCalculationResult([[1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4]], myOperations.eigenvalue)
        
        history.append(test1)
        history.append(test2)
        history.append(test3)
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
        
        return cell
    }
    
}


