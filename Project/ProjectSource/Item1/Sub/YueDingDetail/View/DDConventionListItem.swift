//
//  DDConventionListItem.swift
//  Project
//
//  Created by WY on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit



protocol DDConventionListItemDelegate : NSObjectProtocol{
    
    /// invok when row is clicked
    ///
    /// - Parameters:
    ///   - indexPath: row's indexPath
    ///   - isLeft: wheather the left item or the right item
    func didSelectRowAt(indexPath : IndexPath ,cellModel:DDAppointListCellModel)
}
class DDConventionListItem: UICollectionViewCell {
    weak var delegate : DDConventionListItemDelegate?
    
    //2收款方 , 1 付款方
    var type = ""{
        didSet{
            if type == "1"{//请求 付款方 约定列表时 用 1 标识
                // qing qiu µ
                self.requestApi(type: "1")
            }else if type == "2"{//请求 收款款方 约定列表时 用 2 标识
                self.requestApi(type: "2")
            }
        }
    }
    
    
    
    private  var model : ApiModel<DDAppointListDataModel>?{
        didSet{
            self.tableView.reloadData()
        }
    }
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configTableView()
//        NotificationCenter.default.addObserver(self , selector: #selector(appointStatusChanged), name: NSNotification.Name("AppointStatusChanged"), object: nil )
    }
//    @objc func appointStatusChanged(){
//        self.requestApi(type: type)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    func requestApi(type:String)  {
//        self.tableView.gdRefreshControl?.refreshStatus = .refreshing
        DDRequestManager.share.appointListNew(type: ApiModel<DDAppointListDataModel>.self, appointType: type, success: { (model ) in
            if model.data?.item?.count ?? 0 <= 0 {
                DDErrorView(superView: self , error: DDError.noExpectData("暂无相应的约定")).automaticRemoveAfterActionHandle = {
                    self.requestApi(type: type)
                }
            }else{
                self.model = model
                for subview in self.subviews {
                    if let errorView =  subview as?  DDErrorView{
                        errorView.remove()
                    }
                }
            }
        }, failure: { (error ) in
            DDErrorView(superView: self , error: error).automaticRemoveAfterActionHandle = {
                self.requestApi(type: type)
            }
        }) {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                self.tableView.gdRefreshControl?.endRefresh()
                
//            })
        }
//        DDRequestManager.share.appointList(type: ApiModel<DDAppointListDataModel>.self, appointType: type) { (model ) in
//            if type == "1"{//收款方
//                self.model = model
//            }else if type == "2"{//付款方
//                self.model = model
//            }
//            self.tableView.gdRefreshControl?.endRefresh()
//            if model?.status ?? 0 != 200 {
//                GDAlertView.alert(model?.message, image: nil , time: 2, complateBlock: nil)
//            }
//        }
    }
    
    
    func configTableView() {
        self.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        let refresh =  GDRefreshControl.init(target: self , selector: #selector(perfomrRefresh))
        refresh.refreshHeight = 48
        self.tableView.gdRefreshControl = refresh
    }
    @objc func perfomrRefresh() {
        self.requestApi(type: self.type)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = CGRect(x:0 , y : 0 , width : self.bounds.width , height : self.bounds.height )
    }
}


