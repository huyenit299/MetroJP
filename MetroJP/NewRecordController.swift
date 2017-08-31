//
//  NewRecordController.swift
//  MetroJP
//
//  Created by Huyen Nguyen on 8/28/17.
//  Copyright © 2017 HuyenNguyen. All rights reserved.
//

import UIKit

class NewRecordController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var listStations: Array<TrafficModel> = []

    let scrollView  = UIScrollView()
    let contentView = UIView()
    
    var longer = UIView()
    
    lazy var sectionInfor = UIView()
    lazy var tableTraffic = UITableView()
    lazy var trafficInfor = UIView()
    lazy var interval = UIView()
    
    lazy var lbDate = UILabel()
    lazy var tfDate = UITextField()
    lazy var lbTarget = UILabel()
    lazy var tfTarget = UITextField()
    lazy var lbTraffic = UILabel()
    var didSetupConstraints = false
    let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
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
        
        let nib = UINib(nibName: "TrafficItemView", bundle: nil)
        tableTraffic.register(nib, forCellReuseIdentifier: "TrafficItemView")
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(sectionInfor)
        contentView.addSubview(trafficInfor)
        contentView.addSubview(interval)
        
        sectionInfor.addSubview(lbDate)
        sectionInfor.addSubview(tfDate)
        sectionInfor.addSubview(lbTarget)
        sectionInfor.addSubview(tfTarget)
        
        tableTraffic.clipsToBounds = true
        trafficInfor.addSubview(lbTraffic)
        trafficInfor.addSubview(tableTraffic)
        
        tableTraffic.dataSource = self
        tableTraffic.delegate = self
        tableTraffic.isScrollEnabled = false
        tableTraffic.contentSize.height = CGFloat(listStations.count * 40)

    }
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            layout()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func layout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView)
            make.height.greaterThanOrEqualTo(self.scrollView.snp.height)
        }
        
       
        
        sectionInfor.backgroundColor = UIColor.white
        sectionInfor.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.size.equalTo(CGSize(width: 100, height: 140))
        }
        
        trafficInfor.backgroundColor = UIColor.white
        trafficInfor.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(sectionInfor.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.size.equalTo(CGSize(width: 100, height: 200))
        }
        
        
        interval.backgroundColor = UIColor.red
        interval.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.trafficInfor.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.size.equalTo(CGSize(width: 100, height: 1000))
        }
        
        lbDate.text = "日付"
        lbDate.backgroundColor = UIColor.gray
        lbDate.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(sectionInfor.snp.top).offset(20)
            make.left.equalTo(sectionInfor.snp.left)
            make.right.equalTo(sectionInfor.snp.right)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        tfDate.placeholder = "16/5/31(火)"
        tfDate.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(lbDate.snp.bottom)
            make.left.equalTo(sectionInfor.snp.left)
            make.right.equalTo(sectionInfor.snp.right)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        lbTarget.text = "外出先"
        lbTarget.backgroundColor = UIColor.gray
        lbTarget.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(tfDate.snp.bottom)
            make.left.equalTo(sectionInfor.snp.left)
            make.right.equalTo(sectionInfor.snp.right)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        tfTarget.placeholder = "ベネッセコーポレーション"
        tfTarget.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(lbTarget.snp.bottom)
            make.left.equalTo(sectionInfor.snp.left)
            make.right.equalTo(sectionInfor.snp.right)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }


        lbTraffic.text = "利用交通機関"
        lbTraffic.backgroundColor = UIColor.gray
        lbTraffic.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(tfTarget.snp.bottom)
            make.left.equalTo(trafficInfor.snp.left)
            make.right.equalTo(trafficInfor.snp.right)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        tableTraffic.backgroundColor = UIColor.gray
        tableTraffic.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(lbTraffic.snp.bottom)
            make.left.equalTo(trafficInfor.snp.left)
            make.right.equalTo(trafficInfor.snp.right)
            make.size.equalTo(CGSize(width: 100, height: 840))
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
}
