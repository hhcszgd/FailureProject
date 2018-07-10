//
//  DDSMUserMoreVC.swift
//  Project
//
//  Created by WY on 2018/4/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDSMUserMoreVC: DDNormalVC {


    var naviBarStartShowH : CGFloat =  DDDevice.type == .iphoneX ? 164 : 148
    var naviBarEndShowH : CGFloat = DDDevice.type == .iphoneX ? 100 : 80
    var pageNum : Int  = 0
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    var apiModel : ApiModel<[DDUserModel]>?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "更多伙伴"
        self.configTableView()
        requestApi()
    }
    func requestApi() {
        DDRequestManager.share.choosePartnerAndAppoint(type: ApiModel<[DDUserModel]>.self, keyWord: self.userInfo as? String ?? "") { (model ) in
            self.apiModel = model
            self.tableView.reloadData()
        }
    }

    func configTableView() {
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
    }
    @objc func loadMore()  {
        self.pageNum += 1
        
    }
    @objc func performRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.pageNum = 0
            
        }
    }
}

extension DDSMUserMoreVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mylog(indexPath)
        if let tempModel = apiModel?.data?[indexPath.row]{
            self.navigationController?.pushVC(vcIdentifier: "DDPartnerDetailVC", userInfo: ["type":DDPartnerDetailVC.DDPartnerDetailFuncType.friendDetail , "id":tempModel.id] )
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = apiModel?.data?[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDPartnerListCell") as? DDPartnerListCell{
            cell.model = model
            return cell
        }else{
            let cell = DDPartnerListCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDPartnerListCell")
            cell.model = model
            return cell
        }
    }
}


