//
//  ConfigPriceVC.swift
//  Project
//
//  Created by wy on 2018/4/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxCocoa
class ConfigPriceVC: DDNormalVC {

    enum ShowType:String {
        case singleSelection
        case multipleSelection
        case cancle
        case done
    }
    enum ActionType:String {
        case singleSelection
        case multipleSelection
    }
    var naviBarStartShowH : CGFloat =  DDDevice.type == .iphoneX ? 164 : 148
    var naviBarEndShowH : CGFloat = DDDevice.type == .iphoneX ? 100 : 80
    var pageNum : Int  = 0
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    var multipleSelection : Bool = false
    var showType  = ShowType.multipleSelection
    var actionType = ActionType.singleSelection
    weak var cover: DDCoverView?
    var users  : [DDUserModel]? = [DDUserModel]() {
        didSet{
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configNaviBar()
        self.configTableView()
        self.configSuperBtn()
        self.view.addSubview(self.sureBtn!)
        self.sureBtn.isHidden = true

        self.users?.forEach({ (model) in
            if model.unitPrice == nil || (model.unitPrice?.count)! < 1 {
                noConfigPriceTotal = true
            }
            if let price = model.unitPrice, price.count > 0 {
                haveSpartConfig = true
            }
        })
        
        
        
        
        
    }
    
    
    var noConfigPriceTotal = false
    var haveSpartConfig = false
    
    var price: String = "0"
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        var bool: Bool = true
        self.users?.forEach({ (model) in
            if (model.unitPrice == nil) || (model.unitPrice?.count == 0) {
                bool = false
                
            }
        })
        if !bool {
            GDAlertView.alert("请设置完成所有成员的薪酬", image: nil, time: 1, complateBlock: nil)
        }
        return bool
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.finished?()
    }
    var finished: (() -> ())?
    func configTableView() {
        tableView.frame = CGRect(x:0 , y : DDNavigationBarHeight , width : self.view.bounds.width , height : self.view.bounds.height - DDNavigationBarHeight - TabBarHeight)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    func configNaviBar() {
        self.title = "设置报酬"
        let rightButton = UIBarButtonItem.init(title: "多选", style: UIBarButtonItemStyle.plain, target: self , action: #selector(addBtnClick(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    func configContentToRightButton() {
        switch self.showType {
        case .multipleSelection:
            self.navigationItem.rightBarButtonItem?.title = "多选"
        case .cancle:
            self.navigationItem.rightBarButtonItem?.title = "取消"
        case .done:
            self.navigationItem.rightBarButtonItem?.title = "完成"
        case .singleSelection:
            
            break
        }
    }

    func renew() {
        self.actionType = .singleSelection
        self.navigationItem.rightBarButtonItem?.title = "多选"
        self.showType = .multipleSelection
        self.multipleSelection = false
        self.view.endEditing(true )
        for model in self.users ?? [] {
            model.isSelected = false
        }
        self.tableView.reloadData()
        configContentToRightButton()
    }

    
    @objc func loadMore()  {
        self.pageNum += 1
        
    }
    @objc func performRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.pageNum = 0
            
        }
    }
    

    var sureBtn: UIButton!
    func configSuperBtn() {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - DDSliderHeight - 40, width: SCREENWIDTH , height: 40))
        btn.setTitle("批量设置报酬", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.colorWithRGB(red: 101, green: 147, blue: 248)
        btn.addTarget(self, action: #selector(superSureAction(btn:)), for: .touchUpInside)
        btn.isHidden = true
        self.sureBtn = btn
        
        self.view.addSubview(self.sureBtnOne)
    
        
    }
    
    @objc func sureBtnaction(sender: UIButton) {
        var bool: Bool = true
        self.users?.forEach({ (model) in
            if (model.unitPrice == nil) || (model.unitPrice?.count == 0) {
                bool = false
                
            }
        })
        if !bool {
            GDAlertView.alert("请设置完成所有成员的薪酬", image: nil, time: 1, complateBlock: nil)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    lazy var sureBtnOne: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - DDSliderHeight - 40, width: SCREENWIDTH, height: 40))
        btn.addTarget(self, action: #selector(sureBtnaction(sender:)), for: .touchUpInside)
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.colorWithHexStringSwift("6292f6")
        return btn
    }()
    @objc func superSureAction(btn: UIButton) {
        let arr = self.users?.filter({ (model) -> Bool in
            return model.isSelected
        })
        if (arr == nil) || (arr?.count == 0) {
            GDAlertView.alert("请先选择伙伴", image: nil, time: 1, complateBlock: nil)
            return
        }
        self.configPrice(data: arr!) { [weak self] in
            self?.navigationItem.rightBarButtonItem?.title = "多选"
            self?.showType = .multipleSelection
            self?.actionType = .singleSelection
            self?.multipleSelection = false
            //跳走
            self?.sureBtn?.isHidden = true
            
            self?.renew()
        }
        
    }
    
    
}

