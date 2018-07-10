//
//  DDItem5VC.swift
//  hhcszgd
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
import SnapKit

class DDItem5VC: DDDiyNavibarVC {
    
    let tableHeader = DDTableHeaderView()
    let rightTableView = DDPublicTableView()
    let leftTableView = DDPublicTableView()
    
    let searchBoxH : CGFloat = 40.0
    let tableHeaderViewH : CGFloat = 225.0
    let btnViewH : CGFloat = 50.0
    let pickerViewH : CGFloat = 175.0
    let tableViewH = SCREENHEIGHT - DDNavigationBarHeight - DDTabBarHeight
    
    var isSelected = true  // 最新约定是否被选取
    var tableOffSetY : CGFloat?   // tableView滚动Y值
    var address : String?
    
    var appiont : [DDPublicAppointModel]? = []
    var scrollImage : [DDScrollImageModel]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configNaviBar()
        self.configTableView()
        self.configTableHeaderView()
        
//        DDRequestManager.share.getOpenAppiontList(type: ApiModel<[DDPublicAppointModel]>.self, sort: "2", range: "") { (model) in
//            if model?.status == 200 {
//                mylog("公开约定列表获取成功")
//                if model?.data?.count == 0 {
//                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
//                    return
//                }
//                self.appiont = model?.data
//                self.leftTableView.reloadData()
//            } else {
//                self.appiont = []
//                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
//            }
//        }
        
//        DDRequestManager.share.getAdvertisementRest(type: ApiModel<[DDScrollImageModel]>.self, id: "3") { (model) in
//            if model?.status == 200 {
//                mylog("轮播图数据获取成功")
//                self.scrollImage = model?.data
//                self.configScrollImage()
//            } else {
//                self.scrollImage = []
//                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
//            }
//        }
        
