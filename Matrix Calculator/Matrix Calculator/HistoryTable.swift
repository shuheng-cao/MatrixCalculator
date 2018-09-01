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
    var isPortrait: Bool = true

    @IBOutlet weak var tableView: UITableView!
    
    // go back using button
    @IBAction func dismissTableView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBOutlet weak var tmp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // go back using swipe
        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()

        switch UIDevice.current.orientation {
        case .unknown:
            tmp.text = "My History"
            isPortrait = true
        case .portrait:
            tmp.text = "My History"
            isPortrait = true
        case .portraitUpsideDown:
            tmp.text = "My History"
            isPortrait = true
        case .landscapeLeft:
            tmp.text = "Detailed History"
            isPortrait = false
        case .landscapeRight:
            tmp.text = "Detailed History"
            isPortrait = false
        case .faceUp:
            tmp.text = "My History"
            isPortrait = true
        case .faceDown:
            tmp.text = "My History"
            isPortrait = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        self.tableView.reloadData()
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
    
}

extension HistoryTable: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let result = history[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
//        cell.enableButton()
        cell.setHistoryCell(myResult: result, isPortrait)
        cell.delegate = self
        
        return cell
    }
    
}

extension HistoryTable: DataPassingDelegate {
    
    func updateCurentMatrix(newMatrix: [[Double]]) {
        delegate?.updateCurentMatrix(newMatrix: newMatrix)
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSeconderyMatrix(newMatrix: [[Double]]) {
        delegate?.updateSeconderyMatrix(newMatrix: newMatrix)
        self.dismiss(animated: true, completion: nil)
    }
    
}