extension DDConventionListItem : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == "1" {//付款方列表
            self.delegate?.didSelectRowAt(indexPath: IndexPath(item: 0, section: 0  ),cellModel: self.model?.data?.item?[indexPath.row] ?? DDAppointListCellModel())
        }else if type == "2"{//收款方款方
            
            self.delegate?.didSelectRowAt(indexPath: IndexPath(item: 1, section: 0  ),cellModel: self.model?.data?.item?[indexPath.row] ?? DDAppointListCellModel())
        }else{mylog("收付款方不明确")}
        //        rootNaviVC?.pushViewController(DDConventionVC(), animated: true )
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.data?.item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = self.model?.data?.item?[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDConventionCell") as? DDConventionCell{
            cell.backgroundColor = indexPath.row % 2 == 0 ?  UIColor.white : UIColor.colorWithHexStringSwift("edf5f9")
            cell.model = cellModel
            return cell
        }else{
            let cell = DDConventionCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDConventionCell")
            
            cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor.colorWithHexStringSwift("edf5f9") 
            cell.model = cellModel
            return cell
        }
    }
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
    //        switch editingStyle {
    //        case .delete:
    //            mylog("delete")
    //        default:
    //            break
    //        }
    //    }
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle{
    //        return UITableViewCellEditingStyle.delete
    //    }
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
    //        let action1 = UITableViewRowAction.init(style: UITableViewRowActionStyle.default, title: "delete") { (action , indexPath) in
    //            mylog("delete")
    //        }
    //        action1.backgroundColor = UIColor.DDThemeColor
    //        return [action1]
    //    }
}
class DDConventionCell : UITableViewCell {
    var model : DDAppointListCellModel?{
        didSet{
            conventionNumTitle.text = model?.key_code// "约定号:"
            conventionNameTitle.text = model?.key_name// "约定名称:"
            moneyTitle.text =  model?.key_price //"金额:"
            
            conventionNumValue.text = model?.value_code // "x189912387469817239847"
            conventionNameValue.text = model?.value_name //"this is convention name"
            moneyValue.text = model?.value_price//"¥1000.00"
            conventionStatusTitle.text = model?.key_status
            conventionStatusValue.text = model?.values_status
            if let publicOrPrivate = model?.type{
                switch publicOrPrivate {
                case "0":
                         conventionType.text = nil // "私密约定"
                case "1":
                    conventionType.text = "公开约定"
                default:
                  conventionType.text = "nil"
                }
            }else{conventionType.text = "nil"}
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    let conventionNumTitle = UILabel()
    let conventionNameTitle = UILabel()
    let moneyTitle = UILabel()
    
    
    let conventionNumValue = UILabel()
    let conventionNameValue = UILabel()
    let moneyValue = UILabel()
    
    let conventionStatusValue = UILabel()
    let conventionStatusTitle = UILabel()
    ///单人约,群约
    let conventionType = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        self.contentView.backgroundColor = UIColor.randomColor()
        self.selectionStyle = .none
        self.contentView.addSubview(conventionNumTitle)
        self.contentView.addSubview(conventionNameTitle)
        self.contentView.addSubview(moneyTitle)
        
        self.contentView.addSubview(conventionNumValue)
        self.contentView.addSubview(conventionNameValue)
        self.contentView.addSubview(moneyValue)
        
        self.contentView.addSubview(conventionStatusTitle)
        self.contentView.addSubview(conventionStatusValue)
        self.contentView.addSubview(conventionType)
        
        
        conventionNumTitle.textColor = UIColor.DDTitleColor
        conventionNameTitle.textColor = UIColor.DDTitleColor
        moneyTitle.textColor = UIColor.DDTitleColor
        conventionStatusTitle.textColor = UIColor.DDTitleColor
        
        conventionNumValue.textColor = UIColor.DDSubTitleColor
        conventionNameValue.textColor = UIColor.DDSubTitleColor
        moneyValue.textColor = UIColor.DDSubTitleColor
        conventionStatusValue.textColor = UIColor.DDThemeColor
        conventionType.textColor = .red
        
        conventionNumTitle.font = UIFont.systemFont(ofSize: 16)
        conventionNameTitle.font = UIFont.systemFont(ofSize: 16)
        moneyTitle.font = UIFont.systemFont(ofSize: 16)
        conventionStatusTitle.font = UIFont.systemFont(ofSize: 16)
        
        conventionNumValue.font = UIFont.systemFont(ofSize: 15)
        conventionNameValue.font = UIFont.systemFont(ofSize: 15)
        moneyValue.font = UIFont.systemFont(ofSize: 15)
        conventionStatusValue.font = UIFont.systemFont(ofSize: 15)
        conventionType.font = UIFont.systemFont(ofSize: 13)
        
        //        conventionNumTitle.text = "约定号:"
        //        conventionNameTitle.text = "约定名称:"
        //        moneyTitle.text = "金额:"
        //
        //        conventionNumValue.text = "x189912387469817239847"
        //        conventionNameValue.text = "this is convention name"
        //        moneyValue.text = "¥1000.00"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10
        let verticalH : CGFloat = 5
        let H = (self.bounds.height - verticalH * 2) / 4
        conventionNumTitle.ddSizeToFit()
        conventionNameTitle.ddSizeToFit()
        moneyTitle.ddSizeToFit()
        
        let titleMaxW = max(conventionNumTitle.bounds.width, conventionNameTitle.bounds.width, moneyTitle.bounds.width)
        conventionNumTitle.frame = CGRect(x: margin, y: verticalH, width: titleMaxW, height: H)
        conventionNameTitle.frame = CGRect(x: margin, y: conventionNumTitle.frame.maxY, width: titleMaxW, height: H)
        moneyTitle.frame = CGRect(x: margin, y: conventionNameTitle.frame.maxY, width: titleMaxW, height: H)
        conventionStatusTitle.frame = CGRect(x: margin, y: moneyTitle.frame.maxY, width: titleMaxW, height: H)
        
        let valueW = self.bounds.width - margin * 3 - titleMaxW
        let valueX = moneyTitle.frame.maxX + margin
        
        conventionNumValue.frame = CGRect(x: valueX, y: verticalH, width: valueW, height: H)
        conventionNameValue.frame = CGRect(x: valueX, y: conventionNumValue.frame.maxY, width: valueW, height: H)
        moneyValue.frame = CGRect(x: valueX, y: conventionNameValue.frame.maxY, width: valueW, height: H)
        conventionStatusValue.frame = CGRect(x: valueX, y:moneyValue.frame.maxY, width: valueW, height: H)
        conventionType.sizeToFit()
        conventionType.center = CGPoint(x: self.bounds.width - margin - conventionType.bounds.width/2, y: conventionNumTitle.frame.midY)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

