//
//  FoldingCellTableController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/21/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import  FoldingCell

class FoldingCellTableController: UITableViewController {
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    
    @IBOutlet var foldingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let nib = UINib(nibName: "FoldingCustomView", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "CustomFoldingCell")
        
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        foldingTableView.estimatedRowHeight = kCloseCellHeight
        foldingTableView.rowHeight = UITableViewAutomaticDimension
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("1")
        return 10
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as CustomFoldingCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
//        if cellHeights[indexPath.row] == kCloseCellHeight {
//            cell.selectedAnimation(false, animated: false, completion:nil)
//        } else {
//            cell.selectedAnimation(true, animated: false, completion: nil)
//        }
        
        cell.number = indexPath.row
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("3")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomFoldingCell")
        print("31")
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
//        cell.durationsForExpandedState = durations
//        cell.durationsForCollapsedState = durations
        return cell!
    }
    
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("4")

        return cellHeights[indexPath.row]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        print("5")

        return cellHeights[indexPath.row]
    }
    
//     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
//        
//        if cell.isAnimating() {
//            return
//        }
//        
//        var duration = 0.0
//        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
//        if cellIsCollapsed {
//            cellHeights[indexPath.row] = kOpenCellHeight
//            cell.unfold(true, animated: true, completion: nil)
//
//            duration = 0.5
//        } else {
//            cellHeights[indexPath.row] = kCloseCellHeight
//            cell.unfold(false, animated: true, completion: nil)
//
//            duration = 0.8
//        }
//        
//        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
//            tableView.beginUpdates()
//            tableView.endUpdates()
//        }, completion: nil)
//        
//    }
    
    func animationDuration(itemIndex:NSInteger, type:CAAnimation)-> TimeInterval {
        
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }
}
