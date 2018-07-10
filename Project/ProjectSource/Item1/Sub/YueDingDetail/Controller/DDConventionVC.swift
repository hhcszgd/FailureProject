//
//  DDConventionVC.swift
//  Project
//
//  Created by WY on 2018/1/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//约定详情
import UIKit
import Alamofire
private let bottomBarH : CGFloat = 40
class DDConventionVC: DDNormalVC {
    static let conventionVCMargin : CGFloat = 20
    var apiModel : ApiModel<DDAppointDetailModel>?
    var dataRequest : DataRequest?
    let tableHeader = DDConventionTableHeaderNew.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 44))
//    let tableFooter = DDConventionTableFooter.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 40))
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
    
    let bottomBar = DDActionSelectBar(frame: CGRect(x: 0, y: SCREENHEIGHT - DDSliderHeight - bottomBarH, width: SCREENWIDTH, height: 40))
    ///userType  2付款方 , 1收款方
    
    ///0私密 1公开
    var privateOrPublic = ""
    ///单人还是多人1 单人 , 2 多人
//    var oneOrMany = "1"
    
    ///(1:单，2：群)
    var yue_type : String?
    var orderID = ""
    deinit {
        self.dataRequest?.cancel()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "约定详情"
//        if let dict  = self.userInfo as? [String:String] , let orderid = dict["orderID"] {
//            orderID = orderid
//            if let tempYueType = dict["yue_type"]{
//                if tempYueType == "1"{
//                    self.title = "单人约定详情"
//                }else{
//                    self.title = "多人约定详情"
//                }
//            }
//        }
        self._addSubviews()
//        self.requestApi()
    }
    func _addSubviews() {
        self.view.addSubview(tableView)
        self.view.addSubview(bottomBar)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView = tableHeader
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("#f0f0f0")
        self.tableView.backgroundColor = self.view.backgroundColor
//        tableView.tableFooterView = tableFooter
//        tableFooter.addTarget(self , action: #selector(changeDataSource), for: UIControlEvents.touchUpInside)
        let tableViewH : CGFloat = self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : tableViewH)
        self.bottomBarAction()
        tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }
    @objc func addPayDetailButton()  {
        //        let buttonitem = UIBarButtonItem.init
        if self.navigationItem.rightBarButtonItem == nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"sbsbsbsb"), style: UIBarButtonItemStyle.plain, target: self , action: #selector(payDetailButtonAction(sender:)))
        }
    }
    
    @objc func payDetailButtonAction(sender:UIBarButtonItem)  {
        mylog("放款详情")
        if let dict  = self.userInfo as? [String:String] , let userType = dict["userType"] {
            if userType == "1"{//收款方
                payPartnerDetail()
            }else if userType == "2"{//付款方
                let joinCount = Int(self.apiModel?.data?.join_num ?? "0") ?? 0
                if joinCount > 1 {
                    payPartnersDetail()
                }else{
                    payPartnerDetail()
                }
            }
        }
        
    }
    
    
    
    func requestApi()  {
        
        var userType = "1"
        if let dict  = self.userInfo as? [String:String] , let orderid = dict["orderID"] {
            orderID = orderid
            if let tempYueType = dict["yue_type"]{
                yue_type = tempYueType
            }
            if let type = dict["userType"]{
                userType = type
            }
            var yiFangID : String?
            if let tempYifangID = dict["yiFangID"]{
                yiFangID = tempYifangID
            }
            
            if let privateOrPublic = dict["privateOrPublic"] {
                if privateOrPublic == "0"{//私密约定
                    self.privateOrPublic = "0"
//                    self.dataRequest = DDRequestManager.share.privateAppointDetailNew(type: ApiModel<DDAppointDetailModel>.self, order_id: orderID, user_type: userType, bid: yiFangID, success: { (model ) in
//                        if model.status  == 200{
//
//                            if let oldStatus = self.apiModel?.data?.status.or_st , let newStatus =  model.data?.status.or_st , oldStatus != newStatus {
//                                NotificationCenter.default.post(Notification(name: Notification.Name.init("AppointStatusChanged")))
//                            }
//                            self.apiModel = model
//                            self.apiModel?.data?.user_type = userType
//                            self.configTableView()
//                        }else{
//                            GDAlertView.alert(model.message, image: nil , time: 2 , complateBlock: nil)
//                        }
//                    }, failure: { (error ) in
//                        if !(error.localizedDescription == "已取消" || error.localizedDescription == "cancelled"){
//                            GDAlertView.alert(error.localizedDescription, image: nil , time: 2 , complateBlock: nil )
//                        }
//                    })
                    
                    self.dataRequest = DDRequestManager.share.privateAppointDetailNew(type: ApiModel<DDAppointDetailModel>.self, order_id: orderID, user_type: userType, bid: yiFangID, success: { (model ) in
                        if model.status  == 200{
                            
                            if let oldStatus = self.apiModel?.data?.status.or_st , let newStatus =  model.data?.status.or_st , oldStatus != newStatus {
                                DDNotification.postAppointChanged()
                            }
                            self.apiModel = model
                            self.apiModel?.data?.user_type = userType
                            self.configTableView()
                        }else{
                            GDAlertView.alert(model.message, image: nil , time: 2 , complateBlock: nil)
                        }
                    }, failure: { (error ) in
                        
                        DDErrorView.init(superView: self.view , error : error).automaticRemoveAfterActionHandle = {[weak self ] in
                            self?.requestApi()
                        }
//                        if !(error.localizedDescription == "已取消" || error.localizedDescription == "cancelled"){
//                            GDAlertView.alert(error.localizedDescription, image: nil , time: 2 , complateBlock: nil )
//                        }
//                        self.requestFailure?(DDError.networkError , {
//                            print("click")
//                        })
                    })
//                    self.dataRequest?.cancel()
                    
                }else if privateOrPublic == "1"{//公开约定
                    self.privateOrPublic = "1"

                    self.dataRequest = DDRequestManager.share.publicAppointDetailNew(type: ApiModel<DDAppointDetailModel>.self, order_id: orderID, user_type: userType, bid: yiFangID, success: { (model ) in
                        if model.status  == 200{
                            
                            if let oldStatus = self.apiModel?.data?.status.or_st , let newStatus =  model.data?.status.or_st , oldStatus != newStatus {
                                DDNotification.postAppointChanged()
                            }
                            self.apiModel = model
                            self.configTableView()
                        }else{
                            GDAlertView.alert(model.message, image: nil , time: 2 , complateBlock: nil)
                        }
                    }, failure: { (error ) in
                        
                        if !(error.localizedDescription == "已取消" || error.localizedDescription == "canceled"){
                            GDAlertView.alert(error.localizedDescription, image: nil , time: 2 , complateBlock: nil )
                        }
                    })
                
                    
                }else{
                    mylog("缺少公开或私密约定标识")
                    self.privateOrPublic = "0"
                    DDRequestManager.share.privateAppointDetail(type: ApiModel<DDAppointDetailModel>.self, order_id: orderID, user_type: userType) { (model ) in
                        self.apiModel = model
                        self.apiModel?.data?.user_type = userType
                        self.configTableView()
                    }
                }
            }else{mylog("缺少公开或私密约定标识")}
        }else{mylog("缺少控制器关键参数")}
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    
    func requestApi()  {

        var userType = "1"
        if let dict  = self.userInfo as? [String:String] , let orderid = dict["orderID"] {
            orderID = orderid
            if let tempYueType = dict["yue_type"]{
                yue_type = tempYueType
            }
            if let type = dict["userType"]{
                userType = type
            }
            var yiFangID : String?
            if let tempYifangID = dict["yiFangID"]{
                yiFangID = tempYifangID
            }
            
            if let privateOrPublic = dict["privateOrPublic"] {
                if privateOrPublic == "0"{//私密约定
                    self.privateOrPublic = "0"
                    DDRequestManager.share.privateAppointDetail(type: ApiModel<DDAppointDetailModel>.self, order_id: orderID, user_type: userType , bid: yiFangID) { (model ) in
                        if model?.status ?? 0 == 200{
                            
                            if let oldStatus = self.apiModel?.data?.status.or_st , let newStatus =  model?.data?.status.or_st , oldStatus != newStatus {
                                NotificationCenter.default.post(Notification(name: Notification.Name.init("AppointStatusChanged")))
                            }
                            
                            if let tempYueType = self.apiModel?.data?.yue_type{
                                //                            if tempYueType == "1"{
                                //                                self.title = "单人约定详情"
                                //                            }else{
                                //                                self.title = "多人约定详情"
                                //                            }
                            }
                            
                            self.apiModel = model
                            self.apiModel?.data?.user_type = userType
                            self.configTableView()
                        }else{
                            GDAlertView.alert(model?.message, image: nil , time: 2 , complateBlock: nil)
                        }
                    }
                }else if privateOrPublic == "1"{//公开约定
                    self.privateOrPublic = "1"
//                    DDRequestManager.share.publicAppointDetail(type: ApiModel<DDAppointDetailModel>.self, order_id: orderID, user_type: userType) { (model ) in
//                        if let oldStatus = self.apiModel?.data?.status.or_st , let newStatus =  model?.data?.status.or_st , oldStatus != newStatus {
//                            NotificationCenter.default.post(Notification(name: Notification.Name.init("AppointStatusChanged")))
//                        }
//                        self.apiModel = model
//                        self.apiModel?.data?.userType = userType
//                        self.configTableView()
//                    }
                    //notice  : public appoint need't userType
                    DDRequestManager.share.publicAppointDetail(type: ApiModel<DDAppointDetailModel>.self, order_id: orderID, user_type: userType , bid : yiFangID) { (model ) in
                        if model?.status ?? 0 == 200{
                            
                            if let oldStatus = self.apiModel?.data?.status.or_st , let newStatus =  model?.data?.status.or_st , oldStatus != newStatus {
                                NotificationCenter.default.post(Notification(name: Notification.Name.init("AppointStatusChanged")))
                            }
                            if let tempYueType = self.apiModel?.data?.yue_type{
                                //                            if tempYueType == "1"{
                                //                                self.title = "单人约定详情"
                                //                            }else{
                                //                                self.title = "多人约定详情"
                                //                            }
                            }
                            self.apiModel = model
                            self.configTableView()
                        }else{
                            GDAlertView.alert(model?.message, image: nil , time: 2 , complateBlock: nil)
                        }
                    }
                    
                }else{
                    mylog("缺少公开或私密约定标识")
                    self.privateOrPublic = "0"
                    DDRequestManager.share.privateAppointDetail(type: ApiModel<DDAppointDetailModel>.self, order_id: orderID, user_type: userType) { (model ) in
                        self.apiModel = model
                        self.apiModel?.data?.user_type = userType
                        self.configTableView()
                    }
                }
            }else{mylog("缺少公开或私密约定标识")}
        }else{mylog("缺少控制器关键参数")}
    }
*/
    
    func configTableView() {
        mylog(self.tableView)
        self.tableHeader.yue_type = yue_type
        self.tableHeader.model = self.apiModel
        configTopAndBottomView()
        if self.apiModel?.data?.status.or_kg ?? "" != "1" {
            if privateOrPublic == "1"{ //公开约定
                if self.apiModel?.data?.join ?? "" != "2"{
                    addPayDetailButton()
                }
            }else{
                addPayDetailButton()
                
            }
        }
        self.tableView.reloadData()
    }
    @objc func changeDataSource() {
        mylog("message")
        self.navigationController?.pushVC(vcIdentifier: "DDEarnerListVC", userInfo: nil)
    }
}

