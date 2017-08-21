//
//  CalendarController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/21/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarController: UIViewController {
    let formatter = DateFormatter()
    var prePostVisibility: ((CellState, CustomCell?)->())?
    let red = UIColor.red
    let white = UIColor.white
    let black = UIColor.black
    let gray = UIColor.gray
    let shade = UIColor(colorWithHexValue: 0x4E4E4E)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        prePostVisibility?(cellState, cell as? CustomCell)
    }
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CustomCell  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dateLabel.textColor = white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dateLabel.textColor = black
                myCustomCell.isUserInteractionEnabled = true
            } else {
                myCustomCell.dateLabel.textColor = gray
                myCustomCell.isUserInteractionEnabled = false
            }
        }
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CustomCell else {return }
        //        switch cellState.selectedPosition() {
        //        case .full:
        //            myCustomCell.backgroundColor = .green
        //        case .left:
        //            myCustomCell.backgroundColor = .yellow
        //        case .right:
        //            myCustomCell.backgroundColor = .red
        //        case .middle:
        //            myCustomCell.backgroundColor = .blue
        //        case .none:
        //            myCustomCell.backgroundColor = nil
        //        }
        //
        if cellState.isSelected {
//            myCustomCell.dateLabel.layer.cornerRadius =  30
//            myCustomCell.dateLabel.layer.masksToBounds = true
//            myCustomCell.dateLabel.layer.backgroundColor = UIColor.yellow.cgColor
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }

    
    @IBAction func goBackList(_ sender: Any) {
//        let mainContronller = self.storyboard?.instantiateViewControllerWithIdentifier("Main") as! MainController
//        
//        // Set "Hello World" as a value to myStringValue
//        mainContronller.myStringValue = myTextField.text
//        
//        // Take user to SecondViewController
//        self.navigationController?.pushViewController(secondViewController, animated: true)
        let scr = storyboard?.instantiateViewController(withIdentifier: "Main") as! MainController
        present(scr, animated: true, completion: nil)
        }
}

extension CalendarController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        let parameter = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameter
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        if (cellState.isSelected) {
            cell.selectedView.isHidden = true
        } else {
            cell.selectedView.isHidden = false
        }
//        cell.selectedView.isHidden = true
        handleCellConfiguration(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        guard let validCell = cell as? CustomCell else {return}
//        validCell.selectedView.isHidden = false
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        guard let validCell = cell as? CustomCell else {return}
//        validCell.selectedView.isHidden = true
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

