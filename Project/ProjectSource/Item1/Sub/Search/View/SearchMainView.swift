//
//  SearchMainView.swift
//  zuidilao
//
//  Created by wy on 2017/10/25.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
class SearchMainView: UIView {
    
    init(withModel: SearchVieModel) {
        super.init(frame: CGRect.zero)
        self.viewModel = withModel
        configmentCol(viewModel: withModel)
        self.setUpdateUI()
        self.myCol?.backgroundColor = color4
        self.myCol?.showsVerticalScrollIndicator = false
        self.myCol?.register(SearchColCell.self, forCellWithReuseIdentifier: "SearchColCell")
        self.collectionViewDataSource(viewModel: withModel)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var layout: SearchFlowLayout!
    var myCol: UICollectionView!
    var viewModel: SearchVieModel!
    private func setUpdateUI() {
        self.addSubview(self.myCol!)
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
    }
    
    
    func configmentCol(viewModel: SearchVieModel) {
        let layout: SearchFlowLayout = SearchFlowLayout.init(data: viewModel.items.value)
        self.layout = layout
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        let col = UICollectionView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight), collectionViewLayout: layout)
        col.register(SearchColHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SearchColHeader")
        self.myCol = col
    }
    
    func collectionViewDataSource(viewModel: SearchVieModel) {
        let col = self.myCol!
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>.init(configureCell: { (dataSource , collectionView, indexPath, title) -> UICollectionViewCell in
            let cell: SearchColCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchColCell", for: indexPath) as! SearchColCell
            cell.title = title
            return cell
        }, configureSupplementaryView: { [weak self](source, collectionView, kind, indexPath) -> UICollectionReusableView in
            if kind == UICollectionElementKindSectionHeader {
                
                let header: SearchColHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SearchColHeader", for: indexPath) as! SearchColHeader
                let sectionModel = self?.viewModel.items.value[indexPath.section]
                header.viewModel = self?.viewModel
                header.title = sectionModel?.model
                if indexPath.section == 0 {
                    header.rightBtn.isHidden = true
                }else {
                    if sectionModel?.items.count == 0 {
                        header.rightBtn.isHidden = true
                    }else {
                        header.rightBtn.isHidden = false
                    }
                    
                }
                
                
                return header
            }else {
                let footer = UICollectionReusableView.init()
                return footer
            }
        })
        let _ = self.viewModel.items.asObservable().bind(to: col.rx.items(dataSource: dataSource))
        
        let indexSelect = col.rx.itemSelected
        let modelSelect = col.rx.modelSelected(String.self)
        let cellClick = Observable.zip(indexSelect, modelSelect)
        viewModel.itemClick = cellClick
        
        cellClick.subscribe { [weak self](result) in
            guard let indexPath = result.element?.0 else {
                return
            }
            guard let title = result.element?.1 else {
                return
            }
            //如果是搜索历史
            guard var dataArr = self?.viewModel.items.value else {
                return
            }
            guard var sectionModel = self?.viewModel.items.value.last else {
                return
            }
            var subitems = sectionModel.items
            if !subitems.contains(title) {
                if subitems.count > 10 {
                    subitems.removeLast()
                    subitems.insert(title, at: 0)
                }else {
                    subitems.insert(title, at: 0)
                }
                sectionModel.items = subitems
                dataArr[1] = sectionModel
                self?.viewModel.items.value = dataArr
            }

    }
//        self.viewModel.items.asObservable().subscribe { [weak self](dataArr) in
//            self?.layout?.dataArr = dataArr.element!
//            self?.myCol?.reloadData()
//        }
        
//        viewModel.getData(router: Router.post("hotSearch", nil)) { [weak self](dataArr) in
//            self?.viewModel.items.value = dataArr
//        }
//        self.viewModel.items.value = [SectionModel.init(model: "热门搜索", items: ["现在什么最火", "最火的就是这个", "不看不知道", "一看下一条"]), SectionModel.init(model: "历史搜索", items: ["干过什么蠢事", "好多了", "自己都感觉尴尬","为什么当时干出那么没脑子的事情"])]
        
        
    }
    
    override func updateConstraints() {
        self.myCol.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    deinit {
        mylog("销毁")
    }
    
    
    
}