// MARK: - set every status
extension DDConventionVC{
    func configTopAndBottomViewWhenEarnSide(buttonIndex:Int? = nil )  {//收款方 (全部是单约)
        if self.privateOrPublic == "1"{//公开
//            if let lendersType =   self.apiModel?.data?.lenders {//这个字段不再判断了
            if true{
//                if lendersType == "1"{//手动   // 公开约定不分手动和自动放款 , 所以这个字段不做判断 了
                if true {//手动   // 公开约定不分手动和自动放款 , 所以这个字段不做判断 了
                    switch (self.apiModel?.data?.status.or_st ?? "") {
                    case "0"://待付款
                        bottomBar.actionTitleArr = [String]()
                        break
                    case "1"://招人中(意味着没有加入)
                        if self.apiModel?.data?.status.or_kg ?? "" == "1"{
                            
                            if let _ = buttonIndex{
                                //perfor action
                                self.addAppoint()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["加入约定"  ]
                            bottomBar.colors = [ UIColor.DDThemeColor]
                            
                        }
                    case "2"://约定进行中
                        
                        if self.apiModel?.data?.status.or_kg ?? "" == "1"{
                            
                            //layout view
                            bottomBar.actionTitleArr = [String]()
                            return
                        }
                        
                        if self.apiModel?.data?.status.or_xg ?? "" == "0"{//金额无修改
                            
                        }else if self.apiModel?.data?.status.or_xg ?? "" == "1"{//金额有修改
                            if let index = buttonIndex{//
                                //perfor action
                                if index == 1{
                                    self.moneyChanged()
                                }else if index == 2 {
                                    self.endAppoint()
                                }
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["报酬有修改","终止约定" ]
                            bottomBar.colors = [ UIColor.DDThemeColor ,UIColor.DDThemeColor]
                            return
                        }
                        
                        if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                            
                        }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                            if let _ = buttonIndex{//
                                //perfor action
                                consultDetail()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["协商详情" ] //收款方的协商详情就是详情
                            bottomBar.colors = [ UIColor.DDThemeColor ]
                            return
                        }
                        ///正常约定详情
                        if let index = buttonIndex{//
                            //perfor action
                            if index == 1{
                                self.endAppoint()
                            }
                            return
                        }
                        //layout view
                        bottomBar.actionTitleArr = ["终止约定" ]
                        bottomBar.colors = [UIColor.DDThemeColor]
                    case "3"://约定进行中-有协商
                        if let _ = buttonIndex{//
                            //perfor action
                            consultDetail()
                            return
                        }
                        //layout view
                        bottomBar.actionTitleArr = ["协商详情" ]
                        bottomBar.colors = [ UIColor.DDThemeColor ]
                        return
                    case "5"://已完成
//                        if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
//
//                        }else
                        if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                            if let index = buttonIndex{//
                                //perfor action
                                if index == 1 {
                                    payPartnerDetail()
                                }else{
                                    consultDetail()
                                }
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["报酬详情","协商详情" ]
                            bottomBar.colors = [ UIColor.DDThemeColor,UIColor.DDThemeColor ]
                            return
                        }else {
                            if let _ = buttonIndex{//
                                //perfor action
                                    payPartnerDetail()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["报酬详情" ]
                            bottomBar.colors = [ UIColor.DDThemeColor]
                            return
                        }
                        case "7"://已完成
                        mylog("已失效")
                    default:
                        break
                    }
//                }else if lendersType == "2" {//自动(收款方的公开约定没有自动放款)
                    
                }
            }else{mylog("手动或自动放款 不明确")}
            
        }else if self.privateOrPublic == "0" {//私密
            if let lendersType =   self.apiModel?.data?.lenders {
                if lendersType == "1"{//手动
                    switch (self.apiModel?.data?.status.or_st ?? "") {
                    case "0"://待付款
                        bottomBar.actionTitleArr = [String]()
                        break
                    case "1"://招人中(意味着没有加入)
                        if let _ = buttonIndex{
                            //perfor action
                            self.addAppoint()
                            return
                        }
                        if self.apiModel?.data?.status.or_kg ?? "" == "1"{//未开工
                            //layout view
                            bottomBar.actionTitleArr = ["加入约定"  ]
                            bottomBar.colors = [ UIColor.DDThemeColor]
                            
                        }
                    case "2"://约定进行中
                        if self.apiModel?.data?.status.or_kg ?? "" == "1"{
                            
                            //layout view
                            bottomBar.actionTitleArr = [String]()
                            return
                        }
                        
                        if self.apiModel?.data?.status.or_xg ?? "" == "0"{//金额无修改
                            
                        }else if self.apiModel?.data?.status.or_xg ?? "" == "1"{//金额有修改
                            if let index = buttonIndex{//
                                //perfor action
                                if index == 1{
                                    self.moneyChanged()
                                }else if index == 2 {
                                    self.endAppoint()
                                }
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["报酬有修改","终止约定" ]
                            bottomBar.colors = [ UIColor.DDThemeColor ,UIColor.DDThemeColor]
                            return
                        }
                        
                        if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                            
                        }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                            if let _ = buttonIndex{//
                                //perfor action
                                consultDetail()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["协商详情" ]
                            bottomBar.colors = [ UIColor.DDThemeColor ]
                            return
                        }
                        ///正常约定详情
                        if let index = buttonIndex{//
                            //perfor action
                            if index == 1{
                                self.endAppoint()
                            }
                            return
                        }
                        //layout view
                        bottomBar.actionTitleArr = ["终止约定" ]
                        bottomBar.colors = [UIColor.DDThemeColor]
                    case "3"://约定进行中-有协商
                        if let _ = buttonIndex{//
                            //perfor action
                            consultDetail()
                            return
                        }
                        //layout view
                        bottomBar.actionTitleArr = ["协商详情" ]
                        bottomBar.colors = [ UIColor.DDThemeColor ]
                        return
                    case "5"://已完成
                        if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                            if let index = buttonIndex{//
                                //perfor action
                                if index == 1 {
                                    consultDetail()
                                }else{
                                    payPartnerDetail()
                                }
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["协商详情","报酬详情" ]
                            bottomBar.colors = [ UIColor.DDThemeColor,UIColor.DDThemeColor ]
                            return
                        }else {
                            if let _ = buttonIndex{//
                                //perfor action
                                payPartnerDetail()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["报酬详情" ]
                            bottomBar.colors = [ UIColor.DDThemeColor]
                            return
                        }
                    case "7"://已完成
                        mylog("已失效")
                    default:
                        break
                    }
                }else if lendersType == "2" {//自动
                    switch (self.apiModel?.data?.status.or_st ?? "") {
                    case "0"://待付款
                        bottomBar.actionTitleArr = [String]()
                        break
                    case "1"://招人中(意味着没有加入)
                        if let _ = buttonIndex{
                            //perfor action
                            self.addAppoint()
                            return
                        }
                        if self.apiModel?.data?.status.or_kg ?? "" == "1"{//未开工
                            //layout view
                            bottomBar.actionTitleArr = ["加入约定"  ]
                            bottomBar.colors = [ UIColor.DDThemeColor]
                            
                        }
                    case "2"://约定进行中
                        if self.apiModel?.data?.status.or_kg ?? "" == "1"{
                            
                            //layout view
                            bottomBar.actionTitleArr = [String]()
                            return
                        }
                        
                        if self.apiModel?.data?.status.or_xg ?? "" == "0"{//金额无修改
                            
                        }else if self.apiModel?.data?.status.or_xg ?? "" == "1"{//金额有修改
                            if let index = buttonIndex{//
                                //perfor action
                                if index == 1{
                                    self.moneyChanged()
                                }else if index == 2 {
                                    self.endAppoint()
                                }
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["报酬有修改","终止约定" ]
                            bottomBar.colors = [ UIColor.DDThemeColor ,UIColor.DDThemeColor]
                            return
                        }
                        
                        if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                            
                        }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                            if let _ = buttonIndex{//
                                //perfor action
                                consultDetail()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["协商详情" ]
                            bottomBar.colors = [ UIColor.DDThemeColor ]
                            return
                        }
                        ///正常约定详情
                        if let index = buttonIndex{//
                            //perfor action
                            if index == 1{
                                self.endAppoint()
                            }
                            return
                        }
                        //layout view
                        bottomBar.actionTitleArr = ["终止约定" ]
                        bottomBar.colors = [UIColor.DDThemeColor]
                    case "3"://约定进行中-有协商
                        if let _ = buttonIndex{//
                            //perfor action
                            consultDetail()
                            return
                        }
                        //layout view
                        bottomBar.actionTitleArr = ["协商详情" ]
                        bottomBar.colors = [ UIColor.DDThemeColor ]
                        return
                    case "5"://已完成
                        if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                            if let index = buttonIndex{//
                                //perfor action
                                if index == 1 {
                                    consultDetail()
                                }else{
                                    payPartnerDetail()
                                }
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["协商详情" ,"报酬详情"]
                            bottomBar.colors = [ UIColor.DDThemeColor,UIColor.DDThemeColor ]
                            return
                        }else {
                            if let _ = buttonIndex{//
                                //perfor action
                                payPartnerDetail()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["报酬详情" ]
                            bottomBar.colors = [ UIColor.DDThemeColor]
                            return
                        }
                    case "7"://已完成
                        mylog("已失效")
                    default:
                        break
                    }
                }
            }else{mylog("手动或自动放款 不明确")}
        }else{mylog("公开或非公开 不明确")}
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func configTopAndBottomViewWhenPaySide(buttonIndex:Int? = nil )  {//付款方
        if self.privateOrPublic == "1"{//公开
//            if let lendersType =   self.apiModel?.data?.lenders {
            if true {//公开约定不分手动和自动放款 , 所以这个字段不做判断 了 , 始终执行一套逻辑
//                if lendersType == "1"{//手动  // 公开约定不分手动和自动放款 , 所以这个字段不做判断 了
                if true {// 公开约定不分手动和自动放款 , 所以这个字段不做判断 了 , 始终执行一套逻辑
                    if yue_type ?? "" == "1"{//单约*****************
                        switch (self.apiModel?.data?.status.or_st ?? "") {
                        case "0"://待付款
                            if let _ = buttonIndex{//只有一个按钮
                                //perfor action
                                self.payOrder()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["付款" ]
                            bottomBar.colors = [ UIColor.DDThemeColor]
                         case "1"://找人中
                            bottomBar.actionTitleArr = [String]()
                            
                            break
                        case "2"://进行中
                            if self.apiModel?.data?.status.or_kg ?? "" == "1"{
                                
                                //layout view
                                bottomBar.actionTitleArr = [String]()
                                return
                            }
                            
                                if self.apiModel?.data?.status.or_xg ?? "" == "0"{//金额无修改
                                    
                                }else if self.apiModel?.data?.status.or_xg ?? "" == "1"{//金额有修改
                                    ///正常约定详情
                                    if let index = buttonIndex{//
                                        //perfor action
                                        if index == 1{
                                            self.endAppoint()
                                        }else if index == 2 {
                                            self.moneyChanged()
                                        }else if index == 3{
                                            self.payPartner()
                                        }
                                        return
                                    }
                                    //layout view
                                    bottomBar.actionTitleArr = ["终止约定","报酬有修改","放款" ]
                                    bottomBar.colors = [UIColor.DDThemeColor , UIColor.DDThemeColor ,UIColor.DDThemeColor]
                                    
                                    return
                                }
                                
                                if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                                    
                                }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                                    if let index = buttonIndex{//
                                        //perfor action
                                        if index == 1{
                                            self.consultDetail()
                                        }
                                        return
                                    }
                                    //layout view
                                    bottomBar.actionTitleArr = ["协商详情"]
                                    bottomBar.colors = [ UIColor.DDThemeColor ,UIColor.DDThemeColor]
                                    return
                                }
                                ///正常约定详情
                                if let index = buttonIndex{//
                                    //perfor action
                                    if index == 1{
                                        self.endAppoint()
                                    }else if index == 2 {
                                        self.changeAppoint()
                                    }else if index == 3{
                                        self.payPartner()
                                        
                                    }
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["终止约定","修改报酬","放款" ]
                                bottomBar.colors = [UIColor.DDThemeColor,UIColor.DDThemeColor,UIColor.DDThemeColor]
                            
                            
                        case "3"://进行中-有协商
                            if let index = buttonIndex{//
                                //perfor action
                                if index == 1 {
                                    consultDetail()
                                }
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["协商详情" ]
                            bottomBar.colors = [ UIColor.DDThemeColor]
                            return
                        case "5"://已完成
                            if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                                if let index = buttonIndex{//
                                    //perfor action
                                    if index == 1 {
                                        consultDetail()
                                    }else{
                                        payPartnerDetail()
                                    }
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["协商详情" , "报酬详情"]
                                bottomBar.colors = [ UIColor.DDThemeColor,UIColor.DDThemeColor ]
                                return
                            }else {
                                if let _ = buttonIndex{//
                                    //perfor action
                                    payPartnerDetail()
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["报酬详情" ]
                                bottomBar.colors = [ UIColor.DDThemeColor]
                                return
                            }
                        case "7"://已完成
                            mylog("已失效")
                        default:
                            break
                        }
                    }else if  yue_type ?? "" == "2"{//群约
                        
                        
                        
                        switch (self.apiModel?.data?.status.or_st ?? "") {
                        case "0"://待付款
                            if let _ = buttonIndex{//只有一个按钮
                                //perfor action
                                self.payOrder()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["付款" ]
                            bottomBar.colors = [ UIColor.DDThemeColor]
                        case "1"://进行中
                            
                            if self.apiModel?.data?.status.a_start == "0" {//随时开始
                                
                            }else if self.apiModel?.data?.status.a_start == "1"{//人满开始
                                if self.apiModel?.data?.status.or_kg ?? "" == "1"{//未开工
                                    ///正常约定详情
//                                    if let index = buttonIndex{//
//                                        //perfor action
//                                        if index == 1{
//                                            self.startWork()
//                                        }
//                                        return
//                                    }
//                                    //layout view
//                                    bottomBar.actionTitleArr = ["开工" ]
//                                    bottomBar.colors = [ UIColor.DDThemeColor]
//                                    return
                                    if Int(self.apiModel?.data?.join_num ?? "") ?? 0 > 0{
                                        if let index = buttonIndex{//
                                            //perfor action
                                            if index == 1{
                                                self.startWork()
                                            }
                                            return
                                        }
                                        //layout view
                                        bottomBar.actionTitleArr = ["开工" ]
                                        bottomBar.colors = [ UIColor.DDThemeColor]
                                    }
                                    
                                    return
                                }
                            }
                            
                            
                            if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                                bottomBar.actionTitleArr = [String]()
                            }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
//                                if let index = buttonIndex{//
//                                    //perfor action
//                                    consultList()
//                                    return
//                                }
//                                //layout view
//                                bottomBar.actionTitleArr = ["协商详情" ]//群约的协商管理跳列表
//                                bottomBar.colors = [ UIColor.DDThemeColor ]
//                                return
                                bottomBar.actionTitleArr = [String]()
                            }
                            if Int(self.apiModel?.data?.join_num ?? "") ?? 0 == 1 { // 已加入人数
                                ///正常约定详情
                                if let index = buttonIndex{//
                                    //perfor action
                                    if index == 1{
                                        self.payPartner()
                                    }
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["放款" ]
                                bottomBar.colors = [ UIColor.DDThemeColor]
                            }else if Int(self.apiModel?.data?.join_num ?? "") ?? 0 > 1 { // 已加入人数
                                ///正常约定详情
                                if let index = buttonIndex{//
                                    //perfor action
                                    if index == 1{
                                        self.payPartners()
                                    }
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["一键放款" ]
                                bottomBar.colors = [ UIColor.DDThemeColor]
                            }else{
                                bottomBar.actionTitleArr = [String]()
                            }
                            
                            
                            
                           
                        case "-1"://已完成
                            if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                                
                            }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                                if let index = buttonIndex{//
                                    
                                    //perfor action
                                    if index == 1 {
                                        payPartnersDetail()
                                    }
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["报酬详情" ]//
                                bottomBar.colors = [ UIColor.DDThemeColor ]
                                return
                            }
//                            else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
//                                if let index = buttonIndex{//
//
//                                    //perfor action
//                                    if index == 1 {
//                                        consultList()
//
//                                    }else if index == 2{
//                                        payPartnersDetail()
//                                    }
//                                    return
//                                }
//                                //layout view
//                                bottomBar.actionTitleArr = ["协商详情" , "放款详情" ]//群约的协商管理跳列表
//                                bottomBar.colors = [ UIColor.DDThemeColor ,UIColor.DDThemeColor]
//                                return
//                            }
                            
                            if let _ = buttonIndex{//
                                
//                                    consultList()
                                payPartnersDetail()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = [ "报酬详情" ]//
                            bottomBar.colors = [ UIColor.DDThemeColor ]
                        case "7"://已完成
                            mylog("已失效")
                        default:
                            break
                        }
                    }
                    
                    
                    
//                }else if lendersType == "2" {//自动{公开约定暂无自动放款} /////////自动放款无 放款 按钮
//                    mylog("公开约定暂无自动放款")
                    /*
                    switch (self.apiModel?.data?.status.or_st ?? "") {
                    case "0"://待付款
                        if let index = buttonIndex{//只有一个按钮
                            //perfor action
                            self.payOrder()
                            return
                        }
                        //layout view
                        bottomBar.actionTitleArr = ["付款" ]
                        bottomBar.colors = [ UIColor.DDThemeColor]
                    case "1"://进行中
                        if self.apiModel?.data?.status.or_xg ?? "" == "0"{//金额无修改
                            
                        }else if self.apiModel?.data?.status.or_xg ?? "" == "1"{//金额有修改
                            if let index = buttonIndex{//
                                //perfor action
                                if index == 1{
                                    self.moneyChanged()
                                }else if index == 2 {
                                    self.changeAppoint()
                                }
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["金额有修改","修改约定" ]
                            bottomBar.colors = [ UIColor.DDThemeColor ,UIColor.black]
                            return
                        }
                        
                        if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                            
                        }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                            if let index = buttonIndex{//
                                //perfor action
                                consultDetail()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["协商详情" ]
                            bottomBar.colors = [ UIColor.DDThemeColor ]
                            return
                        }
                        ///正常约定详情
                        if let index = buttonIndex{//
                            //perfor action
                            if index == 1{
                                self.changeAppoint()
                            }else if index == 2 {
                                self.payPartner()
                            }
                            return
                        }
                        //layout view
                        bottomBar.actionTitleArr = ["修改约定","放款" ]
                        bottomBar.colors = [ UIColor.black ,UIColor.DDThemeColor]
                        
                    case "-1"://已完成
                        if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                            
                        }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                            if let index = buttonIndex{//
                                //perfor action
                                consultDetail()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["协商详情" ]
                            bottomBar.colors = [ UIColor.DDThemeColor ]
                            return
                        }
                    default:
                        mylog("约定状态 不明确")
                        break
                    }
                    
                    */
                }
            }else{mylog("手动或自动放款 不明确")}
            
        }else   if self.privateOrPublic == "0" {//私密
            if let lendersType =   self.apiModel?.data?.lenders {
                if lendersType == "1"{//手动
                    if yue_type ?? "" == "1"{//单约*****************
                        switch (self.apiModel?.data?.status.or_st ?? "") {
                        case "0"://待付款
                            if let _ = buttonIndex{//只有一个按钮
                                //perfor action
                                self.payOrder()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["付款" ]
                            bottomBar.colors = [ UIColor.DDThemeColor]
                        case "1"://找人中
                            bottomBar.actionTitleArr = [String]()
                            
                        case "2"://进行中
                            if self.apiModel?.data?.status.or_kg ?? "" == "1"{
                                
                                //layout view
                                bottomBar.actionTitleArr = [String]()
                                return
                            }
                            
                            if self.apiModel?.data?.status.or_xg ?? "" == "0"{//金额无修改
                                
                            }else if self.apiModel?.data?.status.or_xg ?? "" == "1"{//金额有修改
                                ///正常约定详情
                                if let index = buttonIndex{//
                                    //perfor action
                                    if index == 1{
                                        self.endAppoint()
                                    }else if index == 2 {
                                        self.moneyChanged()
                                    }else if index == 3{
                                        self.payPartner()
                                    }
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["终止约定","报酬有修改","放款" ]
                                bottomBar.colors = [UIColor.DDThemeColor , UIColor.DDThemeColor ,UIColor.DDThemeColor]
                                
                                return
                            }
                            bottomBar.actionTitleArr = [String]()
                            if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                                
                            }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                                if let _ = buttonIndex{//
                                    //perfor action
                                    consultDetail()
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["协商详情" ]
                                bottomBar.colors = [ UIColor.DDThemeColor ]
                                return
                            }
                            ///正常约定详情
                            if let index = buttonIndex{//
                                //perfor action
                                if index == 1{
                                    self.endAppoint()
                                }else if index == 2 {
                                    self.changeAppoint()
                                }else if index == 3{
                                    self.payPartner()
                                    
                                }
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["终止约定","修改报酬","放款" ]
                            bottomBar.colors = [UIColor.DDThemeColor,UIColor.DDThemeColor,UIColor.DDThemeColor]
                            
                            
                        case "3"://进行中-有协商
                            if let index = buttonIndex{//
                                //perfor action
                                if index == 1 {
                                    consultDetail()
                                }
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["协商详情" ]
                            bottomBar.colors = [ UIColor.DDThemeColor  ]
                            return
                        case "5"://已完成
                            if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                                if let index = buttonIndex{//
                                    if index == 1 {
                                        consultDetail()
                                        
                                    }else if index == 2{
                                        payPartnerDetail()
                                    }
                                    //perfor action
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["协商详情" , "报酬详情"]
                                bottomBar.colors = [ UIColor.DDThemeColor , UIColor.DDThemeColor ]
                                return
                            }
                            
                            if let _ = buttonIndex{//
                                //perfor action
                                    payPartnerDetail()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["报酬详情" ]
                            bottomBar.colors = [UIColor.DDThemeColor ]
                        case "7"://已完成
                            mylog("已失效")
                        default:
                            break
                        }
                    }else if  yue_type ?? "" == "2"{//群约
                        
                        switch (self.apiModel?.data?.status.or_st ?? "") {
                        case "0"://待付款
                            if let _ = buttonIndex{//只有一个按钮
                                //perfor action
                                self.payOrder()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["付款" ]
                            bottomBar.colors = [ UIColor.DDThemeColor]
                        case "1"://进行中
                            
                            if self.apiModel?.data?.status.or_kg ?? "" == "1"{
                                ///正常约定详情
                                
                                if Int(self.apiModel?.data?.join_num ?? "") ?? 0 > 0{
                                    if let index = buttonIndex{//
                                        //perfor action
                                        if index == 1{
                                            self.startWork()
                                        }
                                        return
                                    }
                                    //layout view
                                    bottomBar.actionTitleArr = ["开工" ]
                                    bottomBar.colors = [ UIColor.DDThemeColor]
                                }else{
                                    bottomBar.actionTitleArr = [String]()
                                }
                                
                                return
                            }
                            ///付款方看群约 , 不应该显示协商信息
                            /*
                            if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                                
                            }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                                if let _ = buttonIndex{//
                                    //perfor action
                                    consultList()
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["协商详情" ]//群约的协商管理跳列表
                                bottomBar.colors = [ UIColor.DDThemeColor ]
                                return
                            }
                            
                            */
                            ///正常约定详情
                            if let index = buttonIndex{//
                                //perfor action
                                if index == 1{
                                    self.payPartners()
                                }
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["一键放款" ]
                            bottomBar.colors = [UIColor.DDThemeColor]
                            
                        case "-1"://已完成
                            
                            if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                                
                            }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                                if let index = buttonIndex{//
                                    //perfor action
                                    if index == 1 {
                                        payPartnersDetail()
                                    }
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["报酬详情" ]//群约的协商管理跳列表
                                bottomBar.colors = [  UIColor.DDThemeColor ]
                                return
                            }
//                            else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
//                                if let index = buttonIndex{//
//                                    //perfor action
//                                    if index == 1 {
//                                        consultList()
//                                    }else{
//                                        payPartnersDetail()
//                                    }
//                                    return
//                                }
//                                //layout view
//                                bottomBar.actionTitleArr = ["协商详情" , "放款详情" ]//群约的协商管理跳列表
//                                bottomBar.colors = [ UIColor.DDThemeColor ,  UIColor.DDThemeColor ]
//                                return
//                            }
                            if let _ = buttonIndex{//
                                //perfor action
                                payPartnersDetail()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["报酬详情" ]//群约的协商管理跳列表
                            bottomBar.colors = [ UIColor.DDThemeColor ]
                            return
                        case "7"://已完成
                            mylog("已失效")
                        default:
                            break
                        }
                    }
                    
                }else if lendersType == "2" {//自动
                    if yue_type ?? "" == "1"{//单约*****************
                        switch (self.apiModel?.data?.status.or_st ?? "") {
                        case "0"://待付款
                            if let _ = buttonIndex{//只有一个按钮
                                //perfor action
                                self.payOrder()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["付款" ]
                            bottomBar.colors = [ UIColor.DDThemeColor]
                        case "1"://找人中
                            bottomBar.actionTitleArr = [String]()
                            
                            
                        case "2"://进行中
                            
                            if self.apiModel?.data?.status.or_xg ?? "" == "0"{//金额无修改
                                
                            }else if self.apiModel?.data?.status.or_xg ?? "" == "1"{//金额有修改
                                if let index = buttonIndex{//
                                    //perfor action
                                    if index == 1{
                                        self.moneyChanged()
                                    }else if index == 2 {
                                        self.endAppoint()
                                    }
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["报酬有修改","终止约定" ]
                                bottomBar.colors = [ UIColor.DDThemeColor,UIColor.DDThemeColor]
                                return
                            }
                            
                            if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                                
                            }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                                if let _ = buttonIndex{//
                                    //perfor action
                                    consultDetail()
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["协商详情" ]//单约协商详情
                                bottomBar.colors = [ UIColor.DDThemeColor ]
                                return
                            }
                            ///正常约定详情
                            if let index = buttonIndex{//
                                //perfor action
                                if index == 1{
                                    self.endAppoint()
                                }else if index == 2 {
                                    self.changeAppoint()
                                }
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["终止约定","修改报酬" ] // 修改约定 ==? 修改金额
                            bottomBar.colors = [ UIColor.DDThemeColor ,UIColor.DDThemeColor]
                            
                            
                        case "3"://进行中-有协商
                            if let _ = buttonIndex{//
                                //perfor action
                                consultDetail()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["协商详情" ]
                            bottomBar.colors = [ UIColor.DDThemeColor ]
                            return
                        case "5"://已完成
                            if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                                if let index = buttonIndex{//
                                    //perfor action
                                    if index == 1 {
                                        consultDetail()
                                    }else if index == 2{
                                        payPartnerDetail()
                                    }
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = ["协商详情" , "报酬详情" ]//单约协商详情
                                bottomBar.colors = [ UIColor.DDThemeColor , UIColor.DDThemeColor]
                                return
                            }else{
                                if let _ = buttonIndex{//
                                    //perfor action
                                    payPartnerDetail()
                                    return
                                }
                                
                                bottomBar.actionTitleArr = ["报酬详情" ]//单约协商详情
                                bottomBar.colors = [ UIColor.DDThemeColor ]
                            }
                        case "7"://已完成
                            mylog("已失效")
                        default:
                            break
                        }
                    }else if  yue_type ?? "" == "2"{//群约
                        switch (self.apiModel?.data?.status.or_st ?? "") {
                        case "0"://待付款
                            if let _ = buttonIndex{//只有一个按钮
                                //perfor action
                                self.payOrder()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = ["付款" ]
                            bottomBar.colors = [ UIColor.DDThemeColor]
                        case "1"://进行中
                            
                            if self.apiModel?.data?.status.or_kg ?? "" == "2"{//已开工
                                
                            }else if self.apiModel?.data?.status.or_kg ?? "" == "1"{//未开工
//                                if let index = buttonIndex{//
//                                    //perfor action
//                                    startWork()
//                                    return
//                                }
//                                //layout view
//                                bottomBar.actionTitleArr = ["开工" ]//群约的协商管理跳列表
//                                bottomBar.colors = [ UIColor.DDThemeColor ]
//                                return
                                if Int(self.apiModel?.data?.join_num ?? "") ?? 0 > 0{
                                    if let index = buttonIndex{//
                                        //perfor action
                                        if index == 1{
                                            self.startWork()
                                        }
                                        return
                                    }
                                    //layout view
                                    bottomBar.actionTitleArr = ["开工" ]
                                    bottomBar.colors = [ UIColor.DDThemeColor]
                                }
                                
                                return
                            }
                            
                            if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                                
                            }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
//                                if let index = buttonIndex{//
//                                    //perfor action
//                                    consultList()
//                                    return
//                                }
//                                //layout view
//                                bottomBar.actionTitleArr = ["协商详情" ]//群约的协商管理跳列表
//                                bottomBar.colors = [ UIColor.DDThemeColor ]
//                                return
                            }
                        case "-1"://已完成
                            if self.apiModel?.data?.status.or_jf ?? "" == "0"{//无纠纷
                                
                            }else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
                                if let index = buttonIndex{//
                                    //perfor action
                                    if  index == 1 {
//                                        consultList()
                                        payPartnersDetail()
                                    }
                                    return
                                }
                                //layout view
                                bottomBar.actionTitleArr = [ "报酬详情"]//群约的协商管理跳列表
                                bottomBar.colors = [  UIColor.DDThemeColor]
                                return
                            }
//                            else if self.apiModel?.data?.status.or_jf ?? "" == "1"{//有纠纷
//                                if let index = buttonIndex{//
//                                    //perfor action
//                                    if  index == 1 {
//                                        consultList()
//
//                                    }else if index == 2 {
//                                        payPartnersDetail()
//                                    }
//                                    return
//                                }
//                                //layout view
//                                bottomBar.actionTitleArr = ["协商详情" , "放款详情"]//群约的协商管理跳列表
//                                bottomBar.colors = [ UIColor.DDThemeColor , UIColor.DDThemeColor]
//                                return
//                            }
                            if let _ = buttonIndex{//
                                //perfor action
                                    payPartnersDetail()
                                return
                            }
                            //layout view
                            bottomBar.actionTitleArr = [ "报酬详情"]//群约的协商管理跳列表
                            bottomBar.colors = [  UIColor.DDThemeColor]
                        case "7"://已完成
                            mylog("已失效")
                        default:
                            break
                        }
                    }
                    
                    
                }
            }else{mylog("手动或自动放款 不明确")}
        }else{mylog("公开或非公开 不明确")}
        
    }
    
    
    
    
    func configTopAndBottomView(buttonIndex:Int? = nil )  {
//        if let userType = self.apiModel?.data?.user_type{//公开约定是 user_type不准
//            if userType == "1"{//收款方
//                configTopAndBottomViewWhenEarnSide(buttonIndex:buttonIndex)
//            }else if userType == "2"{//付款方
//                configTopAndBottomViewWhenPaySide(buttonIndex:buttonIndex )
//            }
//        }
        if let dict  = self.userInfo as? [String:String] , let userType = dict["userType"] {
            if userType == "1"{//收款方
                configTopAndBottomViewWhenEarnSide(buttonIndex:buttonIndex)
            }else if userType == "2"{//付款方
                configTopAndBottomViewWhenPaySide(buttonIndex:buttonIndex )
            }
        }
    }
    func bottomBarAction()  {
        bottomBar.action = {[unowned  self] index in
        self.configTopAndBottomView(buttonIndex:index)
        }
    }
}

// MARK: - actions
extension DDConventionVC {
    ///收款方

    ///终止约定
    func endAppoint(){
        mylog("终止约定")
        var paySideID = ""
        var earnSideID = ""
        for model  in self.apiModel?.data?.items ?? [] {
            if model.type == "2"{//收款人
                earnSideID  = model.items?.first?.bid ?? ""
            }
            if model.type == "3"{//付款人
                paySideID = model.items?.first?.aid ?? ""
            }
        }
        let para = ["appointment_id":self.apiModel?.data?.appointment_id ?? ""  , "aid" : paySideID , "bid":earnSideID]
        self.navigationController?.pushVC(vcIdentifier: "DDEndAppointVC", userInfo: para)
        
    }
    
    
    ///加入约定
    func addAppoint(){
//        mylog("加入约定,直接调接口,弹框提示 , 点击进(或刷新当前控制器)约定详情")
        if (self.apiModel?.data?.status.type ?? "") == "0" { // 私密
            DDRequestManager.share.addToPrivateAppoint(type: ApiModel<String>.self, orderid: self.orderID) { (model ) in
                if model?.status ?? 0 == 200 {
                    self.requestApi()
                    GDAlertView.alert("成功加入约定", image:nil, time: 2, complateBlock: nil )
                }else{GDAlertView.alert(model?.message, image:nil, time: 2, complateBlock: nil )}
            }
        }else{//公开
            DDRequestManager.share.addToPublicAppoint(type: ApiModel<String>.self, orderid: self.orderID) { (model ) in
                if model?.status ?? 0 == 200 {
                    self.requestApi()
                    GDAlertView.alert("成功加入约定", image:nil, time: 2, complateBlock: nil )
                }else{GDAlertView.alert(model?.message, image:nil, time: 2, complateBlock: nil )}
            }
        }
    }
    

    ///付款方
    ///订单付款付款
    func payOrder(){
        mylog("付款")//调小强
        let payVC = PayVC()
        var paramete = [String: String]()
        if let orderID = self.orderID as? String, let price = self.apiModel?.data?.price {
            paramete["orderID"] = orderID
            paramete["price"] = price
        }else {
            GDAlertView.alert("价格不能为空", image: nil, time: 1, complateBlock: nil)
            return
        }
        payVC.userInfo = paramete
        
        self.navigationController?.pushViewController(payVC , animated: true )
        payVC.completeHandle = {[weak self ] payType , payResult in
            if payResult.result {
                self?.requestApi()
            }
        }
        

        
    }
    
   
    ///单个人的放款详情
    func payPartnerDetail(){
        mylog("单个人的放款详情")
//        mylog("放款给工人 , 如果是一次约定 直接 填支付密码 再跳转到放款结果 , 如果是智能约定(多期) 先选期数,再跳转 到支付结果页")
//        if self.apiModel?.data?.num ?? "" > "1"{//智能(多期)约定
//
//        }else{//一次约定
//
//        }
//        self.navigationController?.pushVC(vcIdentifier: "DDPayPartnerVC", userInfo: nil)//
        var bid = ""
        for model  in self.apiModel?.data?.items ?? []{
            if model.type ?? "" == "2"{
                bid = model.items?.first?.bid ?? ""
            }
        }
        let para  = ["lenders": self.apiModel?.data?.lenders ,
                     "orderid" : self.orderID ,
                     "num":self.apiModel?.data?.num ,
//                     "yue_type":self.yue_type ,
                     "yue_type":self.apiModel?.data?.yue_type ,
                     "bid":bid
                     ]
        
        self.navigationController?.pushVC(vcIdentifier: "DDPayPartnersDetailVC", userInfo: para)
    }
    /*
     order_id    约定id
     num    期数
     lenders(1:手动，2：自动)    放款类型
     bid    收款方id
     yue_type(1：单约；2：群约)    约定类型
     */
    ///多个人的放款详情
    func payPartnersDetail(){
        mylog("多个人的放款详情")
        let para  = [
            "lenders": self.apiModel?.data?.lenders ,
            "orderid" : self.orderID ,
            "num":self.apiModel?.data?.num ,
            "yue_type":self.yue_type
        ]
        self.navigationController?.pushVC(vcIdentifier: "DDPayPartnersDetailVC", userInfo: para)
        //        mylog("放款给工人 , 如果是一次约定 直接 填支付密码 再跳转到放款结果 , 如果是智能约定(多期) 先选期数,再跳转 到支付结果页")
        //        if self.apiModel?.data?.num ?? "" > "1"{//智能(多期)约定
        //
        //        }else{//一次约定
        //
        //        }
        //        self.navigationController?.pushVC(vcIdentifier: "DDPayPartnerVC", userInfo: nil)//
    }
    struct  PasswordSetedStatus : Codable{
        var name : String
        var status : Int
    }
    /// name    手机号    string
    /// status    状态(1:已设置，0:未设置)    int
    func whetherSetPayPassword(hasSetCallBack:@escaping ()->()) {
        DDRequestManager.share.whetherSetPayPassword(type: ApiModel<PasswordSetedStatus>.self) { (model ) in
            if model?.data?.status == 0 {// 未设置
                self.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC" , userInfo: VCActionType.changePayPassword)
            }else {
                hasSetCallBack()
            }
        }
    }
    
    ///放款给工人
    func payPartner(){
        self.whetherSetPayPassword {
            
            mylog("放款给工人 , 如果是一次约定 直接 填支付密码 再跳转到放款结果 , 如果是智能约定(多期) 先选期数,再跳转 到支付结果页")
            var bid = ""
            for model  in self.apiModel?.data?.items ?? []{
                if model.type ?? "" == "2"{
                    bid = model.items?.first?.bid ?? ""
                }
            }
            if (self.apiModel?.data?.status.type ?? "") == "0" { // 私密
                if Int(self.apiModel?.data?.num ?? "") ?? 0 > 1{//智能(多期)约定 //
                    let para  = ["lenders": self.apiModel?.data?.lenders, // 放款类型 1:手动，2：自动
                        "orderid" : self.orderID,
                        "yue_type": self.apiModel?.data?.yue_type, // 1 单约  2 群约
                        "bid":bid,
                        "type" : "1", // 1 单期 2 多期
                    ]
                    self.navigationController?.pushVC(vcIdentifier: "DDStageListVC", userInfo: para)//
                }else{//一次约定
                    mylog("直接放款")
                    self.payOnePartnerOnePeriods()
                }
            }else{//公开
                let para  = ["lenders": self.apiModel?.data?.lenders, // 放款类型 1:手动，2：自动
                    "orderid" : self.orderID,
                    "yue_type": self.apiModel?.data?.yue_type, // 1 单约  2 群约
                    "bid":bid,
                    "type" : "1", // 1 单期 2 多期
                ]
                self.navigationController?.pushVC(vcIdentifier: "DDStageListVC", userInfo: para)
            }
            
        }
        
        
    }
    
    ///放款给工人们
    func payPartners(){
        
        self.whetherSetPayPassword {
            var bid = ""
            for model  in self.apiModel?.data?.items ?? []{
                if model.type ?? "" == "2"{
                    bid = model.items?.first?.bid ?? ""
                }
            }
            if (self.apiModel?.data?.status.type ?? "") == "0" { // 私密
                if Int(self.apiModel?.data?.num ?? "") ?? 0 > 1{//智能(多期)约定 //
                    let para  = ["lenders": self.apiModel?.data?.lenders, // 放款类型 1:手动，2：自动
                        "orderid" : self.orderID,
                        "bid":bid,
                        "type" : "2", // 1 单期 2 多期
                        "yue_type": self.apiModel?.data?.yue_type] // 1 单约  2 群约
                    self.navigationController?.pushVC(vcIdentifier: "DDStageListVC", userInfo: para)
                }else{//一次多人约定
                    mylog("收款人列表")
                    let para  = ["lenders": self.apiModel?.data?.lenders, // 放款类型 1:手动，2：自动
                        "orderid" : self.orderID,
                        "yue_type": self.apiModel?.data?.yue_type, // 1 单约  2 群约
                        "bid":bid,
                        "type" : "1", // 1 单期 2 多期
                    ]
                    self.navigationController?.pushVC(vcIdentifier: "DDEarnerListVC", userInfo: para)
                }
            }else{//公开
                let para  = ["lenders": self.apiModel?.data?.lenders, // 放款类型 1:手动，2：自动
                    "orderid" : self.orderID,
                    "yue_type": self.apiModel?.data?.yue_type, // 1 单约  2 群约
                    "bid":bid,
                    "type" : "2", // 1 单期 2 多期
                ]
                self.navigationController?.pushVC(vcIdentifier: "DDStageListVC", userInfo: para)
            }
        }
        
       
        
    }
    
    func payOnePartnerOnePeriods()  {
        let psdInput =  DDPayPasswordInputView(superView: self.view)
        psdInput.passwordComplateHandle = { password in
            DDRequestManager.share.payToPartner(type: ApiModel<String>.self , partnerIDs: [self.apiModel?.data?.fid ?? ""], payword: password) { (model ) in
                if model?.status == 200 {
                    GDAlertView.alert("放款成功", image: nil, time: 2 , complateBlock: {
                        self.requestApi()
                    })
                }else{
                    GDAlertView.alert(model?.message, image: nil, time: 2 , complateBlock: nil )
                    self.requestApi()
                }
            }
        }
        psdInput.forgetHandle = {[weak self ]  in
            self?.view.endEditing(true )
            
            self?.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC")
        }
        psdInput.cancleHandle = {[weak self ]  in
            self?.view.endEditing(true )
            self?.requestApi()
        }
    }
    ///修改约定
    func changeAppoint(){
        mylog("修改约定")
        var bid = ""
        for model  in self.apiModel?.data?.items ?? []{
            if model.type ?? "" == "2"{
                bid = model.items?.first?.bid ?? ""
            }
        }
        if bid.count == 0 {
            mylog("bid为空")
            return
        }
        var paySideID = ""
        for model  in self.apiModel?.data?.items ?? [] {
            if model.type == "3"{//付款人
                paySideID = model.items?.first?.aid ?? ""
            }
        }
        let temp = Int(self.apiModel?.data?.num ?? "1") ?? 0 > 1  ? "2" : "1"
        let mod_tag = "0"  // 未修改
        let  para   = [
            "orderid":self.orderID,
            "bid":bid ,
            "type":temp,
            "mod_tag" : mod_tag,
            "yue_type":self.apiModel?.data?.yue_type,
            "num":self.apiModel?.data?.num,
            "lenders" : self.apiModel?.data?.lenders,
            "appointment_id":self.apiModel?.data?.appointment_id ?? "",
            "aid" : paySideID
        ]
        self.navigationController?.pushVC(vcIdentifier: "DDPerformChangeMoneyVC", userInfo: para )

//            mylog("修改金额  ,  如果是一次约定 跳转到 单期修改页面 , 如果是智能约定(多期) 跳转到 多期修改页面")

        
    }
    
    
    ///both
    ///无事件按钮
    func noAction(){
        mylog("无事件")
    }
    
    ///金额有修改
    func moneyChanged(){
        mylog("报酬有修改")
        var paySideID = ""
        for model  in self.apiModel?.data?.items ?? [] {
            if model.type == "3"{//付款人
                paySideID = model.items?.first?.aid ?? ""
            }
        }
        var bid = ""
        for model  in self.apiModel?.data?.items ?? []{
            if model.type ?? "" == "2"{
                bid = model.items?.first?.bid ?? ""
            }
        }
        if bid.count == 0 {
            mylog("bid为空")
            return
        }
        let temp = Int(self.apiModel?.data?.num ?? "1") ?? 0 > 1  ? "2" : "1"
        let mod_tag = "1"  // 已修改
        let para = ["orderid":self.orderID,
                    "bid":bid ,
                    "type":temp,
                    "mod_tag" : mod_tag,
                    "appointment_id":self.apiModel?.data?.appointment_id ?? ""  ,
                    "aid" : paySideID,
                    "yue_type":self.apiModel?.data?.yue_type,
                    "num":self.apiModel?.data?.num,
                    "lenders" : self.apiModel?.data?.lenders
        ]
        self.navigationController?.pushVC(vcIdentifier: "DDPerformChangeMoneyVC", userInfo: para)

    }
    
    ///协商详情
    func consultDetail(){
        let modelPara = ConsultModel.init()
        modelPara.v_id = self.apiModel?.data?.v_appointment_id
        modelPara.aid = ""
        modelPara.bid = ""
        modelPara.type = "2"
        for model  in self.apiModel?.data?.items ?? [] {
            if model.type == "3"{//付款人
                modelPara.aid = model.items?.first?.aid ?? ""
            }
        }
        for model  in self.apiModel?.data?.items ?? []{
            if model.type ?? "" == "2"{
                modelPara.bid = model.items?.first?.bid ?? ""
            }
        }
        self.navigationController?.pushVC(vcIdentifier: "ConsultDetailVC", userInfo: modelPara)
        mylog("协商详情")
    }

    ///协商列表(取消协商列表了)
    func consultList(){
        mylog("协商列表")
//        self.navigationController?.pushVC(vcIdentifier: "DDConsultListVC", userInfo: nil)
    }
    
    ///开工
    func startWork(){
        mylog("开工")
        
        let alertVC = UIAlertController.init(title: "是否确认开工,开工后约定不能继续加入", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let goSet = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action) in
            DDRequestManager.share.startAppoint(type: ApiModel<String>.self, orderid: self.orderID) { (model ) in
                if model?.status ?? 0 == 200 {
                    //                    GDAlertView.alert("开工成功", image: nil, time: 2, complateBlock: {
                    self.requestApi()
                    //                    })
                }else{
                    GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
                }
            }
        }
        let cancel = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.default) { (action) in
            
        }
        
        alertVC.addAction(goSet)
        alertVC.addAction(cancel)
        self.present(alertVC, animated: true , completion: nil)
        

    }
    ///更多收款人列表
    @objc func morePartnerList(){
        mylog("更多")

        
//        DDRequestManager.share.payToPartner(type: ApiModel<String>.self , partnerIDs: ["1","2","3"], payword: "123456") { (model ) in
//            dump(model)
//        }
        ///0开工 , 否则未开工
        var whetherStart : String = "0"
        if self.apiModel?.data?.status.a_start == "1"{//人满开始
            if self.apiModel?.data?.status.or_kg ?? "" == "1"{//未开工
                ///正常约定详情
                    whetherStart = ""
            }
        }
        let para = ["whetherStart": whetherStart , "orderID":self.orderID , "publicOrPrivate": self.privateOrPublic]
        self.navigationController?.pushVC(vcIdentifier: "DDPayPartnersVC", userInfo: para)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestApi()
    }
}

extension DDConventionVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.apiModel?.data?.status.or_kg ?? "" == "1"{//未开工
        if let userType = self.apiModel?.data?.user_type , let isStartWork = self.apiModel?.data?.status.or_kg {
            if userType == "2"{//付款方
                if self.apiModel?.data?.items?[indexPath.section].type ?? "" == "1" && yue_type ?? "" == "2" , let danJiaXiangQing = self.apiModel?.data?.items?[indexPath.section].items?[indexPath.row].top {
                    if danJiaXiangQing == "chakanxiangqing"{//跳转到单价详情
                        mylog("跳转到单价详情")
                        
                        let para = [ "orderID":self.orderID , "publicOrPrivate": self.privateOrPublic]
                        self.navigationController?.pushVC(vcIdentifier: "DDCustomUnitPayVC", userInfo:para )
                    }
                    
                }
                if isStartWork != "1" {//已开工
                    if let groupType = self.apiModel?.data?.items?[indexPath.section].type{
                        if groupType == "2" && yue_type ?? "" == "2" /*&& self.apiModel?.data?.join_num ?? "" > "1"*/{//收款人列表
                            
                            let partnerID = self.apiModel?.data?.items?[indexPath.section].items?[indexPath.row].bid
                            let canBeAction = self.apiModel?.data?.items?[indexPath.section].items?[indexPath.row].sign ?? ""
                            //                        if canBeAction != "0"{
                            //                            self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: ["orderID": orderID , "userType":"2"/*2付款 1收款*/,"privateOrPublic":privateOrPublic,"yue_type":"1" , "yiFangID":partnerID ])//请求详情接口时付款方标识为2
                            //                        }
                            if canBeAction != "0"{
                                self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: ["orderID": orderID , "userType":"2"/*2付款 1收款*/,"privateOrPublic":privateOrPublic,"yue_type":"1" , "yiFangID":partnerID ])//请求详情接口时付款方标识为2
                            }
                        }
                    }
                }
                
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let userType = self.apiModel?.data?.user_type{
            if userType == "2"{//付款方
                if let groupType = self.apiModel?.data?.items?[section].type{
                    if groupType == "2" && yue_type ?? "" == "2"{//收款人列表
//                        if self.apiModel?.data?.status.or_kg ?? "" == "1" {// 1 未开工 , 判断person_num
//                            let join_num = Int(self.apiModel?.data?.join_num ?? "0") ?? 0
//                            let person_num = Int(self.apiModel?.data?.person_num ?? "0") ?? 0
//                            if join_num > 5 || (privateOrPublic == "0" && person_num > 5){
//                                return 43
//                            }
//                        }else{ // 已开工 , 判断 join_num
//                            let join_num = Int(self.apiModel?.data?.join_num ?? "0") ?? 0
////                            let person_num = Int(self.apiModel?.data?.person_num ?? "0") ?? 0
//                            if join_num > 5 {
//                                return 43
//                            }
//                        }
                        let join_num = Int(self.apiModel?.data?.join_num ?? "0") ?? 0
                        let person_num = Int(self.apiModel?.data?.person_num ?? "0") ?? 0
                        if join_num > 5 || (
                            self.apiModel?.data?.status.or_kg ?? "" == "1" && person_num > 5){
                            return 43
                        }
                        
                    }
                }
            }
        }
        return 3
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
//        return 44
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        let needShowFooter = true
        if needShowFooter {
//            self.tableFooter.model = (title:self.datas.tableFooterTitle,type:self.datas.type)
//            self.tableFooter.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 40)
        }else{
//            self.tableFooter.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 0)
        }
        return self.apiModel?.data?.items?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = self.apiModel?.data?.items?[section]
        return sectionModel?.items?.count ?? 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        
        if let userType = self.apiModel?.data?.user_type{
            if userType == "2"{//付款方
                if let groupType = self.apiModel?.data?.items?[section].type{
                    if groupType == "2" && yue_type ?? "" == "2"{//收款人列表
                        
                        let join_num = Int(self.apiModel?.data?.join_num ?? "0") ?? 0
                        let person_num = Int(self.apiModel?.data?.person_num ?? "0") ?? 0
//                        if self.apiModel?.data?.status.or_kg ?? "" == "1" {//未开工 判断person_num
//                            if (privateOrPublic == "1" && join_num > 5) || (privateOrPublic == "0" && person_num > 5){
//                                let footer = UIControl()
//                                let label = UILabel()
//                                let margin : CGFloat = 20
//                                footer.addSubview(label)
//                                footer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 43)
//                                label.frame =  CGRect(x: margin, y: 0, width: self.view.bounds.width - margin * 2, height: 40)
//                                footer.backgroundColor = .white
//                                label.text = "更多\t\t\t"
//                                label.textAlignment = .right
//                                label.textColor = UIColor.DDThemeColor
//                                label.backgroundColor  = UIColor.white
//                                footer.backgroundColor  = UIColor.clear
//                                footer.addTarget(self , action: #selector(morePartnerList), for: UIControlEvents.touchUpInside)
//                                return footer
//                            }
//                        }else{//已开工 判断join_num
//                            if join_num > 5{
//                                let footer = UIControl()
//                                let label = UILabel()
//                                let margin : CGFloat = 20
//                                footer.addSubview(label)
//                                footer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 43)
//                                label.frame =  CGRect(x: margin, y: 0, width: self.view.bounds.width - margin * 2, height: 40)
//                                footer.backgroundColor = .white
//                                label.text = "更多\t\t\t"
//                                label.textAlignment = .right
//                                label.textColor = UIColor.DDThemeColor
//                                label.backgroundColor  = UIColor.white
//                                footer.backgroundColor  = UIColor.clear
//                                footer.addTarget(self , action: #selector(morePartnerList), for: UIControlEvents.touchUpInside)
//                                return footer
//                            }
//                        }
                        
                        if join_num > 5 || (self.apiModel?.data?.status.or_kg ?? "" == "1" && person_num > 5){
                            let footer = UIControl()
                            let label = UILabel()
                            let margin : CGFloat = 20
                            footer.addSubview(label)
                            footer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 43)
                            label.frame =  CGRect(x: margin, y: 0, width: self.view.bounds.width - margin * 2, height: 40)
                            footer.backgroundColor = .white
                            label.text = "更多\t\t\t"
                            label.textAlignment = .right
                            label.textColor = UIColor.DDThemeColor
                            label.backgroundColor  = UIColor.white
                            footer.backgroundColor  = UIColor.clear
                            footer.addTarget(self , action: #selector(morePartnerList), for: UIControlEvents.touchUpInside)
                            return footer
                        }
                        
                    }
                }
            }
        }
        
        
        
        let footer = UIView()
        footer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 3)
        footer.backgroundColor  = UIColor.clear
        return footer
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableCell(withIdentifier: "DDConventionDetailSectionHeader") as? DDConventionDetailSectionHeader{
            let headerModel = self.apiModel?.data?.items?[section]
            header.model = headerModel
            return header
        }else{
            let header = DDConventionDetailSectionHeader.init(reuseIdentifier: "DDConventionDetailSectionHeader")
            let headerModel = self.apiModel?.data?.items?[section]
            header.model = headerModel
            return header
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowModel = self.apiModel?.data?.items?[indexPath.section].items?[indexPath.row]
        var returnCell : DDConventionDetailCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDConventionDetailCell") as? DDConventionDetailCell{
            returnCell = cell
        }else{
            returnCell = DDConventionDetailCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDConventionDetailCell")
        }
        returnCell.model = rowModel
        if let userType = self.apiModel?.data?.user_type , let isStartWork = self.apiModel?.data?.status.or_kg {
            if userType == "2"{//付款方
                if self.apiModel?.data?.items?[indexPath.section].type ?? "" == "1" && yue_type ?? "" == "2" , let danJiaXiangQing = self.apiModel?.data?.items?[indexPath.section].items?[indexPath.row].top {
                    if danJiaXiangQing == "chakanxiangqing"{//跳转到单价详情
                        returnCell.value.textColor = UIColor.blue
                    }else{
                        returnCell.value.textColor = UIColor.DDSubTitleColor
                    }
                    
                }else{
                    returnCell.value.textColor = UIColor.DDSubTitleColor
                }
                if isStartWork != "1"{//开工
                    if let groupType = self.apiModel?.data?.items?[indexPath.section].type{
                        if groupType == "2" && yue_type ?? "" == "2" /*&& self.apiModel?.data?.join_num ?? "" > "1"*/{//收款人列表
                            if yue_type ?? "" == "2"{
                                returnCell.value.textColor = UIColor.blue
                            }else{
                                returnCell.value.textColor = UIColor.DDSubTitleColor
                            }
                        }else{
                            if groupType != "1"{
                                returnCell.value.textColor = UIColor.DDSubTitleColor
                                
                            }
                        }
                    }
                }
            }
        }

        return returnCell
    }
}

