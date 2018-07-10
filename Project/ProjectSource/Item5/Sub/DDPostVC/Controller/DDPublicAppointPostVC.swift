//
//  DDPublicAppointPostVC.swift
//  Project
//
//  Created by 金曼立 on 2018/5/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPublicAppointPostVC: DDNormalVC {
    
    var arr = ["3", "7", "10", "30"]
    var postModel = DDPostModel()
    var maxY : CGFloat = 0.0
    var specialArr : [String] = []
    var endCount : Int = 0
    var address_id : String = ""
    
    let postView = DDPublicPostView.init(frame: CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "发布公开任务约定"
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f2f2f2")
        
        if #available(iOS 11.0, *) {
            self.postView.scrollBg.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

       let specialWords = "- / ： ； （ ） ¥ @ “ ” 。 . 【 】 ｛ ｝ # % ^ * + = _ — \\ | ～ 《 》 $ & · …  ’ - / : ; ( ) $ & @ “ . , ? ! ’ [ ] { } # % ^ * + = _ \\ | ~ < > € £ ¥ • . , ? ! ’ " +
       "￡ ¤ § ¨ 「 」『 』 ￠ ￢ ￣ —— _ €"
        specialArr = specialWords.components(separatedBy:" ")
        
        // 默认为人满开始
        postModel.a_start = "1"
        
        postView.postDelegate = self
        self.view.addSubview(postView)
        postView.btnCallBack = { (actionType) ->()  in
            weak var weakSelf = self
            switch actionType  {
            case .region:
                weakSelf?.setRegion()
            case .start:
                break // weakSelf?.setStartTime()
            case .valid:
                break // weakSelf?.setValidTime()
            case .pay:
                weakSelf?.payBtnClick()
            }
        }
        
        postView.appointNameBg.detailField.inputAccessoryView = self.addToolbar()
        postView.moneyBg.detailField.inputAccessoryView = self.addToolbar()
        postView.peopleNumBg.detailField.inputAccessoryView = self.addToolbar()
        postView.numberBg.detailField.inputAccessoryView = self.addToolbar()
        postView.requtietBg.textView.inputAccessoryView = self.addToolbar()
        
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
            let margin = maxY - y
            UIView.animate(withDuration: duration) {
                self.postView.scrollBg.contentOffset.y = margin + 10 + self.postView.scrollBg.contentOffset.y
            }
            maxY = maxY - margin - 10
        }
    }
    
    func setRegion() {
        self.view.endEditing(true)
        let coverView = DDCoverView.init(superView: UIApplication.shared.keyWindow ?? self.view)
        let regionSelectView = DDRegionSelect.init(frame: CGRect(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH , height: 300))
        coverView.addSubview(regionSelectView)
        UIView.animate(withDuration: 0.5, animations: {
            regionSelectView.transform = regionSelectView.transform.translatedBy(x: 0, y: -300)
        })
        regionSelect(superView: regionSelectView)
        regionSelectView.callBack = { () ->()  in
            coverView.removeFromSuperview()
        }
    }
    
    func regionSelect(superView: UIView) {
        let frame = CGRect.init(x: 0, y: 50, width: SCREENWIDTH, height: 300)
        let areaSelectView = AreaSelectView.init(frame: frame, title: "jj", type: 100, url: "area", subFrame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        areaSelectView.sureBtn.isHidden = true
        areaSelectView.containerView.backgroundColor = lineColor
        superView.addSubview(areaSelectView)
        areaSelectView.finished.subscribe(onNext: { [weak self](address, id) in
            weak var weakSelf = self
            weakSelf?.address_id = id
            weakSelf?.postView.regionBg.detailLab.text = address
            weakSelf?.postView.regionBg.detailLab.textColor = UIColor.colorWithRGB(red: 51, green: 51, blue: 51)
            weakSelf?.postModel.range = address
            superView.superview?.removeFromSuperview()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    func setStartTime() {
        self.view.endEditing(true)
        let coverView = DDCoverView.init(superView: UIApplication.shared.keyWindow ?? self.view)
        let startView = DDPublicSelectView.init(frame: CGRect(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH , height: 100))
        coverView.addSubview(startView)
        UIView.animate(withDuration: 0.5, animations: {
            startView.transform = startView.transform.translatedBy(x: 0, y: -100)
        })
        startView.btnCallBack = { (actionType) ->()  in
            weak var weakSelf = self
            switch actionType  {
            case .anyTime:
                weakSelf?.postView.startBg.detailLab.text = "随时开始"
                weakSelf?.postModel.a_start = "0"
            case .allPeople:
                weakSelf?.postView.startBg.detailLab.text = "人满开始"
                weakSelf?.postModel.a_start = "1"
            }
            weakSelf?.postView.startBg.detailLab.textColor = UIColor.colorWithRGB(red: 51, green: 51, blue: 51)
            coverView.removeFromSuperview()
        }
    }
    
    func setValidTime() {
        self.view.endEditing(true)
        let coverView = DDCoverView.init(superView: UIApplication.shared.keyWindow ?? self.view)
        let validView = DDPublicTableView.init(frame: CGRect(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH , height: 200), style:UITableViewStyle.plain)
        validView.delegate = self
        validView.dataSource = self
        coverView.addSubview(validView)
        UIView.animate(withDuration: 0.5, animations: {
            validView.transform = validView.transform.translatedBy(x: 0, y: -200)
        })
    }
    
    func payBtnClick() {
        self.view.endEditing(true)
        if postModel.full_name.count == 0 {
            GDAlertView.alert("约定名称不能为空", image: nil, time: 2, complateBlock: nil)
            return
        }else if postModel.requirement.count == 0 {
            GDAlertView.alert("要求不能为空", image: nil, time: 2, complateBlock: nil)
            return
        }else if postModel.price_one.count == 0 {
            GDAlertView.alert("报酬不能为空", image: nil, time: 2, complateBlock: nil)
            return
        }else if postModel.range.count == 0 {
            GDAlertView.alert("区域不能为空", image: nil, time: 2, complateBlock: nil)
            return
        }else if postModel.person_num.count == 0 {
            GDAlertView.alert("需求人数不能为空", image: nil, time: 2, complateBlock: nil)
            return
        }else if postModel.num_time.count == 0 {
//            GDAlertView.alert("有效期不能为空", image: nil, time: 2, complateBlock: nil)
            postModel.num_time = "30"
            return
        }else if postModel.price.count == 0 {
            GDAlertView.alert("总报酬不能为空", image: nil, time: 2, complateBlock: nil)
            return
        }
        postModel.a_start = "1"
        postView.payButton.isUserInteractionEnabled = false
        postView.payButton.backgroundColor = UIColor.lightGray

        DDRequestManager.share.postPublicAppoint(type: ApiModel<String>.self, full_name: postModel.full_name, price_one: postModel.price_one, person_num: postModel.person_num, Lenders: postModel.Lenders, num_time: postModel.num_time, price: postModel.price, num: postModel.num, a_start:  postModel.a_start, range: postModel.range, requirement: postModel.requirement, address_id : self.address_id) { (model) in
            
            if model?.status == 200 {
                mylog("约定创建成功")
                guard let orderID = model?.data else {
                    return
                }
                
                let paramete = ["orderID": orderID, "price": self.postModel.price]
                let vc = PayVC()
                vc.userInfo = paramete
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: {
                    self.postView.payButton.isUserInteractionEnabled = true
                    self.postView.payButton.backgroundColor = UIColor.DDThemeColor
                })
            }
        }
    }
    
    func addToolbar() -> UIToolbar {
        let toolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 35))
        toolbar.tintColor = UIColor.colorWithHexStringSwift("5585f1")
        toolbar.backgroundColor = UIColor.white
        let bar = UIBarButtonItem.init(title: "确定", style: UIBarButtonItemStyle.plain, target: self, action: #selector(complete))
        
        toolbar.items = [bar]
        return toolbar
    }
    
    @objc func complete() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DDPublicAppointPostVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let window = UIApplication.shared.delegate?.window {
            var rect: CGRect = CGRect.zero
            switch textField {
            case postView.appointNameBg.detailField:
                rect = postView.appointNameBg.detailField.convert(postView.appointNameBg.detailField.bounds, to:window)
            case postView.moneyBg.detailField:
                rect = postView.moneyBg.detailField.convert(postView.moneyBg.detailField.bounds, to:window)
            case postView.peopleNumBg.detailField:
                rect = postView.peopleNumBg.detailField.convert(postView.peopleNumBg.detailField.bounds, to:window)
            case postView.numberBg.detailField:
                rect = postView.numberBg.detailField.convert(postView.numberBg.detailField.bounds, to:window)
            default:
                break
            }
            maxY = rect.maxY
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case postView.appointNameBg.detailField:
            if (textField.text?.checkString(string: textField.text ?? "", length: 30)) ?? false {
                postModel.full_name = textField.text ?? ""
                return
            }
            textField.text = ""
        case postView.moneyBg.detailField:
            if (textField.text?.checkDecimalNumberString(string: textField.text ?? "")) ?? false {
                if NSString(string: textField.text ?? "").length <= 8 {
                    let priceOne = NSString(string: textField.text ?? "").floatValue
                    postModel.price_one = String(format: "%.2f", priceOne)
                    textField.text = String(format: "%.2f", priceOne)
                    calculateAmountPrice()
                } else {
                    GDAlertView.alert("报酬最大为8位数", image: nil, time: 2, complateBlock: nil)
                    textField.text = ""
                }
                return
            }
            textField.text = ""
        case postView.peopleNumBg.detailField:
            if (textField.text?.checkNumberString(string: textField.text ?? "")) ?? false {
                let number = NSString(string: textField.text ?? "").intValue
                if number <= 1000 {
                    postModel.person_num = textField.text ?? ""
                    calculateAmountPrice()
                } else {
                    GDAlertView.alert("需求人数最大为1000", image: nil, time: 2, complateBlock: nil)
                    textField.text = ""
                }
                return
            }
            textField.text = ""
        case postView.numberBg.detailField:
            if (textField.text?.checkNumberString(string: textField.text ?? "")) ?? false {
                let number = NSString(string: textField.text ?? "").intValue
                if number <= 99999999 {
                    postModel.num = textField.text ?? ""
                    calculateAmountPrice()
                } else {
                    GDAlertView.alert("数量最大为99999999", image: nil, time: 2, complateBlock: nil)
                    textField.text = ""
                }
                return
            }
            textField.text = ""
        default:
            break
        }
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
                let result  = inputValue + string
                self.judgeEnouph(Str: result )
            }
        }else if range.length == 1{//删
            if let text = textField.text {
                var text = text
                text.removeLast()
                let result = text
                self.judgeEnouph(Str: result )
            }
        }
        return true
    }
    func judgeEnouph(Str : String ){
        let nsStr  = NSString.init(string: Str)
        let strFloat = nsStr.floatValue
        if Str.hasSuffix(".") || Str.hasPrefix(".") || strFloat == 0{
//            endAppointView.submitBtn.isUserInteractionEnabled = false
//            endAppointView.submitBtn.backgroundColor = UIColor.lightGray
        }else{
//            endAppointView.submitBtn.isUserInteractionEnabled = true
//            endAppointView.submitBtn.backgroundColor = UIColor.DDThemeColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        calculateAmountPrice()
        maxY = 0
        self.view.endEditing(true)
        self.postView.scrollBg.contentOffset.y = 0
        return true
    }
    
    func calculateAmountPrice() {
        if postView.moneyBg.detailField.text?.count != 0 && postView.peopleNumBg.detailField.text?.count != 0 && postView.numberBg.detailField.text?.count != 0 {
            let peopleNumFloat = NSString(string:postView.peopleNumBg.detailField.text ?? "").floatValue
            let monayFloat = NSString(string:postView.moneyBg.detailField.text ?? "").floatValue
            let numberFloat = NSString(string:postView.numberBg.detailField.text ?? "").floatValue
            let amount = peopleNumFloat * monayFloat * numberFloat
            postView.amountBg.amountNum.text = String(format: "%.2f", amount) + "元"
            postModel.price = String(format: "%.2f", amount)
        }
    }
}

