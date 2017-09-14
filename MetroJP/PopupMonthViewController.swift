//
//  PopupMonthViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/7/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class PopupMonthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var naviBar: UINavigationBar!
    var listRecord = Array<DateSection>()
    @IBOutlet weak var tablePopup: UITableView!
    var delegate: ChangeMonthDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_keyboard_arrow_left_white_48pt")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backClick))
        naviBar.topItem?.leftBarButtonItem = leftButton
        
        naviBar.topItem?.title = "清算月選択"
        tablePopup.dataSource = self
        tablePopup.delegate = self
        // Do any additional setup after loading the view.
    }

    func backClick() {
        self.view.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnCloseClick(_ sender: Any) {
        delegate?.changeMonth(month: "12")
        self.view.removeFromSuperview()
    }

    func numberOfSections(in tableView: UITableView) -> Int{
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MonthTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MonthTableViewCell
        cell.lbMonth.text = listRecord[indexPath.section].list[indexPath.row]?.date
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            delegate?.changeMonth(month: listRecord[indexPath.row].month)
         self.view.removeFromSuperview()

    }
}
