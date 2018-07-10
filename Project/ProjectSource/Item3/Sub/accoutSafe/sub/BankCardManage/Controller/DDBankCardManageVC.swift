//
//  DDBankCardManageVC.swift
//  Project
//
//  Created by WY on 2018/1/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
enum BindingBankCard {
    ///再次绑定银行卡
    case againBindingBankCard
    ///修改银行卡
    case changeBindingBankCard
    ///第一次绑定银行卡
    case firstBindingBankCard
    
}


class DDBankCardManageVC: GDNormalVC{

//    var apiModel = ApiModel<[DDBankCardModel]>.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.tableView.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "银行卡管理")
        self.configNavigation()
        configSubviews()
        self.addCardModel.backIcon = "addabankcard"
    
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestApi()
    }
    let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
    func configNavigation() {
        rightBtn.setImage(UIImage.init(named: "addicon"), for: .normal)
        rightBtn.addTarget(self, action: #selector(addBankCardClick(sender:)), for: .touchUpInside)
        rightBtn.backgroundColor = UIColor.clear
        self.naviBar.rightBarButtons = [rightBtn]
    }
    
    func switchNobankNoticeStatus(_ hidden:Bool) {
//        self.noBankCardNoticeLabel.isHidden = hidden
    }

    func requestApi() {
        let router = Router.get("Mttuserinfo/getBankcard", .api, ["token": token], nil)
        NetWork.manager.requestData(router: router, type: [DDBankCardModel].self).subscribe(onNext: { (model) in
            if model.status == 200 {
                if let data = model.data {
                    self.dataArr = data
                    if !self.dataArr.contains(self.addCardModel) {
                        self.dataArr.append(self.addCardModel)
                    }
                }
                
            }else {
                if !self.dataArr.contains(self.addCardModel) {
                    self.dataArr.append(self.addCardModel)
                }
                
            }
            self.tableView.reloadData()
        }, onError: { (error) in
            if !self.dataArr.contains(self.addCardModel) {
                self.dataArr.append(self.addCardModel)
            }
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }

    }
    var dataArr: [DDBankCardModel] = [DDBankCardModel]()
    let addCardModel = DDBankCardModel.init()
    
    
    func configSubviews()  {
        self.view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: DDNavigationBarHeight + 10, width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight - 10 - 10)
        tableView.register(BankCardCell.self, forCellReuseIdentifier: "systemCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
    
        
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addBankCardClick(sender: UIButton){
        mylog("add bank card click")
//        if self.dataArr.count == 0 {
//
//        }else {
//            let vc = ChangeBankCardVC()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        let vc = DDAdBankCardVC()
        //        vc.doneHandle = {self.requestApi()}
        self.navigationController?.pushViewController(vc, animated: true )
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.dataArr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell : BankCardCell!
        if let cell = tableView.dequeueReusableCell(withIdentifier: "systemCell") as? BankCardCell{
            returnCell = cell
        }else{
            let cell = BankCardCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "systemCell")
            returnCell = cell
        }
        returnCell.model = self.dataArr[indexPath.row]
        returnCell.delegate = self
        returnCell.textLabel?.textColor = UIColor.DDSubTitleColor
        returnCell.selectionStyle = .none
        return returnCell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.dataArr.count - 1) == indexPath.row {
            self.addBankCardClick(sender: self.rightBtn)
        }
    }
    

    
}

