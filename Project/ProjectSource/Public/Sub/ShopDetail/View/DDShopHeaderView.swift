//
//  DDShopHeaderView.swift
//  Project
//
//  Created by WY on 2017/12/19.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
protocol DDShopHeaderViewDelegate : NSObjectProtocol {
    func topImageClick(headerView: DDShopHeaderView , indexPath : IndexPath)
}
class DDShopHeaderView: UIView {
    let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let shopName = UILabel()
    let container1 = UIView()
    let openTime = UILabel()
    let address = UILabel()
    let daHuoBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 88 * SCALE, height: 40 * SCALE))
    let dianPingBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 88 * SCALE, height: 40 * SCALE))
    var shopApiModel = DDShopApiModel(){
        didSet{
            /*
             "average_consume":"50"
             "shop_classify_name":"分类1分类1111",
             "shop_score":3,
             */
            shopName.text = shopApiModel.data.first?.shop_name
            openTime.text = (shopApiModel.data.first?.business_time ?? "") + (shopApiModel.data.first?.business_day ?? "")
            address.text = shopApiModel.data.first?.address
            var labels : [String] = [String]()
            if let averageConsume =
                shopApiModel.data.first?.average_consume{labels.append(averageConsume)
            }
            if let shop_classify_name =
                shopApiModel.data.first?.shop_classify_name{labels.append(shop_classify_name)
            }
            if let shop_score =
                shopApiModel.data.first?.shop_score{labels.append(shop_score)
            }
            
            if labels.count == self.container1.subviews.count && self.container1.subviews.count != 0  {
                for (index , label ) in self.container1.subviews.enumerated(){
                    if let  label = label as? UILabel {
                        label.text = labels[index]
                    }
                }
            }else{
                container1.subviews.forEach({ (subview ) in
                    subview.removeFromSuperview()
                })
                for (index , text) in labels.enumerated(){
                    let label = UILabel()
                    label.font = GDFont.systemFont(ofSize: 13)
                    label.textColor = UIColor.white
                    label.textAlignment = NSTextAlignment.center
                    label.text = text
                    container1.addSubview(label)
                }
            }
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            collectionView.reloadData()
            
        }
    }
    
    weak var delegate : DDShopHeaderViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareSubviews()
    }
    func prepareSubviews() {
        collectionView.frame = frame
        self.addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DDShopHeaderImageItem.self , forCellWithReuseIdentifier: "DDShopHeaderImageItem")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.white
        self.addSubview(container1)
        self.addSubview(shopName)
        shopName.font = GDFont.systemFont(ofSize: 19)
        openTime.font = GDFont.systemFont(ofSize: 16)
        openTime.textColor = UIColor.DDSubTitleColor
        address.font = GDFont.systemFont(ofSize: 15)
        address.textColor = UIColor.DDSubTitleColor
        self.addSubview(openTime)
        self.addSubview(address)
        self.addSubview(daHuoBtn)
        self.addSubview(dianPingBtn)
        daHuoBtn.backgroundColor = UIColor.colorWithHexStringSwift("#fe5f5f")
        dianPingBtn.backgroundColor = UIColor.colorWithHexStringSwift("#fe5f5f")
        daHuoBtn.setTitle("搭个伙", for: UIControlState.normal)
        dianPingBtn.setTitle("点评一下", for: UIControlState.normal)
        daHuoBtn.addTarget(self , action: #selector(dahuoClick(sender:)), for: UIControlEvents.touchUpInside)
        dianPingBtn.addTarget(self , action: #selector(dianpingClick(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    func splitStr(str:String , separator : Character) -> [String]  {
        let result  = str.split(separator: separator, omittingEmptySubsequences: true )
        return result.flatMap { (substring ) -> String? in
            return String(substring)
        }
    }
    
    func setupLabels(view:UIView)  {
        var priviousCenterX : CGFloat = 0
        var priviousW : CGFloat = 0
        let margin : CGFloat = 5 * SCALE
        let container1H : CGFloat = 40 * SCALE
        for (index , subview) in view.subviews.enumerated() {
            //            subview.sizeToFit()
            subview.ddSizeToFit(contentInset:  UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            //            let frame = subview.bounds
            //            subview.bounds = CGRect(x: 0, y: 0, width: frame.width + 10, height: frame.height )
            priviousCenterX = (priviousW * 0.5 + priviousCenterX ) + subview.bounds.width * 0.5
            //            subview.layer.cornerRadius = 5
            //            subview.layer.masksToBounds = true
            //            subview.backgroundColor = UIColor.randomColor()
            setUIStatus(subview: subview, index: index)
            subview.center = CGPoint(x: priviousCenterX  , y: container1H * 0.5 )
            priviousW = subview.bounds.width
            priviousCenterX += margin
            if index == view.subviews.count - 1{
                view.bounds = CGRect(x: 0, y: 0, width: priviousW * 0.5 + priviousCenterX - margin, height: container1H)
            }
        }
    }
    func setUIStatus(subview:UIView ,index:Int ) {
        subview.layer.cornerRadius = 3
        subview.layer.masksToBounds = true
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
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let verticalMargin : CGFloat = 10 * SCALE
        self.setupCollectionFrame()
        self.shopName.ddSizeToFit()
        self.shopName.center = CGPoint(x: self.bounds.width/2, y: collectionView.frame.maxY + shopName.bounds.height/2  + verticalMargin)
        setupLabels(view: container1)
        container1.center = CGPoint(x: self.bounds.width/2, y: shopName.frame.maxY + container1.bounds.height/2)
        openTime.ddSizeToFit()
        openTime.center = CGPoint(x: self.bounds.width/2, y: container1.frame.maxY + openTime.bounds.height/2)
        address.ddSizeToFit()
        address.center = CGPoint(x: self.bounds.width/2, y: openTime.frame.maxY + address.bounds.height/2  + verticalMargin)
        
        daHuoBtn.center = CGPoint(x: self.bounds.width/2 - verticalMargin - daHuoBtn.bounds.width/2, y: address.frame.maxY + daHuoBtn.bounds.height/2 + verticalMargin)
        
        dianPingBtn.center = CGPoint(x: self.bounds.width/2 + verticalMargin + dianPingBtn.bounds.width/2, y: address.frame.maxY + dianPingBtn.bounds.height/2 + verticalMargin)
    }
    func setupCollectionFrame()  {
        collectionView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width * 0.6)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize =  self.collectionView.bounds.size
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        }
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
///actions
extension DDShopHeaderView{
    @objc func dahuoClick(sender:UIButton){
        mylog("da huo click")
    }
    @objc func dianpingClick(sender:UIButton){
        mylog("dian ping click")
        
        let para =  (shop_id:self.shopApiModel.data.first?.id ?? "",shop_name:self.shopApiModel.data.first?.shop_name ?? "" ,classify_pid : self.shopApiModel.data.first?.shop_classify_id ?? "")
        rootNaviVC?.pushViewController(DDCreateCommentVC(para: para), animated: true )
    }
}
import SDWebImage
extension DDShopHeaderView : UICollectionViewDataSource , UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return shopApiModel.data.first?.imgs.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.topImageClick(headerView: self, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let model = shopApiModel.data.first?.imgs[indexPath.item]
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "DDShopHeaderImageItem", for: indexPath)
//        item.backgroundColor = UIColor.randomColor()
        if let itemUnwrap = item as? DDShopHeaderImageItem {
//            if let url = URL(string : model?.image_url ?? ""){
            if let url = DDTestImageUrl{//待注销
                
                itemUnwrap.imageView.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (image , error , imageCacheType, url) in}
            }
            
        }
        return item
    }
    class DDShopHeaderImageItem: UICollectionViewCell {
        let imageView = UIImageView()
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(imageView)
            imageView.contentMode = .scaleAspectFill
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            self.imageView.frame = self.bounds
        }
    }
}

