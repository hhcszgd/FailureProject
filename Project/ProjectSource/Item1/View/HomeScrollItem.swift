//
//  HomeScrollItem.swift
//  Project
//
//  Created by WY on 2017/11/29.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

protocol HomeScrollItemDelegate : NSObjectProtocol {
    func gotoShopDetail(id:Int)
}
class HomeScrollItem: UICollectionViewCell {
    weak var delegate  : HomeScrollItemDelegate?
    
    let collectionView =  UICollectionView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88), collectionViewLayout: DDHomeMidBigLayout())
    var models = [DDHotRecom](){
        didSet{
//            mylog(models.first?.article_image)
            self.collectionView.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
        if let layout  = collectionView.collectionViewLayout as? DDHomeMidBigLayout {
            layout.itemSize = CGSize(width: 250 , height: self.bounds.height)
            layout.scrollDirection = UICollectionViewScrollDirection.horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: collectionView.bounds.width/2 - layout.itemSize.width/2, bottom: 0, right: collectionView.bounds.width/2 - layout.itemSize.width/2)
        }
        collectionView.reloadData()
    }
}
extension HomeScrollItem : UICollectionViewDataSource , UICollectionViewDelegate{
    func configCollectionView() {
        self.contentView.addSubview(self.collectionView)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false 
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(HomeScrollSubItem.self , forCellWithReuseIdentifier: "HomeScrollSubItem")
        if let layout  = collectionView.collectionViewLayout as? DDHomeMidBigLayout {
            layout.itemSize = CGSize(width: 90 , height: 50)
            layout.scrollDirection = UICollectionViewScrollDirection.horizontal
//            layout.minimumLineSpacing = 0
//            layout.minimumInteritemSpacing = 0
//            layout.sectionInset = UIEdgeInsets(top: 0, left: collectionView.bounds.width/2 - layout.itemSize.width/2, bottom: 0, right: collectionView.bounds.width/2 - layout.itemSize.width/2)
        }

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScrollSubItem", for: indexPath)
        if let realItem  =  cell as? HomeScrollSubItem {
            realItem.model = models[indexPath.item]
        }
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = models[indexPath.item]
        self.delegate?.gotoShopDetail(id: model.id)
    }
}


class DDHomeMidBigLayout: UICollectionViewFlowLayout {
    //    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    //        return super.layoutAttributesForItem(at: indexPath)
    //    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let centerX = (self.collectionView?.bounds.width ?? 0) * 0.5
        
        let systemLayoutAttributes = super.layoutAttributesForElements(in: rect)
        let layoutAttributes = Array.init(systemLayoutAttributes ?? [])//用拷贝的副本
        var arrToReturn = [UICollectionViewLayoutAttributes]()
        for (_ , attribute) in layoutAttributes .enumerated() {
            let tempAttribute = attribute.copy() as! UICollectionViewLayoutAttributes//copy first
            let offsetX = (collectionView?.contentOffset.x ?? 0)
            let adjustScale : CGFloat = 900//作用是调节变大变小的速度
            let scale = 1 - abs(tempAttribute.center.x - offsetX - centerX) / ((self.collectionView?.bounds.width ?? 110) + adjustScale )
            tempAttribute.transform = CGAffineTransform.init(scaleX: scale, y: scale )
            //              var  transform   = CATransform3D()
            //            transform.m34 = scale
            //            attribute.transform3D = transform
//            let scaledHeight =
            
            let trueCenter = tempAttribute.center
            tempAttribute.center = CGPoint(x: trueCenter.x, y: (self.collectionView?.bounds.height ?? 0 ) - tempAttribute.bounds.height * 0.5 * scale)//底部对齐
            arrToReturn.append(tempAttribute)
        }
        return arrToReturn // layoutAttributes
    }
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let result = proposedContentOffset.x / self.itemSize.width //忽略itemMargin
        let offsetx = (result - CGFloat(Int(result))) * self.itemSize.width
        let cha = offsetx > self.itemSize.width/2 ? (self.itemSize.width -  offsetx) : -offsetx
        return CGPoint(x: proposedContentOffset.x + cha  + 0 , y:  0)
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {//当bounds改变是是否更新layout
        return true
    }
}
