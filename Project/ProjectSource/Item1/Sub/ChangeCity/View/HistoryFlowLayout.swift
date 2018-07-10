//
//  HistoryFlowLayout.swift
//  zuidilao
//
//  Created by wy on 2017/11/11.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit
class HistoryFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func prepare() {
        var arrm: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        let leftPadding: CGFloat = 12.0
        let rightPadding: CGFloat = leftPadding
        var totalW: CGFloat = leftPadding
        var totalH: CGFloat = 0
        let margin: CGFloat = 10
        var leftW: CGFloat = SCREENWIDTH - totalW
        totalH += margin
        for (i, model) in self.dataArr.enumerated() {
            guard let title = model.cityName, title.characters.count > 0 else {
                return
            }
            let titleSize = title.sizeWith(font: font13, maxWidth: SCREENWIDTH - 40)
            let width = titleSize.width + 16
            let height = CGFloat(27)
            if width > leftW {
                //换行
                totalH += height + margin
                totalW = leftPadding
            }
            //不换行
            let x = totalW
            let y = totalH
            totalW += width + margin
            leftW = SCREENWIDTH - rightPadding - totalW
            let arribute = UICollectionViewLayoutAttributes.init(forCellWith: IndexPath.init(item: i, section: 0))
            arribute.frame = CGRect.init(x: x, y: y, width: width, height: height)
            arrm.append(arribute)
            
        }
        totalH += CGFloat(27) + margin
        self.contentSizeHeight = totalH
        self.arram = arrm
        
    }
    
    var arram: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    var contentSizeHeight: CGFloat = 0
    
    override var collectionViewContentSize: CGSize{
        get{
            return CGSize.init(width: SCREENWIDTH, height: self.contentSizeHeight)
        }
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.arram
    }
    var dataArr: [CityModel] = [CityModel]()

}
