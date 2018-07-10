//
//  DDHomeSearchVC.swift
//  Project
//
//  Created by WY on 2018/4/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit


extension DDHomeSearchVC :  UISearchBarDelegate , UISearchControllerDelegate {
    func configSearchController()  {
        // 由于其子控件是懒加载模式, 所以找之前先将其显示
        searchBar.placeholder = "伙伴姓名/约定名称/付款人"
        searchBar.setShowsCancelButton(true , animated: false )
        // 这个方法来遍历其子视图, 找到cancel按钮
        for subview in searchBar.subviews {
            for subsubview in subview.subviews{
                if let button = subsubview as? UIButton{
                    button.setTitle("确定", for: UIControlState.normal)
                    button.setTitle("确定", for: UIControlState.disabled)
                    button.setTitleColor(UIColor.white , for: UIControlState.disabled)
                }
            }
        }
        
        self.navigationItem.titleView = self.searchBar
        
        self.searchBar.returnKeyType = UIReturnKeyType.search
        self.searchBar.delegate  = self
        //        self.searchVC.searchBar.barTintColor = UIColor.white
        // It is usually good to set the presentation context.
//        self.definesPresentationContext = true
        //        tableView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        mylog("ssss")
        self.search()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        mylog("ssss")
        self.search()
        for subview in searchBar.subviews {
            for subsubview in subview.subviews{
                if let button = subsubview as? UIButton{
                    button.isEnabled = true; //把enabled设置为yes
                    button.isUserInteractionEnabled = true
                    //                    button.state = UIControlState.normal
                }
            }
        }
    }
}


class DDHomeSearchVC: DDNormalVC {
    let searchBar : MySearchBar = MySearchBar()
    let searchBox = UITextField.init()
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
    var apiModel : ApiModel<[DDAppointShortGroup]>?
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.configNavigationBar()
        configSearchController()
        self.configTableView()
        self.searchBox.becomeFirstResponder()
//        if (@available(iOS 11.0, *)) {
        self.searchBar.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
//            [[self.searchBar.heightAnchor constraintEqualToConstant:44.0] setActive:YES];
//        }
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
//            self.navigationController?.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        self.searchBar.becomeFirstResponder()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func requestApi() {
        if let keyword = self.searchBar.text , keyword.count > 0{
            DDRequestManager.share.searchSmartly(type: ApiModel<[DDAppointShortGroup]>.self , keywords: keyword, complate: { (model ) in
                self.apiModel = model
                if self.apiModel?.data?.count ?? 0 == 0{
                    GDAlertView.alert("没有相应的结果", image: nil, time: 2, complateBlock: nil)
                }
                mylog(model)
                dump(model)
                self.tableView.reloadData()
            })
            
        }else{
            self.view.endEditing(true)
        }
    }
    func configTableView() {
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
    }
    func configNavigationBar()  {
        self.navigationItem.titleView = searchBox
        searchBox.delegate = self
        // ******************* wangyuanfei *******************
        searchBox.tintColor = UIColor.lightGray
        // ***************************************************
        searchBox.returnKeyType = UIReturnKeyType.search
        searchBox.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 44 * 2, height: 30)
        //        searchBox.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        //        searchBox.borderStyle = UITextBorderStyle.none // UITextBorderStyle.roundedRect
        searchBox.borderStyle =  UITextBorderStyle.roundedRect
        let rightView = UIButton(frame: CGRect(x: -10, y: 0, width: 20, height: 20))
        let img = UIImage(named: "search")
        img?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        rightView.setImage(img, for: UIControlState.normal)
        rightView.backgroundColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1)
        //        rightView.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        searchBox.rightView = rightView
        searchBox.rightViewMode = .always
        searchBox.placeholder = "伙伴姓名/约定名称/付款人"
        let searchButton =  UIBarButtonItem.init(title: "搜索", style: UIBarButtonItemStyle.plain, target: self, action: #selector(search))
        searchButton.tintColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1)
        searchButton.setTitlePositionAdjustment(UIOffset.init(horizontal: 9, vertical: 0), for: UIBarMetrics.default)
        self.navigationItem.rightBarButtonItem = searchButton
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mylog("will will disappear")
        self.searchBar.resignFirstResponder()
    }
}

