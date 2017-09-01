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
class StationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DateSelectedProtocol, SelectSwitchDelegate {
    var listTraffic: Array<TrafficModel> = []
    @IBOutlet weak var tfNote: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var tfFrom: UITextField!

    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var tfTarget: UITextField!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var tableStation: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tfTo: UITextField!
    var id: Int = -1
    var record = RecordTrafficModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
        
        navigationBar.topItem?.title = "外出先編集"
        
        tfDate.delegate = self
        tfFrom.delegate = self
        tfTo.delegate = self
        
        let nib = UINib(nibName: "TrafficItemView", bundle: nil)
        tableStation.register(nib, forCellReuseIdentifier: "TrafficItemView")

        tableStation.dataSource = self
        tableStation.delegate = self
    }
    
    
    @IBAction func backClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveDataClick(_ sender: Any) {
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
        if (!listTraffic.isEmpty) {
            for t in listTraffic {
                if (t.select) {
                    traffic += String(t.id) + ","
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
                DatabaseManagement.shared.addRecordTraffic(_date: tfDate.text!, _target: tfTarget.text!, _from: tfFrom.text!, _to: tfTo.text!, _traffics: traffic, _price: tfAmount.text!, _note: tfNote.text!)
            }catch {
            }
        
        do {
            try
                DatabaseManagement.shared.queryAllRecordTraffic()
        }catch {
        }
    }

    func initData() {
        listTraffic = DatabaseManagement.shared.queryAllTraffic()
        if (id >= 0) {
            let record = DatabaseManagement.shared.queryRecordTraffic(trafficId: Int64(id)) as RecordTrafficModel
            recordDate = record.date
            fromDate = record.from
            toDate = record.to
            tfFrom.text = record.from
            tfTo.text = record.to
            tfNote.text = record.note
            tfAmount.text = record.price
            tfTarget.text = record.target
            let traffic = record.traffic
            if (!traffic.isEmpty) {
                let listTraffic = traffic.components(separatedBy: ",") as Array<String>
                if (!listTraffic.isEmpty) {
                    for id in listTraffic {
                        for t in self.listTraffic {
                            if(!id.isEmpty && (Int(id) == t.id)) {
                                t.select = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTraffic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrafficItemView") as! TrafficItemView
        cell.lbStation.text = listTraffic[indexPath.row].name
        cell.selectStation.setOn(listTraffic[indexPath.row].select, animated: false)
        cell.row = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("select="+String(indexPath.row))
//        listTraffic[indexPath.row].select = !listTraffic[indexPath.row].select
//    }

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
    
    func clickSwitch(row: Int) {
        print("select11="+String(row))
        listTraffic[row].select = !listTraffic[row].select
    }

}
