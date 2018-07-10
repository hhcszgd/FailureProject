//
//  DDCustomUnitPayVC.swift
//  Project
//
//  Created by WY on 2018/6/6.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDCustomUnitPayVC: DDNormalVC {
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    var apiModel : ApiModel<[AppointPartnerCellModel]>?
    var whetherStart = "0"
    var orderID  = ""
    ///0私密 1公开
    var publicOrPrivate  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "报酬列表"
        _addSubviews()
        //        ["whetherStart": whetherStart , "orderID":self.orderID]
        if let dict = userInfo as? [String : String]{
            self.whetherStart = dict["whetherStart"] ?? ""
            self.orderID = dict["orderID"] ?? ""
            self.publicOrPrivate = dict["publicOrPrivate"] ?? ""
        }
        self.requestApi()
        // Do any additional setup after loading the view.
    }
    func requestApi() {
        DDRequestManager.share.seeUnitPriceDetail(type: ApiModel<[AppointPartnerCellModel]>.self, order_id: self.orderID) { (model ) in
            if model?.status ?? 0 == 200{
                
                self.apiModel = model
                self.tableView.reloadData()
            }else{
                GDAlertView.alert(model?.message, image: nil , time: 2 , complateBlock: nil)
            }
        }
        
//        DDRequestManager.share.morePartnersInAppointDetail(type: ApiModel<[AppointPartnerCellModel]>.self , order_id: self.orderID) { (model ) in
//            self.apiModel = model
//            self.tableView.reloadData()
//        }
    }
    func _addSubviews() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("#f0f0f0")
        self.tableView.backgroundColor = self.view.backgroundColor
        let tableViewH : CGFloat = self.view.bounds.height - DDNavigationBarHeight - DDSliderHeight
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : tableViewH)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension DDCustomUnitPayVC : UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel?.data?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var rowModel = self.apiModel?.data?[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AppointPartnerCell") as? AppointPartnerCell{
            cell.model = rowModel
            return cell
        }else{
            let cell = AppointPartnerCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "AppointPartnerCell")
            cell.model = rowModel
            return cell
        }
    }
}
extension DDCustomUnitPayVC{

    class AppointPartnerCell: DDTableViewCell {
        let icon = UIImageView()
        let name = UILabel()
        let mobile = UILabel()
        ///price
        let status = UILabel()
        let bottomLine = UIView()
        var model : AppointPartnerCellModel?{
            didSet{
                icon.setImageUrl(url: model?.head_images)
                name.text = model?.nickname
                mobile.text = model?.mobile
                status.text = model?.price_one
                layoutIfNeeded()
                setNeedsLayout()
            }
        }
        func setStatusColor(color:UIColor) {
            self.status.textColor = color
            self.status.layer.borderColor = color.cgColor
            self.status.layer.borderWidth = 0.5
            self.status.layer.cornerRadius = 5
        }
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style , reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(icon)
            self.contentView.addSubview(name)
            self.contentView.addSubview(mobile)
            self.contentView.addSubview(status)
            self.contentView.addSubview(bottomLine)
            bottomLine.backgroundColor = UIColor.DDLightGray
            status.textAlignment = .center
            name.textColor = UIColor.DDSubTitleColor
            mobile.textColor = UIColor.DDSubTitleColor
            status.textColor = UIColor.DDSubTitleColor
            name.font = UIFont.systemFont(ofSize: 15)
            mobile.font = UIFont.systemFont(ofSize: 15)
            status.font = UIFont.systemFont(ofSize: 13)
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let marginToBorder : CGFloat = 10
            icon.frame = CGRect(x: marginToBorder, y: marginToBorder, width: self.bounds.height - marginToBorder * 2, height: self.bounds.height - marginToBorder * 2)
            name.sizeToFit()
            mobile.sizeToFit()
            name.frame = CGRect(x: icon.frame.maxX + marginToBorder, y: marginToBorder, width: name.bounds.width, height: 20)
            mobile.frame = CGRect(x: icon.frame.maxX + marginToBorder, y: icon.frame.maxY - 20, width: mobile.bounds.width, height: 20)
                status.sizeToFit()
                status.bounds = CGRect(x: 0, y: 0, width: status.bounds.width + marginToBorder * 2, height: 24)
                status.center = CGPoint(x: self.bounds.width - marginToBorder - status.bounds.width/2, y: self.bounds.height/2)
            bottomLine.frame = CGRect(x: 0, y: self.bounds.height - 2, width: self.bounds.width, height: 2)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    struct AppointPartnerCellModel : Codable {
        var nickname: String? // 用户姓名
        var head_images: String? //   用户头像
        var mobile : String? //     用户手机号
        var price_one : String? // 金额
    }
    
}