extension DDHomeSearchVC : UITableViewDelegate , UITableViewDataSource {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sectionModel = self.apiModel?.data?[indexPath.section] , let groupIdentfy = sectionModel.type{
            var para = [String :String]()
            var yueType : String? = nil
            switch groupIdentfy {
            case "friends":
                if let tempModel = sectionModel.items?[indexPath.row]{
                    self.navigationController?.pushVC(vcIdentifier: "DDPartnerDetailVC", userInfo: ["type":DDPartnerDetailVC.DDPartnerDetailFuncType.friendDetail , "id":tempModel.id] )
                }
                return
            case "userPublishedResults"://///我的约定【付款方】
                para["userType"] = "2"
                yueType = sectionModel.items?[indexPath.row].yueType
            case "userAppointedResults"://我的约定【收款方】
                para["userType"] = "1"
                yueType = "1"
//                para["yiFangID"] = DDAccount.share.id//收款方不要收款方id
            case "publicResults":///公共约定
                if sectionModel.items?[indexPath.row].user_type ?? "1" == "1"{//收款方
                    para["userType"] = "1"
                    yueType = "1"
//                    para["yiFangID"] = DDAccount.share.id//收款方不要收款方id
                }else if sectionModel.items?[indexPath.row].user_type ?? "1" == "2"{//付款方
                    para["userType"] = "2"
                    yueType = sectionModel.items?[indexPath.row].yueType
                }
            default:
                break
            }
            
            para["orderID"] = sectionModel.items?[indexPath.row].orderId
            
