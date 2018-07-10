//
//  DDPayPartnersVC.swift
//  Project
//
//  Created by WY on 2018/4/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//详情页点击更多进入此视图

import UIKit

class DDPayPartnersVC: DDNormalVC {
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    var apiModel : ApiModel<[AppointPartnerCellModel]>?
    var whetherStart = "0"
    var orderID  = ""
    ///0私密 1公开
    var publicOrPrivate  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收款人列表"
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
        DDRequestManager.share.morePartnersInAppointDetail(type: ApiModel<[AppointPartnerCellModel]>.self , order_id: self.orderID) { (model ) in
            if let model = model {
                if model.status == 200{
                    self.apiModel = model
                    self.tableView.reloadData()
                }else{
                    GDAlertView.alert(model.message, image: nil , time: 2, complateBlock: nil )
                }
            }  else{
                DDErrorView(superView: self.view, error: DDError.serverError("请求失败")).automaticRemoveAfterActionHandle = {
                    self.requestApi()
                }
            }

        }
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

extension DDPayPartnersVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let  rowModel = self.apiModel?.data?[indexPath.row] , let status = rowModel.status{
            switch status {
            case  "0" , "1" :
                break
            default :
                
                if rowModel.open ?? "" == "2"{
                    self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: ["orderID": self.orderID , "userType":"2"/* 2付款方 , 1收款方*/ , "privateOrPublic":self.publicOrPrivate/*0私密约定,1公开*/ , "yue_type":"1" /*1单约  2 群约*/ , "yiFangID" : rowModel.bid ?? ""])
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel?.data?.count ?? 0
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var rowModel = self.apiModel?.data?[indexPath.row]
        rowModel?.whetherStart = self.whetherStart
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
class AppointPartnerCell: DDTableViewCell {
    let icon = UIImageView()
    let name = UILabel()
    let mobile = UILabel()
    let status = UILabel()
    let bottomLine = UIView()
    var model : AppointPartnerCellModel?{
        didSet{
            icon.setImageUrl(url: model?.blogo)
            name.text = model?.bname
            mobile.text = model?.bphone
            var statusStr = ""
            if let status = model?.status{
                if status == "0"{
                    statusStr = "待付款"
                }else if status == "1"{
                    statusStr = "招人中"
                }else if status == "2"{
                    statusStr = "约定进行中"
                }else if status == "3"{
                    statusStr = "约定有协商"
                }else if status == "5"{
                    statusStr = "已完成"
                }else if status == ""{
                    statusStr = "已关闭"
                }
                self.setStatusColor(color: UIColor.blue)
            }
            if let modify = model?.v_is_modify,modify == "1"{
                    statusStr = "报酬有修改"
                self.setStatusColor(color: UIColor.red)
            }
            if let status = model?.pay_status , status == "1"{
                 statusStr = "约定有协商"
                self.setStatusColor(color: UIColor.red)
            }
            status.text = statusStr
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
        if self.model?.whetherStart ?? "" == "0"{
            status.sizeToFit()
            status.bounds = CGRect(x: 0, y: 0, width: status.bounds.width + marginToBorder * 2, height: 24)
            status.center = CGPoint(x: self.bounds.width - marginToBorder - status.bounds.width/2, y: self.bounds.height/2)
        }else{status.frame = CGRect.zero}
        bottomLine.frame = CGRect(x: 0, y: self.bounds.height - 2, width: self.bounds.width, height: 2)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
struct AppointPartnerCellModel : Codable {
    ///0 已开工 , 否则未开工
    var whetherStart : String?
    var blogo : String? = DDTestImageUrl?.absoluteString
    var bname : String? = "name"
    var bphone  : String? = "mobile"
    var bid : String? = "协商结束"
    var status : String?
    var pay_status : String?
    var v_is_modify : String?
    /// 1 未开工 2 已开工
    var open : String?
}
