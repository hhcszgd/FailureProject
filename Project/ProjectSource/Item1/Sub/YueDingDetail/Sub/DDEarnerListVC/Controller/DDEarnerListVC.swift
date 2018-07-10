//
//  DDEarnerListVC.swift
//  Project
//
//  Created by WY on 2018/4/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDEarnerListVC: DDNormalVC {
    
    let bottomH : CGFloat = 115
    
    let tableView = UITableView()
    let bottomView = DDEarnerBottomView()
    
    var priceNum : CGFloat = 0.0
    var selectNum : Int = 0
    
    var earner : [DDEarnerModel]? = []
    var dict : [String:String]?
    var idList : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "一键放款"
        dict = self.userInfo as? [String : String]
        self.view.addSubview(tableView)
        self.view.addSubview(bottomView)

        self.tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDSliderHeight - DDNavigationBarHeight - bottomH)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableView.separatorColor = UIColor.colorWithRGB(red: 204, green: 204, blue: 204)
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        configBottomView()
        requestData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI(notification:)), name: NSNotification.Name(rawValue: "DDEarnerCellClick"), object: nil)
    }

    func requestData() {
        
        var num = ""
        if dict?["yue_type"] == "2" {
            num = dict?["num"] ?? ""
        }
        
        DDRequestManager.share.getLendersList(type: ApiModel<[DDEarnerModel]>.self, order_id: dict?["orderid"] ?? "", num: num) { (model) in
            if model?.status == 200 {
                mylog("约定详情返回成功")
                self.earner = model?.data
                if let earnerModel = self.earner {
                    for model in earnerModel {
                        if model.status != "2" && model.status != "3" && model.status != "4" {
                            self.idList.append(model.id ?? "")
                        }
                    }
                }
                self.tableView.reloadData()
                self.calculateMonay()
            } else {
                self.earner = []
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
            }
        }
    }
    
    func calculateMonay() {
        if let earnerModel = earner {
            for model in earnerModel {
                if model.status != "4" &&  model.status != "2" &&  model.status != "3" {
                    priceNum = priceNum + CGFloat(NSString(string: model.payment_price ?? "").floatValue)
                    selectNum += 1
                }
            }
            if selectNum == 0 {
                bottomView.earnerBtn.isUserInteractionEnabled = false
                bottomView.earnerBtn.backgroundColor = UIColor.colorWithRGB(red: 153, green: 153, blue: 153)
            }
            bottomView.peopleNum = selectNum
            bottomView.priceNum = priceNum
        }
    }
    
    @objc func refreshUI(notification:NSNotification) {
        let id = notification.userInfo?["id"] as? String
        let isSelect = notification.userInfo?["selectNum"] as? Bool
        let price : CGFloat = CGFloat(NSString(string: (notification.userInfo?["priceNum"] as? String) ?? "").floatValue)
        if isSelect ?? false {
            selectNum += 1
            priceNum = priceNum + price
            let contain = self.idList.contains(id ?? "")
            if !contain {
                self.idList.append(id ?? "")
            }
        } else if selectNum > 0 {
            selectNum -= 1
            priceNum = priceNum - price
            let contain = self.idList.contains(id ?? "")
            if contain {
                if let index = idList.index(of: id ?? "") {
                    self.idList.remove(at: index)
                }
            }
        }
        bottomView.peopleNum = selectNum
        bottomView.priceNum = priceNum
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configBottomView() {
        let bottomY = SCREENHEIGHT - DDSliderHeight - bottomH
        bottomView.frame = CGRect(x: 0, y: bottomY, width: SCREENWIDTH, height: bottomH)
        bottomView.bottomViewCallBack = { () ->()  in
            if self.idList.count == 0 {
                GDAlertView.alert("请选择收款人", image: nil, time: 2 , complateBlock: nil)
                return
            }
            let psdInput =  DDPayPasswordInputView(superView: self.view)
            psdInput.passwordComplateHandle = {password in
                self.view.endEditing(true )
                DDRequestManager.share.payToPartner(type: ApiModel<String>.self, partnerIDs: self.idList, payword: password, complate: { (model) in
                    if model?.status == 200 {
                        GDAlertView.alert("放款成功", image: nil, time: 2 , complateBlock: {
                            let lenders = self.dict?["lenders"] ?? ""
                            let orderid = self.dict?["orderid"] ?? ""
                            let num = "1"  // 此处一定是单期，在期数列表跳转过来
                            let yue_type = self.dict?["yue_type"] ?? ""
//                            let bid = self.selectNum > 1 ? "" : (self.dict?["bid"] ?? "") // 当选取人数大于1时，放款详情为单期多人，不需要bid，但num为1
                            let bid = ""
                            let numRequest = self.dict?["num"] ?? ""
                            let para  = ["lenders" :  lenders,
                                         "orderid" : orderid,
                                         "num" : num,
                                         "yue_type" : yue_type,
                                         "bid" : bid,  // 进入单人放款详情不需要bid
                                         "numRequest" : numRequest]
                            self.navigationController?.pushVC(vcIdentifier: "DDEarnerResultVC", userInfo: para)
                        })
                    } else {
                        GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
                    }
                })
            }
            psdInput.forgetHandle = {
                self.view.endEditing(true)
                self.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC")
            }
        }
    }

}

extension DDEarnerListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earner?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = earner?[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "DDEarnerCell") as? DDEarnerCell
        if (cell == nil) {
            cell = DDEarnerCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDEarnerCell")
        }
        cell?.model = model
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as? DDEarnerCell
        let model = earner?[indexPath.row]
        if model?.status == "2" || model?.status == "3" || model?.status == "5" || model?.status == "6" {
            return
        } else {
            cell?.selectBtn.isSelected = !(cell?.selectBtn.isSelected ?? true)
        }
        let price : CGFloat = CGFloat(NSString(string: model?.payment_price ?? "").floatValue)
        if (cell?.selectBtn.isSelected ?? false) {
            selectNum += 1
            priceNum = priceNum + price
            let contain = self.idList.contains(model?.id ?? "")
            if !contain {
                self.idList.append(model?.id ?? "")
            }
        } else {
            selectNum -= 1
            priceNum = priceNum - price
            let contain = self.idList.contains(model?.id ?? "")
            if contain {
                if let index = idList.index(of: model?.id ?? "") {
                    self.idList.remove(at: index)
                }
            }
        }
        bottomView.peopleNum = selectNum
        bottomView.priceNum = priceNum
    }
}