extension DDPublicAppointPostVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        postView.requtietBg.placeHolderLab.text = ""
        if let window = UIApplication.shared.delegate?.window {
            var rect: CGRect = CGRect.zero
            rect = textView.convert(textView.bounds, to:window)
            maxY = rect.maxY
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            postView.requtietBg.placeHolderLab.text = "请简要叙述您发布的工作任务的招工要求"
            postView.requtietBg.wordNumLab.text = "0/200"
            return
        }
        if self.checkString(string: textView.text) {
            postModel.requirement = textView.text
            postView.requtietBg.placeHolderLab.text = ""
            let textLength = textView.text.count
            postView.requtietBg.wordNumLab.text = "\(textLength)" + "/200"
            return
        }
        GDAlertView.alert("只能输入汉字、数字和英文", image: nil, time: 2, complateBlock: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let maxWords = 200
        var textString = textView.text ?? ""
        var length = textString.count
        if checkString(string: textView.text) {
            if textString.contains("\n") && length <= maxWords {
                textString.removeLast()
                length -= 1
                textView.text = textString
                self.view.endEditing(true)
                self.postView.scrollBg.contentOffset.y = 0
                return
            }
            if length > maxWords {
                textString = String(textString.prefix(maxWords))
                textView.text = textString
                length = maxWords
            }
        } else {
            let index = textString.index(textString.startIndex, offsetBy: endCount)//获取字符d的索引
            textString = textString.substring(to: index)
            textView.text = textString
            length = textString.count
        }
        postView.requtietBg.wordNumLab.text = "\(length)" + "/" + "\(maxWords)"
        endCount = textString.count
    }
    
    func checkString(string : String) -> Bool {
        for word in specialArr {
            if string.contains(word) {
                return false
            }
        }
        return true
    }
}

extension DDPublicAppointPostVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = self.arr[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DDVaildCell") as? DDVaildCell{
            cell.label.text = title + "天"
            return cell
        }else{
            let cell = DDVaildCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDVaildCell")
            cell.label.text = title + "天"
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell : DDVaildCell = tableView.cellForRow(at: indexPath) as! DDVaildCell
        postView.validNumBg.detailLab.text = cell.label.text
        postModel.num_time = self.arr[indexPath.row]
        tableView.superview?.removeFromSuperview()
    }
}
