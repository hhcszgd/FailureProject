//
//  SearchColHeader.swift
//  zuidilao
//
//  Created by wy on 2017/10/23.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift

class SearchColHeader: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel.init()
        label.sizeToFit()
        return label
    }()
    let rightBtn: UIButton = UIButton.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(rightBtn)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        self.rightBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        
    }
    var viewModel: SearchVieModel! {
        didSet {
            let tap = self.rightBtn.rx.tap
            
            tap.asObservable().subscribe { [weak self](tap) in
                guard var dataArr = self?.viewModel.items.value else {
                    return
                }
                guard var sectionModel = dataArr.last else {
                    return
                }
                sectionModel.items = [String]()
                dataArr[1] = sectionModel
                self?.viewModel.items.value = dataArr
                
            }
            self.rightBtn.backgroundColor = UIColor.red
//            let _ = self.viewModel.items.asObservable().subscribe { [weak self](dataArr) in
//                guard let arr = dataArr.element else {
//                    return
//                }
//                guard let sectionModel = arr.last else {
//                    return
//                }
//                if sectionModel.items.count == 0 {
//                    self?.rightBtn.isHidden = true
//                }else {
//                    self?.rightBtn.isHidden = false
//                }
//                
//            }
        }
    }
    var title: String? {
        didSet{
            self.titleLabel.text = title
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
