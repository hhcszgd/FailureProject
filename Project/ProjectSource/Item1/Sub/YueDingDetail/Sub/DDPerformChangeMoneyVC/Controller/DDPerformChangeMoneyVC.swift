//
//  DDPerformChangeMoneyVC.swift
//  Project
//
//  Created by WY on 2018/4/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPerformChangeMoneyVC: DDNormalVC {

    var cover : DDCoverView?
    var alertView : DDMoneyChangeAlert?
    var changeModel : DDMoneyChangeModel?
    var dict : [String:String]?
    let changeMoneyView = DDPerformChangeMoneyView()
    var index : Int = 0
    var maxY : CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改报酬"
        dict = self.userInfo as? [String:String]

        changeMoneyView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight)
        changeMoneyView.tableView.delegate = self
        changeMoneyView.tableView.dataSource = self
        changeMoneyView.tableView.estimatedRowHeight = 100
        changeMoneyView.tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(self.changeMoneyView)
        changeMoneyView.isHidden = true
        if #available(iOS 11.0, *) {
            changeMoneyView.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        requestData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillChangeFrame(note: Notification) {
        
        let endFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        if maxY > y {
            let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
            let margin = maxY - y + 10
            UIView.animate(withDuration: duration) {
                let h : CGFloat = 200.0
                let y = (SCREENHEIGHT - h) / 2
                self.alertView?.frame = CGRect(x: 20, y: y - margin, width: SCREENWIDTH - 40, height: h)
            }
            maxY = maxY - margin - 10
        }
    }
    
    @objc func timerFireMethod() {
        self.changeMoneyView.attentionLabelScroll()
    }

    func requestData() {
        DDRequestManager.share.getChangeMoney(type: ApiModel<DDMoneyChangeModel>.self, orderid: dict?["orderid"] ?? "", bid: dict?["bid"] ?? "") { (model) in
            if model?.status == 200 {
                self.changeMoneyView.isHidden = false
                if let changeModel = model?.data {
                    self.changeMoneyView.changeModel = changeModel
                }
                self.changeModel = model?.data
                self.changeMoneyView.tableView.reloadData()
            } else {
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.changeMoneyView.attentionLabelScroll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DDPerformChangeMoneyVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.changeModel?.periods_list?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DDPerformChangeMoneyCell") as? DDPerformChangeMoneyCell
        if (cell == nil) {
            cell = DDPerformChangeMoneyCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDPerformChangeMoneyCell")
        }
        cell?.btnCallBack = {
            if let moneyCell = cell {
                self.cellCallBack(index: indexPath.row, cell: moneyCell)
            }
        }
        cell?.period_tag = self.changeModel?.period_tag
        cell?.user_tag = self.changeModel?.user_tag
        if let model = self.changeModel?.periods_list?[indexPath.row] {
            cell?.periodsModel = model
        }
        return cell!
    }
}

extension DDPerformChangeMoneyVC {
    
    func cellCallBack(index: Int, cell: DDPerformChangeMoneyCell) {
        self.index = index
        if self.changeModel?.periods_list?[index].mod_tag ?? "" == "1" {
            // 已修改
            self.navigationController?.pushVC(vcIdentifier: "DDMoneyChangeDetailVC", userInfo: ["orderid" : self.changeModel?.order_id, "fid" : self.changeModel?.periods_list?[index].fid, "appointment_id" : self.dict?["appointment_id"] ?? ""  , "aid" : self.dict?["aid"] ?? "", "bid" : self.dict?["bid"] ?? "", "lenders" : self.changeModel?.lenders, "yue_type" : self.dict?["yue_type"] ?? "", "num" : self.changeModel?.periods_list?[index].num])
            return
        }
        cover = DDCoverView.init(superView: self.view)
        let h : CGFloat = 200.0
        let y = (SCREENHEIGHT - h) / 2
        alertView = DDMoneyChangeAlert.init(frame: CGRect(x: 20, y: y, width: SCREENWIDTH - 40, height: h))
        if let view = alertView {
            cover?.addSubview(view)
        }
        var message : String?
        if let txt = changeModel?.nickname {
            message = txt
        }
        let arrribute = [message ?? "", "的报酬修改为", "（最小为0，最大为" + (changeModel?.periods_list?[index].pay_price ?? "") + ")"].setColor(colors: [UIColor.red , color11, UIColor.red])
        alertView?.messageLab.attributedText = arrribute
        alertView?.txtField.delegate = self
        alertView?.delegate = self
    }
}

extension DDPerformChangeMoneyVC : DDMoneyChangeAlertDelegate{
    
    func performAction(actionType: DDMoneyChangeAlert.MoneyChangeAlertActionType) {
        switch actionType {
        case .cancle:
            cover?.removeFromSuperview()
        case .certain:
            let money = self.alertView?.txtField.text
            let number = NSString(string: money ?? "").floatValue
            let maxMoney = NSString(string: changeModel?.periods_list?[index].pay_price ?? "").floatValue
            if number > maxMoney {
                GDAlertView.alert("修改报酬不能大于最大修改范围", image: nil, time: 2, complateBlock: nil)
                return
            }
            DDRequestManager.share.postChangeMoney(type: ApiModel<String>.self, fid: self.changeModel?.periods_list?[index].fid ?? "", bid: self.dict?["bid"] ?? "", orderid: self.changeModel?.order_id ?? "", money: self.alertView?.txtField.text ?? "", complate: { (model) in
                
                if model?.status == 200 {
                    GDAlertView.alert("已通知对方，待对方接受后价格才会更改", image: nil, time: 2, complateBlock: {
                        self.cover?.removeFromSuperview()
                    })
                    self.requestData()
                } else {
                    GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
                }
            })
        }
    }
}

extension DDPerformChangeMoneyVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let window = UIApplication.shared.delegate?.window {
            var rect: CGRect = CGRect.zero
            rect = textField.convert(textField.bounds, to:window)
            maxY = rect.maxY
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.length == 0{//写
            if let inputValue  = textField.text{
                if inputValue.contains(".") && string == "."{return false }
                if let doutRange =  inputValue.range(of: "."){
                    let sub = inputValue.suffix(from:inputValue.index(doutRange.lowerBound, offsetBy: 0) )
                    let str = String(sub)
                    if str.count > 2{
                        return false
                    }
                }
            }
        }else if range.length == 1{//删
            if let text = textField.text {
                var text = text
                text.removeLast()
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let success = textField.text?.checkDecimalNumberString(string: textField.text ?? "") {
            if success {
                let money = self.alertView?.txtField.text
                let number = NSString(string: money ?? "").floatValue
                let maxMoney = NSString(string: changeModel?.periods_list?[index].pay_price ?? "").floatValue
                if number > maxMoney {
                    GDAlertView.alert("修改报酬不能大于最大修改范围", image: nil, time: 2, complateBlock: nil)
                    self.alertView?.txtField.text = ""
                }
            }
        }
        maxY = 0
        let h : CGFloat = 200.0
        let y = (SCREENHEIGHT - h) / 2
        self.alertView?.frame = CGRect(x: 20, y: y, width: SCREENWIDTH - 40, height: h)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return true
    }
}
