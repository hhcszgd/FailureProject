//
//  DDSystemMsgVC.swift
//  Project
//
//  Created by WY on 2018/1/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDSystemMsgVC: DDNormalVC {
    var  apiModel : ApiModel<[DDMessageContentModel]>?
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "一把通"
        configTableView()
        
        if let dict = self.userInfo as? [String:String]{
            self.title = dict["title"]
            requestApi(messageID: dict["messageID"] ?? "")
            
        }
        
        NotificationCenter.default.addObserver(self , selector: #selector(reloadData), name: GDReloadMessageList, object: nil )
    }
    
    @objc func reloadData() {
        if let dict = self.userInfo as? [String:String]{
            self.title = dict["title"]
            requestApi(messageID: dict["messageID"] ?? "")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self )
    }
    
    func requestApi(messageID:String )  {
        let leftMargin : CGFloat = 20
        let rightMargin : CGFloat = 80
        let containerMaxWidth : CGFloat = self.view.bounds.width - leftMargin - rightMargin
        let contentMaxWidth : CGFloat = containerMaxWidth - leftMargin * 2
        DDRequestManager.share.homeMessageDetailApi(type: ApiModel<[DDMessageContentModel] >.self, messageID: messageID) { (apiModel ) in
            if let apiModel = apiModel{
                if apiModel.status  == 200{
                    self.apiModel = apiModel
                    self.tableView.reloadData()
                    mylog(apiModel)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                        if let count = self.apiModel?.data?.count , count  > 0 {
                            self.tableView.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: UITableViewScrollPosition.top, animated: false)
                        }
                    })
                }else{
                    GDAlertView.alert(apiModel.message, image: nil , time: 2 , complateBlock: nil)
                }
            }else{
                DDErrorView(superView: self.view, error: DDError.serverError("请求失败")).automaticRemoveAfterActionHandle = { [weak self ] in
                    if let dict = self?.userInfo as? [String:String]{
                        self?.requestApi(messageID: dict["messageID"] ?? "")
                    }
                }
            }
            
        }

    }
    func configTableView() {
        self.view.addSubview(tableView)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.frame = CGRect(x:0 , y :DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.colorWithHexStringSwift("E9EEF3")
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("E9EEF3")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension DDSystemMsgVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model  = self.apiModel?.data?[indexPath.row]{
            self.performActionBy(model: model)
        }
//        self.navigationController?.pushVC(vcIdentifier: "DDSystemMsgVC", userInfo: self.apiModel?.data?.message?[indexPath.row].id)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var returnRowHeight : CGFloat = 0
        
        if let rowHeight =  apiModel?.data?[indexPath.row].rowHeight , rowHeight > 0{
            returnRowHeight = rowHeight
        }else{
            if let conStatus = apiModel?.data?[indexPath.row].con_status {
                if conStatus == "2" || conStatus == "23"{
                    let containerHeight : CGFloat = 72//
                    let timeToTopMargin : CGFloat = 10//
                    let timeH : CGFloat = 22//
                    let containerToTimeMargin : CGFloat = 10//
                    let bottomH : CGFloat = 34//
                    return containerHeight + timeToTopMargin + timeH + containerToTimeMargin + bottomH
                }else{
                    var returnH : CGFloat = 0
                    let leftMargin : CGFloat = 20
                    let rightMargin : CGFloat = 20
                    let containerMaxWidth : CGFloat = SCREENWIDTH - leftMargin - rightMargin
                    let contentMaxWidth : CGFloat = containerMaxWidth - leftMargin * 2
                    let timeToTopMargin : CGFloat = 10
                    let containerToTimeMargin : CGFloat = 10
                    let labelToContainerBorderMargin : CGFloat = 10
                    let timeH :CGFloat = 22
                    let textContentSize = (apiModel?.data?[indexPath.row].content ?? "").sizeWith(font: UIFont.systemFont(ofSize: 17), maxWidth: contentMaxWidth)
                    returnH += timeToTopMargin
                    returnH += timeH
                    returnH += containerToTimeMargin
                    returnH += labelToContainerBorderMargin
                    returnH += labelToContainerBorderMargin
                    returnH += textContentSize.height
                    return returnH
                }
            }
        }
        return returnRowHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let model =  self.apiModel?.data?[indexPath.row] , let con_status = model.con_status{
            if con_status == "2" || con_status == "23"{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "DDTradeResultCell") as? DDTradeResultCell{
                    cell.model = model
                    return cell
                }else{
                    let cell   = DDTradeResultCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDTradeResultCell")
                    cell.model = model
                    return cell
                }
            }
        }
        
        var tempCell : DDMessageCell!
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDMessageCell") as? DDMessageCell{
            tempCell = cell
        }else{
            tempCell  = DDMessageCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDMessageCell")
        }
        tempCell.model  = self.apiModel?.data?[indexPath.row]
        return tempCell
    }
    
    func performActionBy(model:DDMessageContentModel)  {///考虑乙方id的情况(小订单)
        guard let type  = model.con_status else {
            return
        }
        switch type {
                 //类型    提示前置条件         提示内容                         跳转                            备注
        case "1"://好友    对方同意添加好友    对方同意添加您为好友                 好友资料页面—已添加好友
            self.navigationController?.pushVC(vcIdentifier: "DDPartnerDetailVC", userInfo: ["type":DDPartnerDetailVC.DDPartnerDetailFuncType.friendDetail , "id":model.attr?.uid ?? ""] )
            break
        case "2" ://好友    直接付款给好友          直接付款给好友：XX元（显示方式如图）"    交易记录
            self.navigationController?.pushVC(vcIdentifier: "TransactionInfoVC")
        case "23" ://好友    收到直接付款          收到好友付款：XX元（显示方式如图）"    交易记录
            self.navigationController?.pushVC(vcIdentifier: "TransactionInfoVC")
        case "3"://系统    收到添加好友请求    用户名请求添加您为好友                 好友资料页面-未加伙伴之前-收到
            self.navigationController?.pushVC(vcIdentifier: "DDPartnerDetailVC", userInfo: ["type":DDPartnerDetailVC.DDPartnerDetailFuncType.beAddFriend , "id":model.attr?.uid ?? ""] )
            
        case "4"://系统    对方拒绝添加好友    XXX拒绝了您的好友请求                   无跳转
            break
        case "5"://系统    充值成功           充值已成功，充值金额为XXX元             交易记录
            self.navigationController?.pushVC(vcIdentifier: "TransactionInfoVC")
        case "6"://系统    提现成功           您提现到银行卡（尾号0313）操作已成功，金额为XXX元    交易记录
            self.navigationController?.pushVC(vcIdentifier: "TransactionInfoVC")
        case "7"://系统    提现失败           提现失败，提现金额为XXX元，请核实信息或更换银行卡重试    交易记录
            self.navigationController?.pushVC(vcIdentifier: "TransactionInfoVC")
        case "8" , "9" , "10", "11" , "12","13" , "14","15","16", "17", "18" , "19","20","22":// 约定详情 
            jumpToAppointDetail(model:model)
        case "21"://约定    约定失效          您发布的约定已过期，如有需要请重新发布    无跳转
            break
        default:
            mylog("跳转类型con_status为\(model.con_status ?? "nil") , 跳转状况未知" )
        }
    }
    func jumpToAppointDetail(model:DDMessageContentModel)  {
        var bid = ""
        var yueType : String? = ""
        if model.attr?.user_type ?? "" == "1"{//当前为收款方
            yueType = "1"
            bid = DDAccount.share.id ?? (model.attr?.uid ?? "")
        }else{//当前为付款方
            bid = model.attr?.uid ?? (model.attr?.bid ?? "")
            yueType = model.attr?.yue_type
        }
        var para = ["orderID": model.attr?.order_id , "userType":model.attr?.user_type/* 2付款方 , 1收款方*/ , "privateOrPublic":model.attr?.type /*0私密约定,1公开*/ , "yue_type":yueType  /*1单约  2 群约*//*, "yiFangID":bid*/]
        if let userType = model.attr?.user_type , userType == "2" { // 收款方不要bid
            para["yiFangID"] = bid
        }
        self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: para)
    }
    ///金额有修改
    func moneyChanged(model:DDMessageContentModel){
        mylog("金额有修改")
//        var paySideID = ""
//        for model  in self.apiModel?.data?.items ?? [] {
//            if model.type == "3"{//付款人
//                paySideID = model.items?.first?.aid ?? ""
//            }
//        }
//        var bid = ""
//        for model  in self.apiModel?.data?.items ?? []{
//            if model.type ?? "" == "2"{
//                bid = model.items?.first?.bid ?? ""
//            }
//        }
//        if bid.count == 0 {
//            mylog("bid为空")
//            return
//        }
//        let temp = (self.apiModel?.data?.num ?? "1") > "1"  ? "2" : "1"
//        let mod_tag = "1"  // 已修改
//        self.navigationController?.pushVC(vcIdentifier: "DDPerformChangeMoneyVC", userInfo: ["orderid":self.orderID,"bid":bid , "type":temp, "mod_tag" : mod_tag, "appointment_id":self.apiModel?.data?.appointment_id ?? ""  , "aid" : paySideID])
//
    }

}