class BankCardCell: DDTableViewCell {
    var model : DDBankCardModel = DDBankCardModel(){
        didSet{
            
            
            if model.backIcon == nil {
                if let url  = URL(string:model.icon ?? "") {
                    bankLogo.sd_setImage(with: url)
                    
                }else{
                    bankLogo.image = DDPlaceholderImage
                }
                self.contentView.subviews.forEach { (subView) in
                    subView.isHidden = false
                }
                if let url  = URL(string:model.backicon ?? "") {
                    backImage.sd_setImage(with: url)
                    
                }else{
                    backImage.image = DDPlaceholderImage
                }
                bankName.text = model.bank
                bankType.text = ""
                bandCardNum.text = model.card_number ?? ""
                
            }else {
                self.contentView.subviews.forEach { (subView) in
                    if subView == self.backImage {
                        subView.isHidden = false
                    }else {
                        subView.isHidden = true
                    }
                }
                self.backImage.image = UIImage.init(named: model.backIcon!)
            }
            
            
        }
    }
    weak var delegate : BankCardCellDelegate?
    let backImage = UIImageView()
    let bankLogo = UIImageView()
    let bankName = UILabel()
    let bankType = UILabel()
    let bandCardNum = UILabel()
    let UntieButton = UIButton()
//    @objc let changeBtn = UIButton.init()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(backImage)
        self.contentView.addSubview(bankLogo)
        self.contentView.addSubview(bankName)
        self.contentView.addSubview(bankType)
        self.contentView.addSubview(bandCardNum)
        self.contentView.addSubview(UntieButton)
//        self.contentView.addSubview(self.changeBtn)
        UntieButton.addTarget(self , action: #selector(untieButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        bankName.textColor = .white
        bankType.textColor = .white
        bandCardNum.textColor = .white
        
        bankName.text = "招商银行"
        bankType.text = ""
        bandCardNum.text = "**** **** **** 2238"
        UntieButton.setTitle("解除绑定", for: UIControlState.normal)
        UntieButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        UntieButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        UntieButton.setImage(UIImage.init(named: "unbind"), for: .normal)
        bankLogo.image = UIImage(named:"installbusinessicons")
        
//        changeBtn.addTarget(self, action: #selector(changeAction(sender:)), for: .touchUpInside)
//        changeBtn.setTitle("修改", for: .normal)
//        changeBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//        changeBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//        changeBtn.setTitleColor(UIColor.white, for: .normal)
//        changeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//
        bankName.font = UIFont.systemFont(ofSize: 15)
        bankType.font = UIFont.systemFont(ofSize: 13)
        bandCardNum.font = UIFont.systemFont(ofSize: 17)
        
        self.backImage.layer.masksToBounds = true
        self.backImage.layer.cornerRadius = 3
        self.backImage.backgroundColor = UIColor.white
        self.backImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
        }
        self.backImage.contentMode = UIViewContentMode.scaleToFill
        self.bankLogo.snp.makeConstraints { (make) in
            make.top.equalTo(self.backImage.snp.top).offset(8)
            make.left.equalTo(self.backImage.snp.left).offset(8)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        self.bankName.sizeToFit()
        self.bankName.snp.makeConstraints { (make) in
            make.left.equalTo(self.bankLogo.snp.right).offset(12)
            make.top.equalTo(self.backImage.snp.top).offset(12)
            make.right.equalTo(self.UntieButton.snp.left)
            
        }
        self.bankType.sizeToFit()
        self.bankType.snp.makeConstraints { (make) in
            make.left.equalTo(self.bankName.snp.left).offset(0)
            make.top.equalTo(self.bankName.snp.bottom).offset(7)
        }
        self.UntieButton.snp.makeConstraints { (make) in
            let right = (DDDevice.type == .iPhone5) ? -5 : -10
            make.right.equalTo(self.backImage.snp.right).offset(right)
            make.centerY.equalTo(self.bankName.snp.centerY)
            make.width.equalTo(95)
            make.height.equalTo(30)
        }
//        self.changeBtn.snp.makeConstraints { (make) in
//            let right = (DDDevice.type == .iPhone5) ? -5 : -10
//            make.right.equalTo(self.UntieButton.snp.left).offset(right)
//            make.centerY.equalTo(self.bankName.snp.centerY)
//            make.width.equalTo(50)
//            make.height.equalTo(30)
//        }
        
        self.bandCardNum.snp.makeConstraints { (make) in
            make.left.equalTo(self.bankName.snp.left)
            make.bottom.equalTo(self.backImage.snp.bottom).offset(-10)
        }
        
    }
    
    @objc func changeAction(sender: UIButton) {
        self.delegate?.changebankCard(cell: self)
    }
    
    
    @objc func untieButtonClick(sender:UIButton){
        self.delegate?.untieBankCard(cell: self )
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



protocol BankCardCellDelegate : NSObjectProtocol {
    func untieBankCard(cell : BankCardCell)
    func changebankCard(cell: BankCardCell)
}
extension DDBankCardManageVC : BankCardCellDelegate{
    func untieBankCard(cell : BankCardCell){
        
        let alertVC = UIAlertController.init(title: "确定解除绑定", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action ) in

        }
        let confirmAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.destructive) { (action ) in

            if let indexPath = self.tableView.indexPath(for: cell){
                let model  = self.dataArr[indexPath.row]
                guard let bankID = model.id else {
                    return
                }
                let paramete = ["token": token, "id": bankID]
                let router = Router.put("Mttupdateinfo/removecard", .api, paramete, nil)
                NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
                    if model.status == 200 {
                        self.dataArr.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
                    }else {
                        
                    }
                }, onError: { (error) in
                    mylog(error)
                }, onCompleted: {
                    mylog("结束")
                }, onDisposed: {
                    mylog("回收")
                })
                
            }
        }
        alertVC.addAction(cancleAction)
        alertVC.addAction(confirmAction)
        self.present(alertVC, animated: true , completion: nil )
        
    }
    func changebankCard(cell: BankCardCell) {
        let alertVC = UIAlertController.init(title: "确定解除绑定", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action ) in
            
        }
        let confirmAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.destructive) { (action ) in
            
            if let indexPath = self.tableView.indexPath(for: cell){
                let model  = self.dataArr[indexPath.row]
                guard let bankID = model.id else {
                    return
                }
                let paramete = ["token": token, "id": bankID]
                let router = Router.put("Mttupdateinfo/removecard", .api, paramete, nil)
                NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
                    if model.status == 200 {
                        self.dataArr.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
                    }else {
                        
                    }
                }, onError: { (error) in
                    mylog(error)
                }, onCompleted: {
                    mylog("结束")
                }, onDisposed: {
                    mylog("回收")
                })
                
            }
        }
        alertVC.addAction(cancleAction)
        alertVC.addAction(confirmAction)
        self.present(alertVC, animated: true , completion: nil )
    }
    
    
    
}
