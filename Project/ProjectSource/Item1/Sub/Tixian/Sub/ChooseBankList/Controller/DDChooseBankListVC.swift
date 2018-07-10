//
//  DDChooseBankListVC.swift
//  Project
//
//  Created by WY on 2018/1/29.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class DDChooseBankListVC: DDNormalVC {
    var doneHandle : ((DDGetCashPageDataModel)->())?
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    var apiModel : ApiModel<[DDBankCardModel]>?
    let noBankCardNoticeLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择银行卡"
        _configSubviews()
//        self.requestApi()
        // Do any additional setup after loading the view.
    }
    
    func requestApi() {
        mylog("获取银行卡列表")
        DDRequestManager.share.getBankCards(type:  ApiModel<[DDBankCardModel]>.self) { (model ) in
            self.apiModel = model
            let addNewCardModel = DDBankCardModel.init()
            addNewCardModel.backicon = "addabankcard"
            self.apiModel?.data?.append(addNewCardModel)
           self.tableView.reloadData()
            dump(model)
        }
//        DDRequestManager.share.getBandkCard()?.responseJSON(completionHandler: { (response) in
//            mylog(response.debugDescription)
//            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<[DDBankCardModel]>.self , from: response){
//                self.apiModel = apiModel
//                self.tableView.reloadData()
//            }
//
//        })
    }
    func _configSubviews()  {
        self.view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.reloadData()
    }
    
    deinit {
        mylog("bank card list vc disdryed")
    }
    
    
    
    
    
    
    
    
    
    
}



extension DDChooseBankListVC : UITableViewDelegate , UITableViewDataSource {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestApi()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mylog("选择银行卡并返回")
        if let model = self.apiModel?.data?[indexPath.row]{
            let tempModel = DDGetCashPageDataModel()
            if model.backicon?.hasPrefix("http") ?? false {
                tempModel.id = model.id
                tempModel.icon = model.icon
                tempModel.card_number = model.card_number
                tempModel.bank = model.bank
                self.doneHandle?(tempModel)
                self.navigationController?.popViewController(animated: true )
            }else{
                self.navigationController?.pushVC(vcIdentifier: "DDAdBankCardVC", userInfo: nil)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiModel?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell : DDChooseBankCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDChooseBankCell") as? DDChooseBankCell{
            returnCell = cell
        }else{
            let cell = DDChooseBankCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDChooseBankCell")
            returnCell = cell
        }
        if let model = self.apiModel?.data?[indexPath.row]{
            returnCell.model = model
        }
        returnCell.textLabel?.textColor = UIColor.DDSubTitleColor
        returnCell.selectionStyle = .none
        return returnCell
    }
}


class DDChooseBankCell: UITableViewCell {
    var model : DDBankCardModel = DDBankCardModel(){
        didSet{
            if model.backicon?.hasPrefix("http") ?? false {
                bankLogo.setImageUrl(url: model.icon)
                backImage.setImageUrl(url: model.backicon)
                bankName.text = model.bank
                
                var bankNum  = model.card_number ?? ""
                if let typeStr = model.type{
                    bankType.text = typeStr
                }else{
//                    bankType.text = "银行卡类型为空"
                }
                if bankNum.count >= 4{
                    bankNum.replaceSubrange( bankNum.index(bankNum.startIndex, offsetBy: 0) ..< bankNum.index(bankNum.endIndex, offsetBy: -4) , with: "**** **** **** ")
                }
                self.bankNumber.text = bankNum
                
            }else{
                backImage.image = UIImage(named:model.backicon ?? "")
                bankLogo.image = nil
                bankName.text = nil
            }
        }
    }
    let getCashContainer : UIView = UIView()
    let bankLogo = UIImageView()
    let bankName = UILabel()
    let bankType = UILabel()
    let bankNumber = UILabel()
    let backImage = UIImageView()
    //        let arrowBtn = UIButton()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(getCashContainer)
        getCashContainer.addSubview(backImage)
        backImage.isUserInteractionEnabled = false
        bankLogo.isUserInteractionEnabled = false
        bankName.isUserInteractionEnabled = false
        bankType.isUserInteractionEnabled = false
        bankNumber.isUserInteractionEnabled = false
        getCashContainer.isUserInteractionEnabled = false
        getCashContainer.addSubview(bankLogo)
        getCashContainer.addSubview(bankName)
        getCashContainer.addSubview(bankType)
        getCashContainer.addSubview(bankNumber)
        bankName.textColor = UIColor.white
        bankNumber.textColor = UIColor.white
        bankType.textColor = UIColor.white
        bankType.font = GDFont.systemFont(ofSize: 14)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let containerMargin : CGFloat = 10
        getCashContainer.frame = CGRect(x: containerMargin, y: containerMargin / 2, width: self.contentView.bounds.width - containerMargin * 2, height: self.contentView.bounds.height - containerMargin )
        backImage.frame = getCashContainer.bounds
        getCashContainer.layer.borderWidth = 2
        getCashContainer.layer.borderColor = UIColor.DDLightGray.cgColor
        
        bankLogo.frame = CGRect(x: containerMargin, y: containerMargin, width: getCashContainer.bounds.height/2, height: getCashContainer.bounds.height/2)
        bankLogo.layer.cornerRadius = bankLogo.bounds.width/2
        bankLogo.layer.masksToBounds = true
        bankName.frame = CGRect(x: bankLogo.frame.maxX + 10, y: bankLogo.frame.minY, width: getCashContainer.bounds.width
            - (bankLogo.frame.maxX + 10), height: 30)
        
        bankType.frame = CGRect(x: bankName.frame.minX, y: bankLogo.frame.midY, width: bankName.frame.width, height: 20)
        
        bankNumber.frame = CGRect(x: bankName.frame.minX, y: bankType.frame.maxY, width: bankName.frame.width, height: bankName.frame.height)
        
        //            arrowBtn.frame = CGRect(x: getCashContainer.bounds.width - 44 - containerMargin, y: bankLogo.frame.midY - 44/2, width: 44, height: 44)
        
        //            arrowBtn.setImage(UIImage(named:"enterthearrow"), for: UIControlState.normal)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
