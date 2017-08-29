//
//  CalendarController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/21/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import JTAppleCalendar

var type: Int!
class CalendarController: UIViewController {
    let formatter = DateFormatter()
    var prePostVisibility: ((CellState, CustomCell?)->())?
    let red = UIColor.red
    let white = UIColor.white
    let black = UIColor.black
    let gray = UIColor.gray
    let shade = UIColor(colorWithHexValue: 0x4E4E4E)
    var currentMonth = 7, currentYear = 2017
    
    
    var tableProtocol: DateSelectedProtocol?
    var selectedDate: String = ""
    var data: String!
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("data=" + data)
        self.calendarView.isScrollEnabled = false
//        self.calendarView.scrollToDate(Date())
//        changeMonth(month: currentMonth, year: currentYear)
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }

    }
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var lbMonthYear: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var lbMonth: UILabel!
    @IBOutlet weak var lbDayOfWeek: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     Change calendar to a month-year
     **/
    func changeMonth(month: Int, year: Int) {
        var dateComponent = DateComponents()
        dateComponent.year = year
        dateComponent.month = month
        dateComponent.day = 1
        let date = Calendar.current.date(from: dateComponent)!
        self.calendarView.scrollToDate(date)
        
    }
    
    @IBAction func btnNextClick(_ sender: Any) {
        if (currentMonth == 12) {
            currentMonth = 1
            currentYear = currentYear + 1
        } else {
            currentMonth = currentMonth + 1
        }
//        changeMonth(month: currentMonth, year: currentYear)
        self.calendarView.scrollToSegment(.next)
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
        self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    @IBAction func btnPreviousClick(_ sender: Any) {
        if (currentMonth == 1) {
            currentMonth = 12
            currentYear = currentYear - 1
        } else {
            currentMonth = currentMonth - 1
        }
//        changeMonth(month: currentMonth, year: currentYear)
        self.calendarView.scrollToSegment(.previous)
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
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

        if cellState.isSelected {
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }

    
    @IBAction func goBackList(_ sender: Any) {
        
        let scr = storyboard?.instantiateViewController(withIdentifier: "StationViewController") as! StationViewController
//        let scr = storyboard?.instantiateViewController(withIdentifier: "Main") as! MainController
        scr.getDateSelected(date: selectedDate, id: type)
        present(scr, animated: true, completion: nil)
    }
    
    
}

extension CalendarController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2050 12 31")!
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
        handleCellConfiguration(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
  
        selectedDate = formatter.string(from: date) //pass Date here
//        print(newDate) //New formatted Date string
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = Calendar.current.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = Calendar.current.component(.year, from: startDate)
         let date = Calendar.current.component(.day, from: startDate)
        lbMonth.text = String(date) + " " + monthName + " " + String(year)

        self.currentMonth = month
        self.currentYear = year
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
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

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}



