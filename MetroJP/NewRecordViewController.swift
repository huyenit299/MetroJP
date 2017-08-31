//
//  NewRecordViewController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/28/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class NewRecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableSection: UITableView!
    var listStations: Array<TrafficModel> = []
    override func viewDidLoad() {
        super.viewDidLoad()
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
        tableSection.dataSource = self
        tableSection.delegate = self
        tableSection.isScrollEnabled = false
        tableSection.contentSize.height = CGFloat(listStations.count * 40)

        self.tableSection.translatesAutoresizingMaskIntoConstraints = true
//        self.tableSection.frame = CGRect(0, 0, self.tableSection.frame.width, CGFloat(listStations.count * 40));
        tableSection.layoutIfNeeded()
        print("123")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableSection.contentSize.height = CGFloat(listStations.count * 40)
//        if(self.tableSection.contentSize.height < self.tableSection.frame.height){
            var frame: CGRect = self.tableSection.frame;
            frame.size.height = self.tableSection.contentSize.height;
            self.tableSection.frame = frame;
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationTableViewCell") as! StationTableViewCell
        print("1234")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