        NotificationCenter.default.addObserver(self , selector: #selector(publicReloadData), name: DDTabBarItem5Reclick, object: nil )
        NotificationCenter.default.addObserver(self , selector: #selector(tabbarReclick), name: DDTabBarItem5Reclick, object: nil )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self )
    }
    
    @objc func tabbarReclick() {
        requestData()
    }
    
    func configNaviBar() {
        let navBar = DDPublicNav.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: DDNavigationBarHeight + searchBoxH))
        navBar.delegate = self
        self.naviBar = navBar
    }
    
    func configTableHeaderView() {
        let headerY = DDNavigationBarHeight + searchBoxH
        tableHeader.frame = CGRect(x: 0, y: headerY, width: SCREENWIDTH , height: tableHeaderViewH)
        self.view.addSubview(tableHeader)
        tableHeader.pictureViewCallBack = { (index) ->()  in
            mylog("闭包回调 点击的索引\(index)")
            weak var weakSelf = self
            if weakSelf?.tableHeader.models.count != 0 {
                let model = weakSelf?.tableHeader.models[index]
                self.navigationController?.pushVC(vcIdentifier: "GDBaseWebVC", userInfo: model?.link_url)
            }
        }
        tableHeader.btnCallBack = { (actionType) ->()  in
            weak var weakSelf = self
            weakSelf?.buttonCallBack(actionType: actionType)
        }
    }
    
    // jinmanli
    func configScrollImage() {
        var imageArray : [DDHomeBannerModel] = []
        if scrollImage?.count ?? 0 == 0 {
            for imageModel in 0..<3 {
                let model = DDHomeBannerModel()
                model.image_url = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524133267673&di=a416dcc3de6e329f0072ca1401b2253c&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dpixel_huitu%252C0%252C0%252C294%252C40%2Fsign%3Db360ab28790e0cf3b4fa46bb633e9773%2Fe850352ac65c10387071c8f8b9119313b07e89f8.jpg"
                model.link_url = "https://www.baidu.com"
                imageArray.append(model)
            }
            tableHeader.models = imageArray
        }else{
            if let model = scrollImage {
                for imageModel in model {
                    let model = DDHomeBannerModel()
                    model.image_url = imageModel.img ?? "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1524133267673&di=a416dcc3de6e329f0072ca1401b2253c&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dpixel_huitu%252C0%252C0%252C294%252C40%2Fsign%3Db360ab28790e0cf3b4fa46bb633e9773%2Fe850352ac65c10387071c8f8b9119313b07e89f8.jpg"
                     model.link_url = imageModel.url ?? ""
                    imageArray.append(model)
                }
                tableHeader.models = imageArray
            }
        }
    }
    
    func configTableView() {
        let tableY = DDNavigationBarHeight + searchBoxH + btnViewH
        let tableH = tableViewH - searchBoxH - btnViewH
        leftTableView.frame = CGRect(x: 0, y: tableY, width: SCREENWIDTH, height: tableH)
        self.view.addSubview(leftTableView)
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.contentInset = UIEdgeInsets.init(top: pickerViewH, left: 0, bottom: 0, right: 0)
        leftTableView.estimatedRowHeight = 200
        leftTableView.rowHeight = UITableViewAutomaticDimension
        leftTableView.gdRefreshControl = GDRefreshControl.init(target: self, selector: #selector(publicReloadData))
        leftTableView.gdRefreshControl?.refreshHeight = 40

        rightTableView.frame = CGRect(x: SCREENWIDTH, y: tableY, width: SCREENWIDTH, height: tableH)
        self.view.addSubview(rightTableView)
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.contentInset = UIEdgeInsets.init(top: pickerViewH, left: 0, bottom: 0, right: 0)
        rightTableView.estimatedRowHeight = 200
        rightTableView.rowHeight = UITableViewAutomaticDimension
        rightTableView.gdRefreshControl = GDRefreshControl.init(target: self , selector: #selector(publicReloadData))
        rightTableView.gdRefreshControl?.refreshHeight = 40
    }
    
    @objc func publicReloadData() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            if self.isSelected {
                self.leftTableView.gdRefreshControl?.endRefresh()
            }else{
                self.rightTableView.gdRefreshControl?.endRefresh()
            }
        }
        requestData()
//        let reloadView = isSelected ? leftTableView : rightTableView
//        // "1" 最新约定  "2" 即将开始
//        var sort = isSelected ? "0" : "0"
//        if self.address == nil {
//            self.address = ""
//            sort = "2"
//        }
//        DDRequestManager.share.getOpenAppiontList(type: ApiModel<[DDPublicAppointModel]>.self, sort: sort, range: self.address ?? "") { (model) in
//            if model?.status == 200 {
//                self.appiont = model?.data
//                reloadView.reloadData()
//            } else {
//                self.appiont = []
//                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestData()
//        let reloadView = isSelected ? leftTableView : rightTableView
//        // "1" 最新约定  "2" 即将开始
//        var sort = isSelected ? "0" : "0"
//        if self.address == nil {
//            self.address = ""
//            sort = "2"
//        }
//        DDRequestManager.share.getOpenAppiontList(type: ApiModel<[DDPublicAppointModel]>.self, sort: sort, range: self.address ?? "") { (model) in
//            if model?.status == 200 {
//                self.appiont = model?.data
//                reloadView.reloadData()
//            } else {
//                self.appiont = []
//                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
//            }
//        }
    }
    
    func requestData() {
        DDRequestManager.share.getAdvertisementRest(type: ApiModel<[DDScrollImageModel]>.self, id: "3") { (model) in
            if model?.status == 200 {
                mylog("轮播图数据获取成功")
                self.scrollImage = model?.data
                self.configScrollImage()
            } else {
                self.scrollImage = []
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
            }
        }
        let reloadView = isSelected ? leftTableView : rightTableView
        // "1" 最新约定  "2" 即将开始
        var sort = isSelected ? "0" : "0"
        if self.address == nil {
            self.address = ""
            sort = "2"
        }
        DDRequestManager.share.getOpenAppiontListAddError(type: ApiModel<[DDPublicAppointModel]>.self, sort: sort, range: self.address ?? "", success: { (model) in
            if model.status == 200 {
                self.appiont = model.data
                reloadView.reloadData()
            } else {
                self.appiont = []
                GDAlertView.alert(model.message, image: nil, time: 2, complateBlock: nil)
            }
            
        }, failure: { (error) in
            DDErrorView(superView: self.view , error: error).automaticRemoveAfterActionHandle = {
                self.requestData()
            }
            self.view.bringSubview(toFront: self.naviBar ?? UIView())
        }) {
            reloadView.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
        }
    }
    
    func buttonCallBack(actionType: DDTableHeaderView.PublicHeaderViewActionType) {
        switch actionType {
        // 最新约定
        case .newAppoint:
            self.newAppointAction()
        // 即将开始
        case .start:
            self.startAction()
        // 区域
        case .region:
            self.regionBtnClick()
        }
    }
    
    func newAppointAction() {
        self.address = ""
        UIView.animate(withDuration: 0.5, animations: {
            self.leftTableView.transform = CGAffineTransform.init(translationX: 0, y: 0)
            self.rightTableView.transform = CGAffineTransform.init(translationX: SCREENWIDTH, y: 0)
        })
        if self.tableOffSetY ?? 0.0 > 0.0 {
            leftTableView.contentOffset.y = 0
        }
        isSelected = true
        DDRequestManager.share.getOpenAppiontList(type: ApiModel<[DDPublicAppointModel]>.self, sort: "2", range: "") { (model) in
            if model?.status == 200 {
                mylog("公开约定列表获取成功")
                self.appiont = model?.data
                self.leftTableView.reloadData()
            } else {
                self.appiont = []
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
            }
        }
    }
    func startAction() {
        self.address = ""
        UIView.animate(withDuration: 0.5, animations: {
            self.leftTableView.transform = CGAffineTransform.init(translationX: -SCREENWIDTH, y: 0)
            self.rightTableView.transform = CGAffineTransform.init(translationX: -SCREENWIDTH, y: 0)
        })
        if self.tableOffSetY ?? 0.0 > 0.0 {
            rightTableView.contentOffset.y = 0
        }
        isSelected = false
        DDRequestManager.share.getOpenAppiontList(type: ApiModel<[DDPublicAppointModel]>.self, sort: "2", range: "") { (model) in
            if model?.status == 200 {
                mylog("公开约定列表获取成功")
                self.appiont = model?.data
                self.rightTableView.reloadData()
            } else {
                self.appiont = []
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
            }
        }
    }
    func regionBtnClick() {
        let coverView = DDCoverView.init(superView: UIApplication.shared.keyWindow ?? self.view)
        let regionSelectView = DDRegionSelect.init(frame: CGRect(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: 300))
        coverView.addSubview(regionSelectView)
        UIView.animate(withDuration: 0.5, animations: {
            regionSelectView.transform = regionSelectView.transform.translatedBy(x: 0, y: -300)
        })
        self.regionSelecte(spuerView: regionSelectView)
        regionSelectView.callBack = { () ->()  in
            coverView.removeFromSuperview()
        }
    }
    
    func regionSelecte(spuerView: UIView) {
        let frame = CGRect.init(x: 0, y: 50, width: SCREENWIDTH, height: 300)
        let areaSelectView = AreaSelectView.init(frame: frame, title: "jj", type: 100, url: "area", subFrame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        areaSelectView.sureBtn.isHidden = true
        areaSelectView.containerView.backgroundColor = lineColor
        spuerView.addSubview(areaSelectView)
        areaSelectView.finished.subscribe(onNext: { [weak self](address, id) in
            weak var weakSelf = self
            weakSelf?.address = id
            areaSelectView.removeFromSuperview()
            spuerView.superview?.removeFromSuperview()
//            var sort = "1"
//            if !(weakSelf?.isSelected ?? true) {
//                sort = "2"
//            }
            DDRequestManager.share.getOpenAppiontList(type: ApiModel<[DDPublicAppointModel]>.self, sort: "0", range: id) { (model) in
                if model?.status == 200 {
                    mylog("公开约定列表获取成功")
                    self?.appiont = model?.data
                    if (weakSelf?.isSelected ?? false) {
                        weakSelf?.leftTableView.reloadData()
                    } else {
                        weakSelf?.rightTableView.reloadData()
                    }
                } else {
                    self?.appiont = []
                    if (weakSelf?.isSelected ?? false) {
                        weakSelf?.leftTableView.reloadData()
                    } else {
                        weakSelf?.rightTableView.reloadData()
                    }
                    GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DDItem5VC : DDPublicNavDelegate {
    
    func performAction(actionType: DDPublicNav.PublicBarActionType) {
        switch actionType {
        case .post:
            self.navigationController?.pushViewController(DDPublicAppointPostVC(), animated: true)
        case .search:
            self.navigationController?.pushViewController(DDPublicSearchVC(), animated: true)
        }
    }
}

extension DDItem5VC : UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appiont?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < (appiont?.count ?? 0)) && appiont?.count != 0 {
            if let model = appiont?[indexPath.row] {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "DDPublicCell") as? DDPublicCell{
                    cell.model = model
                    return cell
                }else{
                    let cell = DDPublicCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDPublicCell")
                    cell.model = model
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row < (appiont?.count ?? 0)) && appiont?.count != 0 {
            if let model = appiont?[indexPath.row] {
                /*2自己   , 1 是别人*/
                var userType = "1"
                if model.aid == DDAccount.share.id {
                    userType = "2"
                }
                self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: ["orderID": appiont?[indexPath.row].order_id , "userType": userType, "privateOrPublic":"1" , "yue_type": model.yue_type /*1单约  2 群约*/])
            }
        }
    }
}

extension DDItem5VC : UIScrollViewDelegate {
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tableOffSetY = scrollView.contentOffset.y
        if scrollView.contentOffset.y == -pickerViewH {
            tableHeader.frame = CGRect(x: 0, y: DDNavigationBarHeight + searchBoxH, width: SCREENWIDTH , height: tableHeaderViewH)
            return
        }
        if scrollView.contentOffset.y >= 0 {
            tableHeader.frame = CGRect(x: 0, y: DDNavigationBarHeight + searchBoxH - pickerViewH, width: SCREENWIDTH , height: tableHeaderViewH)
            return
        } else if scrollView.contentOffset.y < -pickerViewH {
            return
        }
        leftTableView.contentOffset.y = scrollView.contentOffset.y
        rightTableView.contentOffset.y = scrollView.contentOffset.y
        tableHeader.frame = CGRect(x: 0, y: DDNavigationBarHeight + searchBoxH - (pickerViewH + scrollView.contentOffset.y), width: SCREENWIDTH, height: tableHeaderViewH)
    }
}
