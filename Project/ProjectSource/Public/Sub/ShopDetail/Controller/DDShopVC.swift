//
//  DDShopVC.swift
//  Project
//
//  Created by WY on 2017/12/15.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
import CoreLocation
class DDShopVC: DDNoNavibarVC {
    var pageNum : Int  = 0
    var nearbyApiModel = DDNearbyApiModel(){
        didSet{
            if let shops = nearbyApiModel.data.shops , shops.count > 0{
                self.tuiJianShops.append(contentsOf: shops)
                if  tableDataSource.last is [DDNearbyShopModel]{
                    tableDataSource.removeLast()
                }
                tableDataSource.append(self.tuiJianShops as AnyObject)
                self.tableView?.gdLoadControl?.endLoad(result: GDLoadResult.success)
//                self.tableView?.reloadData()
            }else{
                /*noMoreData*/
                self.tableView?.gdLoadControl?.endLoad(result: GDLoadResult.nomore)
//                self.tableView?.reloadData()
            }
        }
    }
    var tuiJianShops = [DDNearbyShopModel]()
    
    var shopID :String = ""
    let backBtn = UIButton.init(frame: CGRect.zero)
    let likeBtn = UIButton.init(frame: CGRect.zero)
    let shareBtn = UIButton.init(frame: CGRect.zero)
    let addBtn =  UIButton.init(frame: CGRect.zero)
    let titleLbl = UILabel.init(frame: CGRect.zero)
    let tableHeader = DDShopHeaderView.init(frame: CGRect.zero)
    var shopApiModel = DDShopApiModel(){
        didSet{
            tableDataSource.removeAll()
            titleLbl.text = shopApiModel.data.first?.shop_name
            if let goods  = shopApiModel.data.first?.goods {
                tableDataSource.append(goods as AnyObject)
            }
            if let binding  = shopApiModel.data.first?.binding {
                tableDataSource.append(binding as AnyObject)
            }
            if let comment  = shopApiModel.data.first?.comment {
                tableDataSource.append(comment as AnyObject)
            }
        }
    }
    
