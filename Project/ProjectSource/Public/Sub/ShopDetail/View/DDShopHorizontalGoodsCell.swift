//
//  DDShopHorizontalGoodsCell.swift
//  Project
//
//  Created by WY on 2017/12/20.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class DDShopHorizontalGoodsCell: DDTableViewCell {
    let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var models  : [DDShopGoodsModel] = [DDShopGoodsModel](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        self.prepareSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func prepareSubviews() {
        collectionView.frame = frame
        self.addSubview(collectionView)
        collectionView.alwaysBounceHorizontal = true 
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HorizontalScrollGoods.self , forCellWithReuseIdentifier: "HorizontalScrollGoods")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupCollectionFrame()
    }
    func setupCollectionFrame()  {
        collectionView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize =  CGSize(width: self.collectionView.bounds.height , height: self.collectionView.bounds.height)
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        }
    }

}
import SDWebImage
extension DDShopHorizontalGoodsCell : UICollectionViewDataSource , UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return models.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.delegate?.topImageClick(headerView: self, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let model = models[indexPath.item]
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalScrollGoods", for: indexPath)
        if let itemUnwrap = item as? HorizontalScrollGoods {
            itemUnwrap.model  = model
        }
        return item
    }
    
    class HorizontalScrollGoods: UICollectionViewCell {
        let imageView = UIImageView()
        let price = UILabel()
        let name = UILabel()
        var model  = DDShopGoodsModel(){
            didSet{
                price.text = model.goods_price
                name.text = model.goods_name
                if let url = URL(string : model.goods_img ){
                    imageView.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (image , error , imageCacheType, url) in}
                }else{
                    mylog("fuck")
                    imageView.image = DDPlaceholderImage
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.addSubview(imageView)
            imageView.contentMode = .scaleAspectFill
            self.contentView.addSubview(price)
            self.contentView.addSubview(name)
            imageView.backgroundColor = UIColor.randomColor()
            price.textAlignment = NSTextAlignment.right
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let margin : CGFloat = 5
            self.imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height * 0.8)
            self.price.frame = CGRect(x: 0, y: imageView.frame.maxY - 22, width: imageView.frame.width - margin, height: 22)
            self.name.frame = CGRect(x: margin, y: imageView.frame.maxY, width: self.bounds.width - margin * 2, height: self.bounds.height - imageView.frame.maxY - margin )
            
        }
    }
}
