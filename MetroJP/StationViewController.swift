//
//  StationViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/29/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class StationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DateSelectedProtocol {
    var listStations: Array<Station> = []

    @IBAction func saveStationRecord(_ sender: Any) {
    }
    @IBOutlet weak var tfNote: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var tfFrom: UITextField!
    @IBOutlet weak var tfTarget: UITableView!
    @IBOutlet weak var tfDate: UITableView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var tableStation: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tfTo: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
        
        navigationBar.topItem?.title = "外出先編集"
        navigationBar.backItem?.title = "Back"
        
        tfFrom.delegate = self
        tfTo.delegate = self
        
        let nib = UINib(nibName: "TrafficItemView", bundle: nil)
        tableStation.register(nib, forCellReuseIdentifier: "TrafficItemView")

        
        tableStation.dataSource = self
        tableStation.delegate = self


    }
    
    @IBAction func saveDataClick(_ sender: Any) {
        print("aaa+"+tfNote.text!)
    }

    func initData() {
        let station1 = Station(id: 1, name: "JR", select: false)
        let station2 = Station(id: 1, name: "地下鉄", select: false)
        let station3 = Station(id: 1, name: "私鉄", select: false)
        let station4 = Station(id: 1, name: "高速", select: false)
        listStations.append(station1)
        listStations.append(station2)
        listStations.append(station3)
        listStations.append(station4)
        listStations.append(station1)
        listStations.append(station1)
        listStations.append(station2)
        listStations.append(station3)
        listStations.append(station4)
        listStations.append(station1)
        listStations.append(station2)
        listStations.append(station3)
        listStations.append(station4)
        listStations.append(station1)
        listStations.append(station2)
        listStations.append(station3)
        listStations.append(station4)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrafficItemView") as! TrafficItemView
        cell.lbStation.text = "label " + String(indexPath.row)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select="+String(indexPath.row))
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == tfFrom) {
            print("aaa+"+lbDate.text!)
            type = Constant().TYPE_FROM
            let scr = storyboard?.instantiateViewController(withIdentifier: "calendarCollection") as! CalendarController
            scr.tableProtocol = self
            type = Constant().TYPE_FROM
            scr.data = "1"
            self.navigationController?.pushViewController(scr, animated: true)
        }
        else if (textField == tfTo) {
            type = Constant().TYPE_TO
                        let scr = storyboard?.instantiateViewController(withIdentifier: "calendarCollection") as! CalendarController
            scr.tableProtocol = self
            scr.data = "2"

            type = Constant().TYPE_TO
            self.navigationController?.pushViewController(scr, animated: true)
        }
    }
    
    
    //get date selected
    func getDateSelected(date: String, id: Int) {
        print("here i come=" + String(id))
        if (id == Constant().TYPE_FROM) {
            tfFrom.text = date
        } else if (id == Constant().TYPE_TO) {
            tfTo.text? = date
        }
    }
}
