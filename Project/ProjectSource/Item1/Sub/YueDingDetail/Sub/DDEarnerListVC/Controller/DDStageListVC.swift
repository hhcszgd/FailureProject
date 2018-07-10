//
//  DDStageListVC.swift
//  Project
//
//  Created by 金曼立 on 2018/4/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDStageListVC: DDNormalVC {
    
    let tableView = UITableView()
    let earnerBtn = UIButton()
    let accessoryView = DDInputAccessoryView()
    var dict : [String : String]?
    var type: String? // 1 查看单人  2 查看多人
    var yue_type : String? // 1 单约  2  群约
    var stageMore : ApiModel<DDStageMoreModel>?
    var stageSingle : ApiModel<[DDStageSingleModel]>?
    var lastSelsctSingleCell : DDStageSingleCell?
    var lastSelsctMoreCell : DDStageMoreCell?
    var selectIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dict = self.userInfo as? [String : String]
        type = dict?["type"] ?? ""
        yue_type = dict?["yue_type"] ?? ""

        self.view.addSubview(tableView)
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
        
        if type == "1" {
            self.title = "约定详情"
            self.tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - 40 - DDSliderHeight)
            self.view.addSubview(earnerBtn)
            earnerBtn.frame = CGRect(x: 0, y: SCREENHEIGHT - DDSliderHeight - 40, width: SCREENWIDTH, height: 40)
            earnerBtn.addTarget(self, action: #selector(earnerBtnClick), for: UIControlEvents.touchUpInside)
            earnerBtn.backgroundColor = UIColor.lightGray
            earnerBtn.isUserInteractionEnabled = false
            earnerBtn.setTitle("放款", for: UIControlState.normal)
            var bid = ""
            if yue_type == "2" {
                bid = dict?["bid"] ?? ""
            }
            DDRequestManager.share.getEarnerStageSingle(type: ApiModel<[DDStageSingleModel]>.self, order_id: dict?["orderid"] ?? "", bid: bid) { (model) in
                if model?.status == 200 {
                    self.stageSingle = model
                    self.tableView.reloadData()
                } else {
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                }
            }
        } else if type == "2" {
            self.title = "多人约定详情"
            self.tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight)
            DDRequestManager.share.getEarnerStageMore(type: ApiModel<DDStageMoreModel>.self, order_id: dict?["orderid"] ?? "") { (model) in
                if model?.status == 200 {
                    self.stageMore = model
                    self.tableView.reloadData()
                } else {
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                }
            }
        }
    }
    
    @objc func earnerBtnClick() {
        let psdInput =  DDPayPasswordInputView(superView: self.view)
        psdInput.passwordComplateHandle = { password in
            DDRequestManager.share.payToPartner(type: ApiModel<String>.self , partnerIDs: [self.stageSingle?.data?[self.selectIndex].id ?? ""], payword: password) { (model ) in
                if model?.status == 200 {
                    GDAlertView.alert("放款成功", image: nil, time: 2 , complateBlock: {
                        let lenders = self.dict?["lenders"] ?? ""
                        let orderid = self.dict?["orderid"] ?? ""
                        let num = "1"  // 肯定是单期
                        let yue_type = self.dict?["yue_type"] ?? ""
                        let bid = self.dict?["bid"] ?? ""
                        let numRequest = self.stageSingle?.data?[self.selectIndex].num ?? ""
                        let para  = ["lenders" :  lenders,
                                     "orderid" : orderid,
                                     "num" : num,
                                     "yue_type" : yue_type,
                                     "bid" : bid,
                                     "numRequest" : numRequest]
                        self.navigationController?.pushVC(vcIdentifier: "DDEarnerResultVC", userInfo: para)
                    })
                } else {
                    GDAlertView.alert(model?.message, image: nil, time: 2 , complateBlock: nil )
                }
            }
            self.accessoryView.removeFromSuperview()
        }
        psdInput.forgetHandle = {
            self.view.endEditing(true )
            self.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if type == "1" {
            var bid = ""
            if yue_type == "2" {
                bid = dict?["bid"] ?? ""
            }
            DDRequestManager.share.getEarnerStageSingle(type: ApiModel<[DDStageSingleModel]>.self, order_id: dict?["orderid"] ?? "", bid: bid) { (model) in
                if model?.status == 200 {
                    self.stageSingle = model
                    self.tableView.reloadData()
                } else {
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                }
            }
        } else if type == "2" {
            DDRequestManager.share.getEarnerStageMore(type: ApiModel<DDStageMoreModel>.self, order_id: dict?["orderid"] ?? "") { (model) in
                if model?.status == 200 {
                    self.stageMore = model
                    self.tableView.reloadData()
                } else {
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DDStageListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if type == "1" {
            return stageSingle?.data?.count ?? 0
        } else if type == "2" {
            return stageMore?.data?.item?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if type == "1" {
            var cell = tableView.dequeueReusableCell(withIdentifier: "DDStageSingleCell") as? DDStageSingleCell
            if (cell == nil) {
                cell = DDStageSingleCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDStageSingleCell")
            }
            cell?.model = stageSingle?.data?[indexPath.row]
            return cell!
        } else if type == "2" {
            var cell = tableView.dequeueReusableCell(withIdentifier: "DDStageMoreCell") as? DDStageMoreCell
            if (cell == nil) {
                cell = DDStageMoreCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDStageMoreCell")
            }
            cell?.count = stageMore?.data?.count ?? 0
            cell?.model = stageMore?.data?.item?[indexPath.row]
            return cell!
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == "1" {
            lastSelsctSingleCell?.selectedImg.image = UIImage(named:"checkboxisnotselected")
            let cell = self.tableView.cellForRow(at: indexPath) as? DDStageSingleCell
            cell?.selectedImg.image = UIImage(named:"selected_btn_icon")
            selectIndex = indexPath.row
            lastSelsctSingleCell = cell
            if let model = stageSingle?.data?[indexPath.row] {
                if model.status == "0" || model.status == "6"{
                    return
                }
            }
            earnerBtn.backgroundColor = UIColor.DDThemeColor
            earnerBtn.isUserInteractionEnabled = true
        } else if type == "2" {
            if let model = stageMore?.data?.item?[indexPath.row] {
                if model.num == stageMore?.data?.count {
                    GDAlertView.alert("该期已经全部放款", image: nil, time: 2, complateBlock: nil)
                    return
                }
            }
            
            let lenders = self.dict?["lenders"] ?? ""
            let orderid = self.dict?["orderid"] ?? ""
            let num = "\(self.stageMore?.data?.item?[indexPath.row].term ?? 0)"
            let yue_type = self.stageMore?.data?.yue_type ?? ""
            let bid = self.dict?["bid"] ?? ""
            let para  = ["lenders" :  lenders,
                         "orderid" : orderid,
                         "num" : num,
                         "yue_type" : yue_type,
                         "bid" : bid]
            self.navigationController?.pushVC(vcIdentifier: "DDEarnerListVC", userInfo: para)
        }
    }
}

extension DDStageListVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        mylog(textField.text)
        mylog(range )
        mylog(string )
        if range.length == 0{//写
            if let text = textField.text {
                self.accessoryView.inputString = text + string
            }
        }else if range.length == 1{//删
            if let text = textField.text {
                var text = text
                text.removeLast()
                self.accessoryView.inputString = text
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
