//
//  KeywordSearchResultVC.swift
//  Project
//
//  Created by WY on 2017/12/8.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class KeywordSearchResultVC: DDNormalVC {
    var keyWord = ""
    var apiModel : DDSearchShopApiModel = DDSearchShopApiModel()
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    convenience init(keyWord:String){
        self.init()
        self.keyWord = keyWord
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviBar()
        self.configTableView()
        api()
        // Do any additional setup after loading the view.
    }
    
    func api() {
        DDRequestManager.share.performSearchShop(keyword:keyWord,true )?.responseJSON(completionHandler: { (response ) in
            let jsonDecoder : JSONDecoder = JSONDecoder.init()
            do{
            let apiModel = try  jsonDecoder.decode(DDSearchShopApiModel.self , from: response.data ?? Data())
                self.apiModel = apiModel
                self.tableView.reloadData()
            }catch{}
        })
    }
    func configTableView() {
        let tableViewH = self.navigationController?.navigationBar.bounds.height ?? 44
        tableView.frame = CGRect(x: 0, y:tableViewH , width: view.bounds.width, height: self.view.bounds.height - tableViewH)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    func configNaviBar()  {
        let searchButton =  UIBarButtonItem.init(title: "地图", style: UIBarButtonItemStyle.plain, target: self, action: #selector(gotoShopsInMap))
        searchButton.tintColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1)
        searchButton.setTitlePositionAdjustment(UIOffset.init(horizontal: 9, vertical: 0), for: UIBarMetrics.default)
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension KeywordSearchResultVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  apiModel.data.shops.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = apiModel.data.shops[indexPath.row]
//        model.average_consume = 100;
//        model.dispatching = 1;
//        model.front_image = "1.jpg"
//        model.id = 1;
//        model.online_pay = 0;
//        model.shop_label = "不错,这家sb,服务差,人丑";
//        model.shop_name = "2货集中营"
//        model.shop_score = "4.1"
//        model.shop_type = 1
//        model.sort = 3.6485956392015
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDSearchResultListCell") as? DDSearchResultListCell{
            cell.shopModel = model
            return cell
        }else{
            let cell = DDSearchResultListCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDSearchResultListCell")
            cell.shopModel = model
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mylog("selected index path : \(indexPath)")
        let model = apiModel.data.shops[indexPath.row]
        let shop = DDShopVC.init(shopID: "\(model.id)")
        self.navigationController?.pushViewController(shop, animated: true )
    }
}

