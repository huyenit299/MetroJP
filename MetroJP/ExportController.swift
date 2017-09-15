//
//  ExportController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 9/6/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit
import CSV
import MessageUI

class ExportController: BaseViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate, SessionListDelegate {
    let datePickerView:UIDatePicker = UIDatePicker()
    @IBOutlet weak var tfTo: UITextField!
    @IBOutlet weak var tfFrom: UITextField!
    var isSendMail = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_keyboard_arrow_left_white_48pt.png")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backToPrevious))
        navigationItem.leftBarButtonItem = leftButton
        self.title = "Export"
        datePickerView.datePickerMode = UIDatePickerMode.date
        tfTo.delegate = self
        tfFrom.delegate = self
    }

    override func backToPrevious() {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
                switch textField {
                case tfFrom:
                    type = Constant.TYPE_FROM
                    break
                case tfTo:
                    type = Constant.TYPE_TO
                    break
                default:
                    break
                }
        
                if (textField == tfFrom || textField == tfTo) {
        
                    textField.inputView = datePickerView
                    datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
                }
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constant.DATE_STANDARD
//        dateFormatter.dateStyle = DateFormatter.Style.medium
//        dateFormatter.timeStyle = DateFormatter.Style.none
        
                switch type {
                case Constant.TYPE_FROM:
                    tfFrom.text = dateFormatter.string(from: sender.date)
                    break
                case Constant.TYPE_TO:
                    tfTo.text = dateFormatter.string(from: sender.date)
                    break
                default:
                    break
                }
    }
    
    func checkValidate(fromDate: String, toDate: String) -> Bool {
        if (fromDate <= toDate) {
            return true
        }
        return false
    }

    func checkEmptyAndValidate(fromDate: String, toDate: String) -> Bool {
        var error = false
        if (fromDate.isEmpty) {
            error = true
            let alert = UIAlertController(title: "Error", message: "Please fill start date", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert:UIAlertAction!) in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        if (toDate.isEmpty) {
            error = true
            let alert = UIAlertController(title: "Error", message: "Please fill end date", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert:UIAlertAction!) in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        let isLower = checkValidate(fromDate: fromDate, toDate: toDate)
        if (!isLower) {
            error = true
            let alert = UIAlertController(title: "Error", message: "End date must be greater than or equal start date", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert:UIAlertAction!) in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
        return error
    }
    
    @IBAction func btnExportClick(_ sender: Any) {
        let fromDate = tfFrom.text
        let toDate = tfTo.text
        if (!checkEmptyAndValidate(fromDate: fromDate!, toDate: toDate!)) {
//            writeFile(fromDate: fromDate!, toDate: toDate!)
            loading.showActivityIndicator(uiView: self.view)
            WebservicesHelper.getListSessionByDate(sessionDelegate: self, start: fromDate!, end: toDate!)
        }
    }
    
    
    @IBAction func btnExportSendMailClick(_ sender: Any) {
        let fromDate = tfFrom.text
        let toDate = tfTo.text
        isSendMail = true
        WebservicesHelper.getListSessionByDate(sessionDelegate: self, start: fromDate!, end: toDate!)
        
    }
    
    func writeFile(list: Array<RecordTrafficModel>) -> String {
//        let listRecordTraffic = DatabaseManagement.shared.queryAllRecordTraffic(fromDate: fromDate, toDate: toDate)
        let fromDate = tfFrom.text
        let toDate = tfTo.text
        let filePath = "/Users/huyennguyen/Documents/ios/MetroJP/MetroJP/CSV/"+fromDate!+"_"+toDate!+".csv"
        let stream = OutputStream(toFileAtPath: filePath, append: false)!
        let csv = try! CSVWriter(stream: stream)
        try! csv.write(row: ["id", "date", "target", "traffic", "from","to","price","note"])
        if (!list.isEmpty && list.count > 0) {
            let listAllTraffic = DatabaseManagement.shared.queryMapTraffic()
            for record in list {
                let traffic = record.traffic
                var stringTraffic = ""
                if (!traffic.isEmpty) {
                    let listTraffic = traffic.components(separatedBy: ",") as Array<String>
                    if (!listTraffic.isEmpty) {
                        for id in listTraffic {
                            if (!id.isEmpty) {
                                print("aaa=" + listAllTraffic[id]!)
                                if (!(listAllTraffic[id]?.isEmpty)!) {
                                    stringTraffic = stringTraffic + listAllTraffic[id]! + ";"
                                }
                            }
                        }
                    }
                    if (stringTraffic.hasSuffix(";")) {
                    let endIndex = stringTraffic.index(stringTraffic.endIndex, offsetBy: -1)
                       stringTraffic = stringTraffic.substring(to: endIndex)
                    }
                }
                try! csv.write(row: [String(record.id), record.date,record.target,stringTraffic, record.from, record.to, record.price, record.note])
            }
        }
        csv.stream.close()
        return filePath
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        self.dismiss(animated: true, completion: nil)
    }
    
    func getSessionList (listRecordTraffic: Array<RecordTrafficModel>) {
        writeFile(list: listRecordTraffic)
        loading.hideActivityIndicator(uiView: self.view)
        if (isSendMail) {
            isSendMail = false
            let fromDate = tfFrom.text
            let toDate = tfTo.text
            let filePath = "/Users/huyennguyen/Documents/ios/MetroJP/MetroJP/CSV/"+fromDate!+"_"+toDate!+".csv"
            if( MFMailComposeViewController.canSendMail() ) {
                print("Can send email.")
                
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self
                
                //Set the subject and message of the email
                mailComposer.setSubject("REPORT TRAFFIC")
                if let fileData = NSData(contentsOfFile: filePath) {
                    print("File data loaded.")
                    mailComposer.addAttachmentData((fileData as Data) as Data, mimeType: "text/csv", fileName: fromDate!+"_"+toDate!+".csv")
                }
                self.present(mailComposer, animated: true, completion: nil)
            }

        }
    }
}
