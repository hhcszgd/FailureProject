//
//  DDPublicSearchMoreVC.swift
//  Project
//
//  Created by 金曼立 on 2018/4/18.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPublicSearchMoreVC: DDNormalVC {
    
    var searchMore : [DDAppointShrotModel]? = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "更多约定"
        requestData()
        configTableView()
    }
    
    func requestData() {
        if let dict  = self.userInfo as? [String:String] , let keywords = dict["keywords"] {
            DDRequestManager.share.searchSmartly(type: ApiModel<[DDAppointShrotModel]>.self , keywords: keywords , search_type: "4", complate: { (model) in
                if model?.status == 200 {
                    mylog("搜索成功")
                    if model?.data?.count ?? 0 != 0 {
                        self.searchMore = model?.data
                        self.tableView.reloadData()
                    }else{
                        self.searchMore = []
                        GDAlertView.alert("暂无约定", image: nil, time: 2, complateBlock: nil)
                    }
                }else{
                    self.searchMore = []
                    GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
                }
            })
        }
    }
    
    func configTableView() {
        tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.gdRefreshControl = GDRefreshControl.init(target: self , selector: #selector(refreshData))
        tableView.gdRefreshControl?.refreshHeight = 40
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.tableView.gdRefreshControl?.endRefresh()
        }
        requestData()
    }
}

extension DDPublicSearchMoreVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMore?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < (searchMore?.count ?? 0)) && searchMore?.count != 0 {
            let model = searchMore?[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DDPublicSearchCell") as? DDPublicSearchCell{
                cell.model = model
                return cell
            }else{
                let cell = DDPublicSearchCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDPublicSearchCell")
                cell.model = model
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row < (searchMore?.count ?? 0)) && searchMore?.count != 0 {
            if let model = searchMore?[indexPath.row] {
                /*2自己   , 1 是别人*/
                var userType = "1"
                if model.aId == DDAccount.share.id {
                    userType = "2"
                }
                self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: ["orderID": searchMore?[indexPath.row].orderId, "userType":userType, "privateOrPublic":"1" , "yue_type": model.yueType /*1单约  2 群约*/])
            }
        }
        
//        self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: ["orderID": searchMore?[indexPath.row].orderId , "userType":"1"/*2自己   , 1 是别人*/ , "privateOrPublic":"1" , "yue_type":"1" /*1单约  2 群约*/])
    }
}
