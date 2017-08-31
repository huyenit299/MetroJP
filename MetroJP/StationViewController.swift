//
//  StationViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/29/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import CoreData

var fromDate: String = ""
var toDate: String = ""
var recordDate: String = ""
class StationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DateSelectedProtocol {
    var listStations: Array<Station> = []
    @IBOutlet weak var tfNote: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var tfFrom: UITextField!

    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var tfTarget: UITextField!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var tableStation: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tfTo: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
        
        navigationBar.topItem?.title = "外出先編集"
        navigationBar.backItem?.title = "Back"
        
        tfDate.delegate = self
        tfFrom.delegate = self
        tfTo.delegate = self
        
        let nib = UINib(nibName: "TrafficItemView", bundle: nil)
        tableStation.register(nib, forCellReuseIdentifier: "TrafficItemView")

        
        tableStation.dataSource = self
        tableStation.delegate = self


    }
    
    @IBAction func saveDataClick(_ sender: Any) {
//        do {
//            try
//                DatabaseManagement.shared.queryAllTraffic()
//        }catch {
//        }
        
        if (tfDate.text?.isEmpty)! {
            let alert = UIAlertController(title: "", message: RecordError().LACK_DATE, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (tfTarget.text?.isEmpty)! {
            let alert = UIAlertController(title: "", message: RecordError().LACK_TARGET, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (tfFrom.text?.isEmpty)! {
            let alert = UIAlertController(title: "", message: RecordError().LACK_FROM, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (tfTo.text?.isEmpty)! {
            let alert = UIAlertController(title: "", message: RecordError().LACK_TO, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (tfAmount.text?.isEmpty)! {
            let alert = UIAlertController(title: "", message: RecordError().LACK_PRICE, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        var traffic: String = ""
        if (!listStations.isEmpty) {
            for station in listStations {
                if (station.select) {
                    traffic += String(station.id) + ","
                }
            }
        }
        if (traffic.isEmpty) {
            let alert = UIAlertController(title: "", message: RecordError().LACK_TRAFFIC, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let record = NSEntityDescription.insertNewObject(forEntityName: "RecordTraffic", into: context)
        record.setValue(tfDate.text, forKey: "date")
        record.setValue(tfTarget.text, forKey: "target")
        record.setValue(tfFrom.text, forKey: "from")
        record.setValue(tfTo.text, forKey: "to")
        record.setValue(tfAmount.text, forKey: "price")
        record.setValue(tfNote.text, forKey: "note")
        record.setValue(traffic, forKey: "listTraffic")
        record.setValue(1, forKey: "id")
        do {
            try context.save()
            print("SAVE record")
        }
        catch {
            print("error")
        }
        
        do {
            try
                DatabaseManagement.shared.addTraffic(_date: tfDate.text!, _target: tfTarget.text!, _from: tfFrom.text!, _to: tfTo.text!, _traffics: traffic, _price: tfAmount.text!, _note: tfNote.text!)
            }catch {
            }
        
        do {
            try
                DatabaseManagement.shared.queryAllTraffic()
        }catch {
        }
    }

    func initData() {
        let station1 = Station(id: 1, name: "JR", select: true)
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
        switch textField {
        case tfFrom:
            type = Constant().TYPE_FROM
            break
        case tfTo:
            type = Constant().TYPE_TO
            break
        case tfDate:
            type = Constant().TYPE_RECORD
            break
        default:
            break
        }
        
        if (textField == tfFrom || textField == tfTo || textField == tfDate) {
            let scr = storyboard?.instantiateViewController(withIdentifier: "calendarCollection") as! CalendarController
            scr.tableProtocol = self
            self.navigationController?.pushViewController(scr, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tfDate.text = recordDate
        tfFrom.text = fromDate
        tfTo.text = toDate
    }
    
    //get date selected
    func getDateSelected(date: String, id: Int) {
        switch id {
        case Constant().TYPE_FROM:
            fromDate = date
            break
        case Constant().TYPE_TO:
            toDate = date
            break
        case Constant().TYPE_RECORD:
            recordDate = date
            break
        default:
            break
        }
    }
}
