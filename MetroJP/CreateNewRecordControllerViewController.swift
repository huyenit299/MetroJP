//
//  CreateNewRecordControllerViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/24/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class CreateNewRecordControllerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var listStations: Array<TrafficModel> = []
 var didSetupConstraints = false
    @IBOutlet weak var lbTopContranst: NSLayoutConstraint!
    @IBOutlet weak var lbDetail: UILabel!
    @IBOutlet weak var tableStation: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "New title"
        let station1 = TrafficModel(id: 1, name: "JR", select: false)
        let station2 = TrafficModel(id: 1, name: "地下鉄", select: false)
        let station3 = TrafficModel(id: 1, name: "私鉄", select: false)
        let station4 = TrafficModel(id: 1, name: "高速", select: false)
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

        tableStation.dataSource = self
        tableStation.delegate = self
//        tableStation.isScrollEnabled = false
//        tableStation.contentSize.height = CGFloat(listStations.count * 40)
        print("aaaaa1")
    }
    
    func autoLayout() {
//        lbDetail.translatesAutoresizingMaskIntoConstraints = false
        
//        lbDetail.topAnchor.constraint(equalTo: tableStation.bottomAnchor, constant: 1000).isActive = true
//        lbTopContranst.constant = CGFloat(listStations.count * 40)
//        lbDetail.layoutIfNeeded()
//        lbDetail.updateConstraints()
//        let labelFrom = UILabel()
//        labelFrom.text = "Hâhhaa"
//        self.view.addSubview(labelFrom)
        lbDetail.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.tableStation.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            autoLayout()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableStation.contentSize.height = CGFloat(listStations.count * 40)
        var frame: CGRect = self.tableStation.frame;
        frame.size.height = self.tableStation.contentSize.height;
        self.tableStation.frame = frame;
        autoLayout()
        view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("aaaaaa13="+String(listStations.count))
        return listStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                print("aaaaaa1323")
                let cell = tableView.dequeueReusableCell(withIdentifier: "StationItemView") as! StationItemView
                return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return listStations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("aaaaaa132")
        return 40
    }


}
