//
//  StationViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/29/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import CoreData

class StationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SelectSwitchDelegate {
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
    let datePickerView:UIDatePicker = UIDatePicker()
    var isFavorite = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerView.datePickerMode = UIDatePickerMode.date
        let rightButton: UIBarButtonItem = UIBarButtonItem(title: "完了", style: UIBarButtonItemStyle.plain, target: self, action: #selector(menuButtonTapped))
         navigationItem.rightBarButtonItem = rightButton
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_keyboard_arrow_left_white_48pt")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backClick))
        navigationItem.leftBarButtonItem = leftButton

        self.title = "外出先編集"
        
        initData()
        
        tfDate.delegate = self
        
        let nib = UINib(nibName: "TrafficItemView", bundle: nil)
        tableStation.register(nib, forCellReuseIdentifier: "TrafficItemView")

        tableStation.dataSource = self
        tableStation.delegate = self
    }
    
    func menuButtonTapped() {
        print("aaaab right")
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
        
       
        
        if (id <= 0) {
             WebservicesHelper.addSession(date: tfDate.text!, target: tfTarget.text!, traffic: traffic, from: tfFrom.text!, to: tfTo.text!, fare: tfAmount.text!, remarks: tfNote.text!)
            do {
                try
                    DatabaseManagement.shared.addRecordTraffic(_date: tfDate.text!, _target: tfTarget.text!, _from: tfFrom.text!, _to: tfTo.text!, _traffics: traffic, _price: tfAmount.text!, _note: tfNote.text!, _isFavorite: isFavorite)
                changedData = true
            }catch {
                print(error)
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert:UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            WebservicesHelper.updateSession(sessionId: id, date: tfDate.text!, target: tfTarget.text!, traffic: traffic, from: tfFrom.text!, to: tfTo.text!, fare: tfAmount.text!, remarks: tfNote.text!)
            do {
                let recordTraffic = RecordTrafficModel(id: id, date: tfDate.text!, target: tfTarget.text!, from: tfFrom.text!, to: tfTo.text!, traffic: traffic, price: tfAmount.text!, note: tfNote.text!, isFavorite: isFavorite)
                try
                    DatabaseManagement.shared.updateRecordTraffic(trafficId: Int64(id), newTraffic: recordTraffic)
                changedData = true
            }catch {
                print(error)
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert:UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if (changedData) {
            let alert = UIAlertController(title: "", message: "Save successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert:UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
           
        }
    }
    
    
    @IBAction func backClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
   
    func initData() {
        listTraffic = DatabaseManagement.shared.queryAllTraffic()
        if (id >= 0) {
            let record = DatabaseManagement.shared.queryRecordTraffic(trafficId: Int64(id)) as RecordTrafficModel
            tfDate.text = record.date
            tfFrom.text = record.from
            tfTo.text = record.to
            tfNote.text = record.note
            tfAmount.text = record.price
            tfTarget.text = record.target
            isFavorite = record.isFavorite
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == tfDate) {
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constant.DATE_STANDARD
        tfDate.text = dateFormatter.string(from: sender.date)
    }
    
    func clickSwitch(row: Int) {
        listTraffic[row].select = !listTraffic[row].select
    }

}
