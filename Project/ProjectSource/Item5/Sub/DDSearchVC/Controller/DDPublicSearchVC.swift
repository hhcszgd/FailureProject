//
//  DDSearchVC.swift
//  Project
//
//  Created by 金曼立 on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation

class DDPublicSearchVC: DDDiyNavibarVC {

    let tableView = UITableView()
    let navBar = DDPublicSearchNav()
    var moreBtn: UIButton?
    let tableViewH = SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight
    let maxDataNum = 30
    
    var publicSearch : [DDAppointShrotModel]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.delegate = self
        self.naviBar = navBar
        self.naviBar?.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: DDNavigationBarHeight)
    }
}

extension DDPublicSearchVC: DDPublicSearchNavDelegate {
    func performAction(actionType: DDPublicSearchNav.PublicSearchBarActionType) {
        switch actionType {
        // 返回
        case .back:
            self.backAction()
        // 搜索
        case .search:
            self.searchAppointAction()
        // 确定
        case .certain:
            self.certainBtnClick()
        }
    }
    
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func searchAppointAction() {
        /*约定名称、约定要求、付款人、区域和金额*/
    }

    func certainBtnClick() {
        if self.navBar.searchBox.text?.count == 0 {
            GDAlertView.alert("搜索内容不能为空", image: nil, time: 2, complateBlock: nil)
            return
        }
        self.view.endEditing(true)
        let keyWords : String = self.navBar.searchBox.text ?? ""
        DDRequestManager.share.searchSmartly(type: ApiModel<[DDAppointShrotModel]>.self , keywords: keyWords, search_type: "4", complate: { (model) in
            if model?.status == 200 {
                mylog("搜索成功")
                if model?.data?.count ?? 0 != 0 {
                    self.publicSearch = model?.data
                    self.tableView.reloadData()
                }else{
                    self.publicSearch = []
                    self.tableView.reloadData()
                    GDAlertView.alert("暂无约定", image: nil, time: 2, complateBlock: nil)
                }
            }else{
                self.publicSearch = []
                self.tableView.reloadData()
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
            }
        })
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height:tableViewH)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension DDPublicSearchVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if publicSearch?.count ?? 0 > maxDataNum {
             return maxDataNum
        }
        return publicSearch?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < (publicSearch?.count ?? 0)) && publicSearch?.count != 0 {
            let model = publicSearch?[indexPath.row]
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
        
        
        if (indexPath.row < (publicSearch?.count ?? 0)) && publicSearch?.count != 0 {
            if let model = publicSearch?[indexPath.row] {
                /*2自己   , 1 是别人*/
                var userType = "1"
                if model.aId == DDAccount.share.id {
                    userType = "2"
                }
                self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: ["orderID": publicSearch?[indexPath.row].orderId, "userType":userType, "privateOrPublic":"1" , "yue_type": model.yueType /*1单约  2 群约*/])
            }
        }
        
//        self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: ["orderID": publicSearch?[indexPath.row].orderId ?? "" , "userType":"1"/*2自己   , 1 是别人*/ , "privateOrPublic":"1" , "yue_type":"1" /*1单约  2 群约*/])
    }
}

extension DDPublicSearchVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.size.height
        let contentOffsetY = scrollView.contentOffset.y
        let bottomOffset = scrollView.contentSize.height - contentOffsetY
        if bottomOffset <= height {
            if publicSearch?.count ?? 0 > maxDataNum {
                if self.moreBtn != nil {
                    if self.moreBtn?.isHidden ?? false {
                        self.moreBtn?.isHidden = false
                        tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: tableViewH - 40)
                    }
                    return
                }
                tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: tableViewH - 40)
                self.moreBtn = UIButton.init(frame: CGRect(x: 15, y: SCREENHEIGHT - 40 - DDSliderHeight, width: 80, height: 40))
                self.moreBtn?.setTitle("查看更多", for: UIControlState.normal)
                self.moreBtn?.setTitleColor(UIColor.blue, for: UIControlState.normal)
                self.moreBtn?.addTarget(self, action: #selector(moreBtnClick), for: UIControlEvents.touchUpInside)
                if let btn = self.moreBtn {
                    self.view.addSubview(btn)
                }
            } else {
               GDAlertView.alert("已经显示全部", image: nil, time: 2, complateBlock: nil)
            }
        } else {
            if self.moreBtn != nil {
                if !(self.moreBtn?.isHidden ?? true) {
                    self.moreBtn?.isHidden = true
                    tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: tableViewH)
                }
            }
        }
    }
    
    @objc func moreBtnClick() {
        self.navigationController?.pushVC(vcIdentifier: "DDPublicSearchMoreVC", userInfo: ["keywords": self.navBar.searchBox.text])
    }
}