extension ConfigPriceVC {
    @objc func addBtnClick(sender:UIBarButtonItem?){
        mylog("add click")
        self.view.endEditing(true )
        self.multipleSelection = !self.multipleSelection
        switch self.showType {
        case .multipleSelection:
            self.actionType = .multipleSelection
            self.navigationItem.rightBarButtonItem?.title = checkWheatherNoOneBeSelected() ? "取消" : "完成"
            self.showType = checkWheatherNoOneBeSelected() ? .cancle : .done
            self.sureBtn?.isHidden = false
        case .cancle:
            self.actionType = .singleSelection
            self.navigationItem.rightBarButtonItem?.title = "多选"
            self.showType = .multipleSelection
            self.sureBtn?.isHidden = true
        //显示多选
        case .done:
            self.navigationItem.rightBarButtonItem?.title = "多选"
            self.showType = .multipleSelection
            self.actionType = .singleSelection
            self.multipleSelection = false
            //跳走
            
            self.sureBtn?.isHidden = true

            self.renew()
            return
        case .singleSelection://do nothing
            break
        }
        self.tableView.reloadData()
        configContentToRightButton()
    }

}
extension ConfigPriceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mylog(indexPath)
        switch self.actionType {
            
        case .singleSelection:
            mylog("perform once ")
            if let model = self.users?[indexPath.row]{
                self.configPrice(data: [model], finished: nil)
            }
        
        default:
            mylog("multiple select , action by done button")
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.users![indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigPriceListCell") as? ConfigPriceListCell{
            model.multipleSelection = self.multipleSelection
            cell.model = model
            cell.delegate = self
            return cell
        }else{
            let cell = ConfigPriceListCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "ConfigPriceListCell")
            model.multipleSelection = self.multipleSelection
            cell.model = model
            cell.delegate = self
            return cell
        }
    }
}
extension ConfigPriceVC: DDPartnerListCellDelegate {
    func didSelectedCell(cell : DDPartnerListCell){
        mylog(cell.model?.isSelected)
        self.showType = checkWheatherNoOneBeSelected() ? .cancle : .done
        self.configContentToRightButton()
    }
    func checkWheatherNoOneBeSelected() -> Bool  {
        for user  in self.users! {
            if user.isSelected{return false}
        }
        return true
    }
    func configPrice(data: [DDUserModel], finished: (() -> ())?) {
        self.cover = DDCoverView.init(superView: self.view)
        self.cover?.deinitHandle = {
            self.conerClick()
        }
        let alertView = ConfigPriceSIngleView.init(frame: CGRect.init(x: 30, y: 100, width: SCREENWIDTH - 60, height: 200), data: data)
        self.cover?.addSubview(alertView)
        
        alertView.textfield.rx.text.orEmpty.subscribe(onNext: { [weak self](title) in
            self?.price = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)

        alertView.cancleBtn.addTarget(self, action: #selector(cancleAction(sender:)), for: .touchUpInside)
        
        
        UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            let y = (SCREENHEIGHT - alertView.height) / 2.0
            alertView.frame = CGRect.init(x: 30, y: y, width: alertView.width, height: alertView.height)
        }) { (finished) in
            
        }
        let sure = alertView.sureBtn.rx.tap
        
        sure.subscribe(onNext: { [weak self](_) in
            if NSString(string: self?.price ?? "").length <= 0 {
                return
            }
            data.forEach({ (model) in
                model.unitPrice = self?.price
            })
            self?.conerClick()
            self?.tableView.reloadData()
            if finished != nil {
                finished!()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }

    
    @objc func cancleAction(sender: UIButton) {
        self.conerClick()
    }
    
    
    
    @objc func conerClick()  {
        self.cover?.removeFromSuperview()
        self.cover = nil
        
    }
    
}