import SDWebImage
class DDSearchResultListCell: UITableViewCell {
    let shopImage  = UIImageView()
    let shopName  = UILabel()
    let distance = UILabel()
    let container1 = UIView()
    let container2 = UIView()
    let bottomLine = UIImageView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(shopImage)
        self.contentView.addSubview(shopName)
        self.contentView.addSubview(distance)
        distance.font = UIFont.systemFont(ofSize: 13)
        distance.textColor = UIColor.white
        distance.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(container1)
        self.contentView.addSubview(container2)
        self.contentView.addSubview(bottomLine)
    }
    var shopModel : DDNearbyShopModel = DDNearbyShopModel(){
        didSet{
            mylog(shopModel)
            shopName.text  = shopModel.name
            distance.text = "\(shopModel.dispatching)"
            //SDWebImageOptions
            if let url  = URL(string: shopModel.front_image) {
                shopImage.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }
            let labels = splitStr(str: shopModel.label ?? "", separator: ",")
            if labels.count == self.container2.subviews.count && self.container2.subviews.count != 0  {
                for (index , label ) in self.container2.subviews.enumerated(){
                    if let  label = label as? UILabel {
                        label.text = labels[index]
                    }
                }
            }else{
                container2.subviews.forEach({ (subview ) in
                    subview.removeFromSuperview()
                })
                for (index , text) in labels.enumerated(){
                    let label = UILabel()
                    label.text = text
                    label.textColor = UIColor.colorWithHexStringSwift("#e0e0e0")
                    label.textAlignment = NSTextAlignment.center
                    label.font = UIFont.systemFont(ofSize: 13)
                    container2.addSubview(label)
                }
            }
            let grade = [shopModel.score,"\(shopModel.average_consume)"]
            if grade.count == self.container1.subviews.count && self.container1.subviews.count != 0  {
                for (index , label ) in self.container1.subviews.enumerated(){
                    if let  label = label as? UILabel {
                        label.text = grade[index]
                    }
                }
            }else{
                container1.subviews.forEach({ (subview ) in
                    subview.removeFromSuperview()
                })
                for (index , text) in grade.enumerated(){
                    let label = UILabel()
                    label.font = UIFont.systemFont(ofSize: 13)
                    label.textColor = UIColor.white
                    label.textAlignment = NSTextAlignment.center
                    label.text = text
                    container1.addSubview(label)
                }
            }
        }
        //        else{
        //            shopName.text  = nil
        //            distance.text = nil
        //            shopImage.image = nil
        //            container1.subviews.forEach({ (subview ) in
        //            subview.removeFromSuperview()
        //            })
        //            container2.subviews.forEach({ (subview ) in
        //            subview.removeFromSuperview()
        //            })
        //        }
    }
    func splitStr(str:String , separator : Character) -> [String]  {
        let result  = str.split(separator: separator, omittingEmptySubsequences: true )
        return result.flatMap { (substring ) -> String? in
            return String(substring)
        }
    }
    var model : HomeShopItemDataSource? = nil {
        didSet{
            if let model  = model  {
                shopName.text  = model.name
                distance.text = model.distance
                //SDWebImageOptions
                if let url  = URL(string: model.imageUlr) {
                    shopImage.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
                }
                if model.labels.count == self.container2.subviews.count && self.container2.subviews.count != 0  {
                    for (index , label ) in self.container2.subviews.enumerated(){
                        if let  label = label as? UILabel {
                            label.text = model.labels[index]
                        }
                    }
                }else{
                    container2.subviews.forEach({ (subview ) in
                        subview.removeFromSuperview()
                    })
                    for (index , text) in model.labels.enumerated(){
                        let label = UILabel()
                        label.text = text
                        label.textColor = UIColor.colorWithHexStringSwift("#e0e0e0")
                        label.textAlignment = NSTextAlignment.center
                        label.font = UIFont.systemFont(ofSize: 13)
                        container2.addSubview(label)
                    }
                }
                
                if model.grade.count == self.container1.subviews.count && self.container1.subviews.count != 0  {
                    for (index , label ) in self.container1.subviews.enumerated(){
                        if let  label = label as? UILabel {
                            label.text = model.grade[index]
                        }
                    }
                }else{
                    container1.subviews.forEach({ (subview ) in
                        subview.removeFromSuperview()
                    })
                    for (index , text) in model.grade.enumerated(){
                        let label = UILabel()
                        label.font = UIFont.systemFont(ofSize: 13)
                        label.textColor = UIColor.white
                        label.textAlignment = NSTextAlignment.center
                        label.text = text
                        container1.addSubview(label)
                    }
                }
            }else{
                shopName.text  = nil
                distance.text = nil
                shopImage.image = nil
                container1.subviews.forEach({ (subview ) in
                    subview.removeFromSuperview()
                })
                container2.subviews.forEach({ (subview ) in
                    subview.removeFromSuperview()
                })
            }
            layoutIfNeeded()
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let toTop : CGFloat = 10
        let imageWH = self.bounds.height - toTop * 2
        shopImage.frame = CGRect(x: toTop, y: toTop, width: imageWH, height: imageWH)
        let labelH = imageWH * 0.25
        shopName.frame = CGRect(x: shopImage.frame.maxX + toTop, y: toTop, width: (self.contentView.bounds.width - shopImage.frame.maxX) - toTop * 2, height: labelH)
        
        container1.frame = CGRect(x: shopImage.frame.maxX + toTop, y: toTop + labelH, width: (self.contentView.bounds.width - shopImage.frame.maxX) - toTop * 2, height: labelH)
        distance.ddSizeToFit(contentInset:UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) )
        
        distance.center = CGPoint(x: (shopImage.frame.maxX + toTop) + distance.bounds.width * 0.5, y: container1.frame.maxY + labelH * 0.5)
        distance.backgroundColor = UIColor.colorWithHexStringSwift("#d8d8d8")
        distance.layer.cornerRadius = 3
        distance.layer.masksToBounds = true
        container2.frame = CGRect(x: shopImage.frame.maxX + toTop, y: toTop + labelH * 3, width: (self.contentView.bounds.width - shopImage.frame.maxX) - toTop * 2, height: labelH)
        //        container2.backgroundColor = UIColor.randomColor()
        var priviousCenterX : CGFloat = 0
        var priviousW : CGFloat = 0
        let margin : CGFloat = 5
        setupLabels(view: self.container1)
        setupLabels(view: self.container2)
        
        self.bottomLine.backgroundColor = UIColor.red.withAlphaComponent(0.051)
        self.bottomLine.frame = CGRect(x: 0, y: self.contentView.bounds.height - 2, width: self.contentView.bounds.width, height: 2)
    }
    
    func setupLabels(view:UIView)  {
        var priviousCenterX : CGFloat = 0
        var priviousW : CGFloat = 0
        let margin : CGFloat = 5
        for (index , subview) in view.subviews.enumerated() {
            //            subview.sizeToFit()
            subview.ddSizeToFit(contentInset:  UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            //            let frame = subview.bounds
            //            subview.bounds = CGRect(x: 0, y: 0, width: frame.width + 10, height: frame.height )
            priviousCenterX = (priviousW * 0.5 + priviousCenterX ) + subview.bounds.width * 0.5
            //            subview.layer.cornerRadius = 5
            //            subview.layer.masksToBounds = true
            //            subview.backgroundColor = UIColor.randomColor()
            setUIStatus(containerView: view, subview: subview, index: index)
            subview.center = CGPoint(x: priviousCenterX  , y: container1.bounds.height * 0.5 )
            priviousW = subview.bounds.width
            priviousCenterX += margin
        }
    }
    
    func setUIStatus(containerView:UIView,subview:UIView ,index:Int ) {
        subview.layer.cornerRadius = 3
        subview.layer.masksToBounds = true
        if containerView == container1{
            switch index {
            case 0 :
                subview.backgroundColor = UIColor.colorWithHexStringSwift("#fca8a8")
            case 1 :
                subview.backgroundColor = UIColor.colorWithHexStringSwift("#f6c59d")
            case 2 :
                subview.backgroundColor = UIColor.colorWithHexStringSwift("#f6a7ff")
            case 3 :
                subview.backgroundColor = UIColor.colorWithHexStringSwift("#fca8a8")
            default :
                break
            }
        }else if containerView == container2{
            
            subview.layer.borderWidth = 1
            subview.layer.borderColor = UIColor.colorWithHexStringSwift("#e0e0e0").cgColor
            subview.backgroundColor = UIColor.white
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
import MapKit
extension KeywordSearchResultVC{
    @objc func gotoShopsInMap() {
        
        let mapVC = DDShopsInMapVC.init(locations: getLocations())
        self.navigationController?.pushViewController(mapVC, animated: true  )
    }
    func getLocations() -> [GDLocation] {
        let shiDaiCaifu : GDLocation = GDLocation.init()
        shiDaiCaifu.coordinate = CLLocationCoordinate2D.init(latitude: 39.83157500, longitude: 116.28728700)
        shiDaiCaifu.title = "分台区时代财富天地大厦"
        let kanDanQiao : GDLocation = GDLocation.init()
        kanDanQiao.coordinate = CLLocationCoordinate2D.init(latitude: 39.84080100, longitude: 116.28746200)
        kanDanQiao.title = "丰台区看丹桥"
       
        
        let keYiLu : GDLocation = GDLocation.init()
        keYiLu.coordinate = CLLocationCoordinate2D.init(latitude: 39.83248000, longitude: 116.29743200)
        keYiLu.title = "丰台区科怡路"
        keYiLu.subtitle = "地/铁站"
        
        
        let other : GDLocation = GDLocation.init()
        other.coordinate = CLLocationCoordinate2D.init(latitude: 39.83248000, longitude: 116.29143200)
        other.title = "other"
        other.subtitle = "xxxx"
        
        let other2 : GDLocation = GDLocation.init()
        other2.coordinate = CLLocationCoordinate2D.init(latitude: 39.83248000, longitude: 116.29343200)
        other2.title = "other2"
        other2.subtitle = "xxxx2"
        
        let other3 : GDLocation = GDLocation.init()
        other3.coordinate = CLLocationCoordinate2D.init(latitude: 39.83248000, longitude: 116.28843200)
        other3.title = "other3"
        other3.subtitle = "xxxx3"
        
        let other4 : GDLocation = GDLocation.init()
        other4.coordinate = CLLocationCoordinate2D.init(latitude: 39.83668000, longitude: 116.28843200)
        other4.title = "other4"
        other4.subtitle = "xxxx4"
        return [other2,  keYiLu, other3,shiDaiCaifu , other,kanDanQiao ,other4]
    }
}


class DDSearchShopApiModel: NSObject , Codable {
    var message = ""
    var status : Int  = -1
    var data  : DDSearchShopApiDataModel = DDSearchShopApiDataModel()
}
class DDSearchShopApiDataModel: NSObject,Codable {
    var p : Int = 0
    var tail : Int = 0
    var  shops = [DDNearbyShopModel]()
}
