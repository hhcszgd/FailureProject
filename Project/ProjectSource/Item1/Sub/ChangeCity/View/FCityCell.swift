//
//  FCityCell.swift
//  zuidilao
//
//  Created by wy on 2017/11/9.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit
class FCityCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    var modelCliclk: ((CityModel) -> ())!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.configCollection()
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.collectionView.backgroundColor = ashColor
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CityColCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityColCell", for: indexPath) as! CityColCell
        cell.model = items[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cityModel = self.items[indexPath.item]
        self.modelCliclk(cityModel)
    }
    
    func configCollection() {
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.register(CityColCell.self, forCellWithReuseIdentifier: "CityColCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.contentView.addSubview(collectionView)
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    var collectionView: UICollectionView!
    let layout: HistoryFlowLayout = HistoryFlowLayout.init()
    var items: [CityModel] = [CityModel]() {
        didSet{
            self.layout.dataArr = items
            self.collectionView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