            para["privateOrPublic"]  = sectionModel.items?[indexPath.row].type ?? "1"
            ///(1:单，2：群)
            para["yue_type"]  = yueType
            self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: para)//请求详情接口时付款方标识为2
        }
    }
    
    
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.apiModel?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionModel = self.apiModel?.data?[indexPath.section] , let groupIdentfy = sectionModel.type{
            switch groupIdentfy {
            case "friends":
                return 64
            case "userPublishedResults"://///我的约定【付款方】
                if self.apiModel?.data?[indexPath.section].items?[indexPath.row].type ?? "x" == "0"{//私密
                    return 64
                }else if self.apiModel?.data?[indexPath.section].items?[indexPath.row].type ?? "x" == "1"{//公开
                    return 120
                }else{return 0}
            case "userAppointedResults"://我的约定【收款方】
                if self.apiModel?.data?[indexPath.section].items?[indexPath.row].type ?? "x" == "0"{//私密
                    return 64
                }else if self.apiModel?.data?[indexPath.section].items?[indexPath.row].type ?? "x" == "1"{//公开
                    return 120
                }else{return 0}
            case "publicResults":///公共约定
                return 120
            default:
                break
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.apiModel?.data?[section].items?.count ?? 0
    }
    
    ///【0 私密约定 1公开约定】
    enum AppointType {
        case privateAppoint
        case publicAppoint
    }
    func getCellByType(tableView:UITableView ,type:AppointType) -> SearchSmartlyBaseCell {
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
        
        if let sectionModel = self.apiModel?.data?[indexPath.section] , let groupIdentfy = sectionModel.type{
            switch groupIdentfy {
            case "friends":
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchSmartlyFriendCell") as? SearchSmartlyFriendCell{
                    cellForReturn = cell
                }else{
                    let cell = SearchSmartlyFriendCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "SearchSmartlyFriendCell")
                    cellForReturn = cell
                }
            case "userPublishedResults"://///我的约定【付款方】
                if sectionModel.items?[indexPath.row].type ?? "x" == "0"{//私密
                    cellForReturn = self.getCellByType(tableView: tableView, type: DDHomeSearchVC.AppointType.privateAppoint)
                }else if sectionModel.items?[indexPath.row].type ?? "x" == "1"{//公开
                    cellForReturn = self.getCellByType(tableView: tableView, type: DDHomeSearchVC.AppointType.publicAppoint)
                }

            case "userAppointedResults"://我的约定【收款方】
                if sectionModel.items?[indexPath.row].type ?? "x" == "0"{//私密
                    cellForReturn = self.getCellByType(tableView: tableView, type: DDHomeSearchVC.AppointType.privateAppoint)
                }else if sectionModel.items?[indexPath.row].type ?? "x" == "1"{//公开
                    cellForReturn = self.getCellByType(tableView: tableView, type: DDHomeSearchVC.AppointType.publicAppoint)
                }
                
            case "publicResults":///公共约定
                 cellForReturn = self.getCellByType(tableView: tableView, type: DDHomeSearchVC.AppointType.publicAppoint)
            default:
                break
            }
        }
        if cellForReturn == nil {return SearchSmartlyBaseCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "xxxxx")}
        cellForReturn?.model = self.apiModel?.data?[indexPath.section].items?[indexPath.row]
        return cellForReturn!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let sectionModel = self.apiModel?.data?[section] , let count = sectionModel.items?.count{
            if count >= 6 {  return 40   }//显示更多
        }
        return 0.001
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let sectionModel = self.apiModel?.data?[section] , let count = sectionModel.items?.count{
            if count >= 6 {
                let button = UIButton()
                button.setTitle("更多", for: UIControlState.normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                button.frame = CGRect(x: 0, y: 0, width: 333, height: 44)
                button.setTitleColor(UIColor.DDThemeColor, for: UIControlState.normal)
                button.removeTarget(self , action: #selector(moreButtonClici(sender:)), for: UIControlEvents.touchUpInside)
                button.addTarget(self , action: #selector(moreButtonClici(sender:)), for: UIControlEvents.touchUpInside)
                if let sectionModel = self.apiModel?.data?[section] , let groupIdentfy = sectionModel.type{
                    switch groupIdentfy {
                    case "friends":
                        button.tag = 1111
                    case "userPublishedResults"://///我的约定【付款方】
                        button.tag = 2222
                    case "userAppointedResults"://我的约定【收款方】
                        button.tag = 3333
                    case "publicResults":///公共约定
                        button.tag = 4444
                    default:
                        break
                    }
                }
                button.backgroundColor = UIColor.white
                return button
            }
        }
        return nil
    }
    
    @objc func moreButtonClici(sender:UIButton)  {
//        func action(ident:String){
//            for groupModel in self.apiModel?.data ?? [] {
//                if groupModel.type ?? "" == ident{
//                    mylog("查看更多的 \(groupModel.type) 数据)")
//                }
//            }
//        }
        
            switch sender.tag {
            case 1111 :
                self.navigationController?.pushVC(vcIdentifier: "DDSMUserMoreVC", userInfo: self.searchBar.text)
            case 2222://///我的约定【付款方】
                let para = ["type":DDSMAppointMoreVC.SearchAppointType.payer.rawValue,"keyWord":self.searchBar.text ?? ""]
                self.navigationController?.pushVC(vcIdentifier: "DDSMAppointMoreVC", userInfo: para)
            case 3333://我的约定【收款方】
                let para = ["type":DDSMAppointMoreVC.SearchAppointType.earner.rawValue,"keyWord":self.searchBar.text ?? ""]

                self.navigationController?.pushVC(vcIdentifier: "DDSMAppointMoreVC", userInfo: para )
            case 4444:///公共约定
                let para = ["type":DDSMAppointMoreVC.SearchAppointType.publicApplint.rawValue,"keyWord":self.searchBar.text ?? ""]
                self.navigationController?.pushVC(vcIdentifier: "DDSMAppointMoreVC", userInfo: para)
            default:
                break
            }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textColor = UIColor.DDTitleColor
        if let sectionModel = self.apiModel?.data?[section] , let groupIdentfy = sectionModel.type{
            switch groupIdentfy {
            case "friends":
               label.text = "   好友"
            case "userPublishedResults"://///我的约定【付款方】
               label.text = "   我的约定(付款方)"
            case "userAppointedResults"://我的约定【收款方】
                label.text = "  我的约定(收款方)"
            case "publicResults":///公共约定
                label.text = "  公开约定"
            default:
                break
            }
        }
        label.backgroundColor = UIColor.DDLightGray
        return label
    }
    
}
extension DDHomeSearchVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        //        mylog("press return key")
        self.search()
        return true
    }
    @objc func search()  {
        self.requestApi()
        self.searchBar.resignFirstResponder()
    }

}

