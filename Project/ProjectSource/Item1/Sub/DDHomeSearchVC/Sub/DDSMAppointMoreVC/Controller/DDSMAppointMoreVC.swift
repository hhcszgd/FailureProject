//
//  DDSMAppointMoreVC.swift
//  Project
//
//  Created by WY on 2018/4/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDSMAppointMoreVC: DDNormalVC {
    enum SearchAppointType : String{
        
        ///2:我发布的【付款方】
        case payer = "2"
        
        ///3:我参与的【收款方】
        case earner = "3"
        
        ///4:公开约定
        case publicApplint = "4"
    }
    var appointType = SearchAppointType.payer
    var keyWord = ""
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
    var apiModel : ApiModel<[DDAppointShrotModel]>?
    var page : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "更多约定"
        if let dict = self.userInfo as? [String:String]{
            if let type = dict["type"] , let a = SearchAppointType.init(rawValue: type){
                appointType = a
            }
            if let keyWord = dict["keyWord"] {
                self.keyWord = keyWord
            }
        }
        self.configTableView()
        self.requestApi()
    }
    func requestApi() {
        if  keyWord.count > 0{
            DDRequestManager.share.searchSmartly(type: ApiModel<[DDAppointShrotModel]>.self , keywords: keyWord, search_type : appointType.rawValue , page : "\(self.page)" ,complate: { (model ) in
                if self.apiModel == nil {
                    self.apiModel = model
                    if let cellModels = model?.data , cellModels.count > 0 {}else{
                         GDAlertView.alert("没有相应的结果", image: nil, time: 2, complateBlock: nil)
                    }
                }else {
                    if let cellModels = model?.data , cellModels.count > 0 {
                        self.apiModel?.data?.append(contentsOf: cellModels)
                        self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.success)
                    }else{
                        self.tableView.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
                    }
                }
                self.tableView.reloadData()
            })
            
        }else{
            self.view.endEditing(true)
        }
    }
    @objc func loadMoreData() {
        self.page += 1
        self.requestApi()
    }
    func configTableView() {
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.gdLoadControl = GDLoadControl(target: self , selector: #selector(loadMoreData))
    }
    
}

extension DDSMAppointMoreVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var para = [String :String]()
        if let sectionModel = self.apiModel?.data?[indexPath.row] {
            switch self.appointType {
            case .payer://///我的约定【付款方】
                para["userType"] = "2"
            case .earner://我的约定【收款方】
                para["userType"] = "1"
                para["yiFangID"] = DDAccount.share.id
            case .publicApplint:///公共约定
                if sectionModel.user_type ?? "1" == "1"{//收款方
                    para["userType"] = "1"
                    para["yiFangID"] = DDAccount.share.id
                }else if sectionModel.user_type ?? "1" == "2"{//付款方
                    para["userType"] = "2"
                }
                break
            }
            para["orderID"] = sectionModel.orderId
            
            para["privateOrPublic"]  = sectionModel.type ?? "1"
            ///(1:单，2：群)
            para["yue_type"]  = sectionModel.yueType ?? "1"
            self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: para)//请求详情接口时付款方标识为2
//             self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: ["orderID": orderID , "userType":"2"/*2付款 1收款*/,"privateOrPublic":privateOrPublic,"yue_type":"1" , "yiFangID":partnerID ])//请求详情接口时付款方标识为2
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch self.appointType {
            case .payer://///我的约定【付款方】
                if self.apiModel?.data?[indexPath.row].type ?? "x" == "0"{//私密
                    return 44
                }else if self.apiModel?.data?[indexPath.row].type ?? "x" == "1"{//公开
                    return 120
                }
            case .earner://我的约定【收款方】
                if self.apiModel?.data?[indexPath.row].type ?? "x" == "0"{//私密
                    return 44
                }else if self.apiModel?.data?[indexPath.row].type ?? "x" == "1"{//公开
                    return 120
                }
            case .publicApplint:///公共约定
                return 120
            }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.apiModel?.data?.count ?? 0
    }
    
    ///【0 私密约定 1公开约定】
    enum AppointType {
        case privateAppoint
        case publicAppoint
    }
    func getCellByType(tableView:UITableView ,type:DDHomeSearchVC.AppointType) -> SearchSmartlyBaseCell {
        var cellForReturn  : SearchSmartlyBaseCell
        switch type {
        case .privateAppoint:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchSmartlyPrivateAppointCell") as? SearchSmartlyPrivateAppointCell{
                cellForReturn = cell
            }else{
                let cell = SearchSmartlyPrivateAppointCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "SearchSmartlyPrivateAppointCell")
                cellForReturn = cell
            }
        case .publicAppoint:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchSmartlyPublicAppointCell") as? SearchSmartlyPublicAppointCell{
                cellForReturn = cell
            }else{
                let cell = SearchSmartlyPublicAppointCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "SearchSmartlyPublicAppointCell")
                cellForReturn = cell
            }
        }
        return cellForReturn
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellForReturn  : SearchSmartlyBaseCell?
        
        if let sectionModel = self.apiModel?.data {
            switch self.appointType {
            
            case .payer://///我的约定【付款方】
                if sectionModel[indexPath.row].type ?? "x" == "0"{//私密
                    cellForReturn = self.getCellByType(tableView: tableView, type: DDHomeSearchVC.AppointType.privateAppoint)
                }else if sectionModel[indexPath.row].type ?? "x" == "1"{//公开
                    cellForReturn = self.getCellByType(tableView: tableView, type: DDHomeSearchVC.AppointType.publicAppoint)
                }
                
            case .earner://我的约定【收款方】
                if sectionModel[indexPath.row].type ?? "x" == "0"{//私密
                    cellForReturn = self.getCellByType(tableView: tableView, type: DDHomeSearchVC.AppointType.privateAppoint)
                }else if sectionModel[indexPath.row].type ?? "x" == "1"{//公开
                    cellForReturn = self.getCellByType(tableView: tableView, type: DDHomeSearchVC.AppointType.publicAppoint)
                }
                
            case .publicApplint:///公共约定
                cellForReturn = self.getCellByType(tableView: tableView, type: DDHomeSearchVC.AppointType.publicAppoint)
            default:
                break
            }
        }
        if cellForReturn == nil {return SearchSmartlyBaseCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "xxxxx")}
        cellForReturn?.model = self.apiModel?.data?[indexPath.row]
        return cellForReturn!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return 0.001
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
}

