//
//  SearchFlowLayout.swift
//  wenyouhui
//
//  Created by wy on 2017/6/6.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit
import RxDataSources
class SearchFlowLayout: UICollectionViewFlowLayout {
    init(data: [SectionModel<String, String>]){
        super.init()
        self.dataArr = data
        
    }
    override func prepare() {
        var arrm: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        let headerH: CGFloat = 44
        let leftPadding: CGFloat = 12.0
        let rightPadding: CGFloat = leftPadding
        var totalW: CGFloat = leftPadding
        var totalH: CGFloat = 0
        let margin: CGFloat = 10
        var leftW: CGFloat = SCREENWIDTH - totalW
        for (section, sectionModel) in self.dataArr.enumerated() {
            let header = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath.init(row: 0, section: section))
            header.frame = CGRect.init(x: 0, y: totalH, width: SCREENWIDTH, height: headerH)
            arrm.append(header)
            
            totalH += headerH
            let items = sectionModel.items
            for (row, title) in items.enumerated() {
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
                let arribute = UICollectionViewLayoutAttributes.init(forCellWith: IndexPath.init(item: row, section: section))
                arribute.frame = CGRect.init(x: x, y: y, width: width, height: height)
                arrm.append(arribute)
            }
            totalW = leftPadding
            //加上每组的最后一行的高度
            totalH += CGFloat(27)
            
            
        }
        
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
    var dataArr: [SectionModel<String, String>] = [SectionModel<String, String>]()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
