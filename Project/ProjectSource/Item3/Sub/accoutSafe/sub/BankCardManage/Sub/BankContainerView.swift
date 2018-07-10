//
//  BankContainerView.swift
//  Project
//
//  Created by wy on 2018/4/13.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
import UIKit
class DDBankContainer: UIView ,UITableViewDelegate , UITableViewDataSource{
    var models : [DDBandBrandModel]?{
        didSet{
            self.tableView.reloadData()
            layoutIfNeeded()
        }
    }
    var currentSelectLevel : Int = 0 {
        didSet{
            mylog(currentSelectLevel)
        }
    }
    
    weak var delegate : DDBankChooseDelegate?
    let titleLabel = UILabel()
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.models?[indexPath.row] {
            self.delegate?.didSelectModel(model: model)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  returnCell : DDLevelCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDLevelCell") as? DDLevelCell{
            returnCell = cell
        }else{
            let cell = DDLevelCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDLevelCell")
            returnCell = cell
        }
        returnCell.model = models?[indexPath.row]
        
        return returnCell
    }
    let cancleBtn = UIButton.init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        let router = Router.get("Mttuserinfo/getbank", .api, ["token": token], nil)
        NetWork.manager.requestData(router: router, type: [DDBandBrandModel].self).subscribe(onNext: { (model) in
            if model.status == 200 {
                self.models = model.data
            }else {
                
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        self.titleLabel.backgroundColor = UIColor.colorWithRGB(red: 233, green: 234, blue: 236)
        self.titleLabel.text = "选择银行"
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.textColor = UIColor.colorWithHexStringSwift("333333")
        self.addSubview(titleLabel)
        self.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.addSubview(self.cancleBtn)
        self.cancleBtn.setImage( UIImage.init(named: "close"), for: .normal)
        self.cancleBtn.backgroundColor = UIColor.clear
        
        self.cancleBtn.frame = CGRect.init(x: frame.width - 40, y: 0, width: 40, height: 40)
        
        
        
    }
    init(frame: CGRect, dataArr: [DDBandBrandModel]) {
        super.init(frame: frame)
        self.models = dataArr
        self.titleLabel.backgroundColor = UIColor.colorWithRGB(red: 233, green: 234, blue: 236)
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.textColor = UIColor.colorWithHexStringSwift("333333")
        self.addSubview(titleLabel)
        self.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.addSubview(self.cancleBtn)
        self.cancleBtn.setImage( UIImage.init(named: "close"), for: .normal)
        self.cancleBtn.backgroundColor = UIColor.clear
        self.cancleBtn.frame = CGRect.init(x: frame.width - 40, y: 0, width: 40, height: 40)
    }
    deinit {
        mylog("DDBankContainer销毁")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 44)
        self.tableView.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: self.bounds.width, height: self.bounds.height - titleLabel.frame.maxY - 44 )
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