    var tableDataSource : [AnyObject] = [AnyObject]()
    convenience init(shopID:String){
        self.init()
        self.shopID = shopID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNaviBar()
        configTableView()
        // Do any additional setup after loading the view.
        DDRequestManager.share.shopDetail(shopID: "1" , true )?.responseJSON(completionHandler: { (response ) in
            let jsonDecoder = JSONDecoder.init()
            do{
                let shopApiModel = try jsonDecoder.decode(DDShopApiModel.self , from: response.data ?? Data())
                self.shopApiModel = shopApiModel
//                self.tableView?.reloadData()
                mylog(shopApiModel)
                self.tableHeader.shopApiModel =  shopApiModel
                self.loadMore()
                mylog(shopApiModel.data.first?.comment.first?.images)
                mylog(shopApiModel.data.first?.comment.first?.achieve)
            }catch{
                mylog(error)
            }
        })
    }
    @objc func refresh()  {
        self.tableView?.gdRefreshControl?.endRefresh(result: GDRefreshResult.success)
    }
    @objc func loadMore()  {
        self.pageNum += 1
        let latitude = CLLocationDegrees( shopApiModel.data.first?.shop_lat ?? "")
        let longitude = CLLocationDegrees(shopApiModel.data.first?.shop_lon ?? "")
        let coordinate = CLLocationCoordinate2D.init(latitude: latitude ?? 0, longitude: longitude ?? 0)
        DDRequestManager.share.homepageNearbyShops(page:pageNum ,coordinate:coordinate , true )?.responseJSON(completionHandler: { (response) in
            //        mylog(response.value)
            switch response.result {
            case .success:
                let decode = JSONDecoder.init()
                do{
                    let nearbyApiModel = try decode.decode(DDNearbyApiModel.self, from: response.data ?? Data() )
                    self.nearbyApiModel = nearbyApiModel
                }catch{
                    mylog(error)
                    self.tableView?.gdLoadControl?.endLoad(result: GDLoadResult.failure)
                }
                self.tableView?.reloadData()
            case .failure(let error):
                print(error)
                
                self.tableView?.gdLoadControl?.endLoad(result: GDLoadResult.failure)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func contentOffsetChanged(scrollView: UIScrollView, contentOffset: CGPoint) {
        if contentOffset.y < 200 {
            self.changeShareBtnStatus(false)
        }else{
            self.changeShareBtnStatus(true)
        }
    }
}
///ui
extension DDShopVC{
    func configNaviBar() {
        self.naviBar.addSubview(backBtn)
        self.naviBar.addSubview(likeBtn)
        self.naviBar.addSubview(shareBtn)
        self.naviBar.addSubview(addBtn)
        self.naviBar.addSubview(titleLbl)
        self.likeBtn.setImage(UIImage(named:"unselectedcollection"), for: UIControlState.normal)
        self.likeBtn.setImage(UIImage(named:"heart_icon"), for: UIControlState.selected)
        self.shareBtn.setImage(UIImage(named:"share_icon"), for: UIControlState.normal)
        self.addBtn.setImage(UIImage(named:"plus_icon"), for: UIControlState.normal)
        
        backBtn.frame = CGRect(x: 10, y: self.naviBar.height - 44, width: 44, height: 44)
        backBtn.setImage(UIImage(named: "back_icon"), for: UIControlState.normal)
        backBtn.addTarget(self , action: #selector(goback), for: UIControlEvents.touchUpInside)
        self.naviBar.backgroundColor = .clear
        
        likeBtn.frame = CGRect(x: naviBar.bounds.width - 44 * 2 , y: naviBar.height - 44, width: 44, height: 44)
        
        shareBtn.frame = CGRect(x: naviBar.bounds.width - 44 , y: naviBar.height - 44, width: 44, height: 44)
        addBtn.frame = CGRect(x: naviBar.bounds.width - 44 , y: naviBar.height - 44, width: 44, height: 44)
        addBtn.addTarget(self , action: #selector(addBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        addBtn.adjustsImageWhenHighlighted = false
        
        likeBtn.addTarget(self , action: #selector(lickBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        shareBtn.addTarget(self , action: #selector(shareBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        
        titleLbl.frame = CGRect(x: backBtn.frame.maxX , y: backBtn.frame.origin.y, width: likeBtn.frame.minX - backBtn.frame.maxX, height: 44)
//        titleLbl.text = "this is the title of current shop"
        titleLbl.textColor = UIColor.white
        changeShareBtnStatus()
    }
    func configTableView() {

        self.tableView = UITableView.init(frame: CGRect(x: 0, y: DDStatusBarHeight, width:  self.view.bounds.width, height:  self.view.bounds.height - DDStatusBarHeight - 44), style: UITableViewStyle.grouped)
        self.view.addSubview(tableView!)
        
        self.tableView?.estimatedRowHeight = 0;
        self.tableView?.estimatedSectionHeaderHeight = 0;
        self.tableView?.estimatedSectionFooterHeight = 0;
        self.tableView?.separatorStyle = .none
        self.tableView?.gdLoadControl = GDLoadControl.init(target: self , selector: #selector(loadMore))
        self.tableView?.gdRefreshControl = GDRefreshControl.init(target: self , selector: #selector(refresh))
        tableView?.delegate = self
        tableView?.dataSource = self
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableHeader.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH , height: SCREENWIDTH * 1.1 )
        tableHeader.backgroundColor = UIColor.white
        self.tableView?.tableHeaderView = tableHeader
    }
    
}
/// actions
extension DDShopVC{
    
    @objc func lickBtnClick(sender:UIButton){
        
        sender.isSelected = !sender.isSelected
        self.tableView?.reloadData()
    }
    @objc func shareBtnClick(sender:UIButton){}
    func changeShareBtnStatus(_ status:Bool = false)  {
        shareBtn.isHidden = status
        addBtn.isHidden = !status
        titleLbl.isHidden = !status
        if status {
            self.naviBar.backgroundColor = UIColor.orange.withAlphaComponent(1)
        }else{
            self.naviBar.backgroundColor = UIColor.orange.withAlphaComponent(0)
        }
    }
    @objc func addBtnClick(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            UIView.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
            })
        }else{
            UIView.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform.identity
            })
        }
    }
    @objc func goback()  {
        self.popToPreviousVC()
    }
}

extension DDShopVC :UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let goodses =  tableDataSource[indexPath.section]  as? [DDShopGoodsModel]{
//            //            let goods = goodses[indexPath.row]
//        }
//        if let bindings = tableDataSource[indexPath.section]  as? [DDShopBindingModel]{
//            //            let binding = bindings[indexPath.row]
//        }
        if let comments = tableDataSource[indexPath.section] as? [DDShopCommentModel]{
            let comment = comments[indexPath.row]
        self.navigationController?.pushViewController(DDCommentDetailVC.init(comment.id), animated: true)
        }
        if let shops = tableDataSource[indexPath.section] as? [DDNearbyShopModel]{
            let shopID = shops[indexPath.row].id
            self.navigationController?.pushViewController(DDShopVC.init(shopID: "\(shopID)"), animated: true)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let nearbyShops = tableDataSource.last as? [DDNearbyShopModel] , nearbyShops.count == 0{
            tableDataSource.removeLast()
        }
        return tableDataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableDataSource[section] is [DDShopGoodsModel]{return 1}
        if tableDataSource[section] is [DDShopBindingModel]{return 1}
        if let comment = tableDataSource[section] as? [DDShopCommentModel]{return comment.count}
        if let shops = tableDataSource[section] as? [DDNearbyShopModel]{return shops.count}
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let goodses =  tableDataSource[indexPath.section]  as? [DDShopGoodsModel]{
            //            let goods = goodses[indexPath.row]
            if let cell  = tableView.dequeueReusableCell(withIdentifier: "DDShopHorizontalGoodsCell") as? DDShopHorizontalGoodsCell{
                cell.models = goodses
                return cell
            }else{
                let cell =   DDShopHorizontalGoodsCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDShopHorizontalGoodsCell")
                cell.models = goodses
                return cell
            }
        }
        if let bindings = tableDataSource[indexPath.section]  as? [DDShopBindingModel]{
//            let binding = bindings[indexPath.row]
            if let cell  = tableView.dequeueReusableCell(withIdentifier: "DDShopEverySayCell") as? DDShopEverySayCell {
                cell.models = bindings
                return cell
            }else{
                
                let cell =   DDShopEverySayCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDShopEverySayCell")
                cell.models = bindings
//                cell.backgroundColor = UIColor.randomColor()
                return cell
            }
        }
        if let comments = tableDataSource[indexPath.section] as? [DDShopCommentModel]{
            //            let comment = comments[indexPath.row]
            if let cell  = tableView.dequeueReusableCell(withIdentifier: "DDShopCommentCell") as? DDShopCommentCell{
                cell.model = comments[indexPath.item]
                return cell
            }else{
                
                let cell =   DDShopCommentCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDShopCommentCell")
                cell.model = comments[indexPath.item]
//                cell.backgroundColor = UIColor.randomColor()
                return cell
            }
        }
        if let shops = tableDataSource[indexPath.section] as? [DDNearbyShopModel]{
            let shopModel = shops[indexPath.row]
            if let cell  = tableView.dequeueReusableCell(withIdentifier: "DDShopCell") as? DDShopCell{
                cell.shopModel = shops[indexPath.row]
                return cell
            }else{
                
                let cell =   DDShopCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDShopCell")
                cell.shopModel = shops[indexPath.row]
//                cell.backgroundColor = UIColor.randomColor()
                return cell
            }
        }
        
        if let cell  = tableView.dequeueReusableCell(withIdentifier: "DDShopCell") {
            return cell
        }else{
            let cell =   UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDShopCell")
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let goodses =  tableDataSource[indexPath.section]  as? [DDShopGoodsModel]{
//            let goods = goodses[indexPath.row]
            return 110
        }
        if let bindings = tableDataSource[indexPath.section]  as? [DDShopBindingModel]{
//            let binding = bindings[indexPath.row]
            return DDShopEverySayCell.caculateHeight(models: bindings) //动态计算
        }
        if let comments = tableDataSource[indexPath.section] as? [DDShopCommentModel]{
            let comment = comments[indexPath.row]
            return DDShopCommentCell.caculateCellHeight(model: comment) //动态计算
        }
        if let shops = tableDataSource[indexPath.section] as? [DDNearbyShopModel]{
            return 105
        }
        return 88
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header  = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DDShopSectionHeader") as? DDShopSectionHeaderView{
            header.model = setValueToSectionHeader(section: section)
            return header
        }else{
            let header = DDShopSectionHeaderView.init(reuseIdentifier: "DDShopSectionHeader")
            header.model = setValueToSectionHeader(section: section)
            return header
        }
    }
    func setValueToSectionHeader(section:Int ) ->(title :NSAttributedString? , subTitle:NSAttributedString? , actionType:Int? ){
        if tableDataSource[section] is [DDShopGoodsModel]{
            let attributeTitle = NSAttributedString.init(string: "本店提供")
            let subAttributeTitle = NSAttributedString.init(string: "查看全部")
            return (title:attributeTitle,subTitle:subAttributeTitle,actionType:1)
        }
        if tableDataSource[section] is [DDShopBindingModel]{
            let attributeTitle = NSAttributedString.init(string: "大家都说")
            let subAttributeTitle = NSAttributedString.init(string: "反馈")
            return (title:attributeTitle,subTitle:subAttributeTitle,actionType:2)
        }
        if tableDataSource[section] is [DDShopCommentModel]{
            let attributeTitle = NSAttributedString.init(string: "全部点评")
            let subAttributeTitle = NSAttributedString.init(string: "查看全部")
            return (title:attributeTitle,subTitle:subAttributeTitle,actionType:3)
        }
        if tableDataSource[section] is [DDNearbyShopModel]{
            let attributeTitle = NSAttributedString.init(string: "更多推荐")
            return (title:attributeTitle,subTitle:nil,actionType:4)
        }
        return (title :nil  , subTitle:nil  , actionType:nil  )
    }
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        return .lightContent
//    }
}
