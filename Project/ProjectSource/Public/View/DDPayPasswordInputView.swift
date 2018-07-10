//
//  DDPayPasswordInputView.swift
//  Project
//
//  Created by WY on 2018/4/26.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//
/*
how to use

let psdInput =  DDPayPasswordInputView(superView: self.view)
psdInput.passwordComplateHandle = { password in
    mylog(password)
}
psdInput.forgetHandle = {
    mylog("perform forget pay password ")
}
*/
import UIKit

class DDPayPasswordInputView: UIView {
    private let backgroundTextfield = UITextField()
    private var _superView : UIView?
    var isHiddenComplateInput = true
    private var inputString = ""{
            didSet{
//                mylog(inputString)
                
                for ( index ,label)  in bottomContaienr.subviews.enumerated() {
                    if let label = label as? UILabel{
                        if  index == bottomContaienr.subviews.count - 1{//最后一个
                            if  index == inputString.count - 1{
                                label.text = "*"
                                let str = inputString
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                                    self.passwordComplateHandle?(str)
                                    self.inputString = ""
                                    self.clearCharacter()
                                    if self.isHiddenComplateInput {
                                        self.remove()
                                    }
                                })
                            }
                        }else{
                            if  index <= inputString.count - 1{
                                label.text = "*"
                            }else{
                                label.text = nil
                            }
                        }
                    }
                }
                
            }
        }
    private let titleLabel = UILabel()
    private let bottomContaienr = UIView()
    private let cancleBtn = UIButton()
    private let forgetBtn = UIButton()
    var passwordComplateHandle : ((String)->())?
    var cancleHandle : (()->())?
    var forgetHandle : (()->())?
    convenience init(superView:UIView){
        self.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 92))
        self._superView = superView
        _superView?.addSubview(backgroundTextfield)
        if _superView == nil {_superView = UIApplication.shared.keyWindow}
        
        self.addSubview(titleLabel)
        self.addSubview(bottomContaienr)
        self.addSubview(cancleBtn)
        self.addSubview(forgetBtn)
        self.backgroundColor = UIColor.colorWithHexStringSwift("#f7f7f7")
        titleLabel.text = "请输入支付密码"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.DDTitleColor
        forgetBtn.setTitle("忘记密码", for: UIControlState.normal)
        cancleBtn.setTitle("取消", for: UIControlState.normal)
        forgetBtn.addTarget(self , action: #selector(forgetAction), for: UIControlEvents.touchUpInside)
        
        cancleBtn.addTarget(self , action: #selector(cancleAction), for: UIControlEvents.touchUpInside)
        forgetBtn.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        cancleBtn.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        bottomContaienr.backgroundColor = UIColor.colorWithHexStringSwift("#f0f0f0")
        for _  in 0..<6 {
            let label = UILabel()
            bottomContaienr.addSubview(label)
            label.backgroundColor = .white
            label.textAlignment = .center
        }
        setupBackgroundInputView()
        self.backgroundTextfield.becomeFirstResponder()
    }
    override init(frame: CGRect) {
        super.init(frame: frame )
    }
//    func dismiss() {
//        self.clear()
//    }
    private func setupBackgroundInputView()  {
        backgroundTextfield.keyboardType = .numberPad
        backgroundTextfield.clearsOnBeginEditing = true
        backgroundTextfield.inputAccessoryView = self
        self.backgroundTextfield.delegate = self
    }
        
    @objc private func forgetAction(){
            self.clearCharacter()
        self.remove()
            self.forgetHandle?()
    }
        
    @objc private func cancleAction(){
        self.clearCharacter()
        self.remove()
        self.cancleHandle?()
    }
    func remove(){
        self._superView = nil
//        for ( index ,label)  in bottomContaienr.subviews.enumerated() {
//            if let label = label as? UILabel{
//                label.text = nil
//            }
//        }
        self.backgroundTextfield.inputAccessoryView = nil
        self.backgroundTextfield.resignFirstResponder()
        self.backgroundTextfield.removeFromSuperview()
    }
    
    private func clearCharacter(){
        self.inputString = ""
        self.backgroundTextfield.text = nil 
        for ( index ,label)  in bottomContaienr.subviews.enumerated() {
            if let label = label as? UILabel{
                label.text = nil
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.bounds.size
        cancleBtn.frame = CGRect(x: 0, y: 0, width: 44, height: size.height/2)
        forgetBtn.frame = CGRect(x: self.bounds.width - 88, y: 0, width: 88, height: size.height/2)
        titleLabel.frame = CGRect(x: forgetBtn.frame.width, y: 0, width: self.bounds.width - forgetBtn.frame.width * 2, height: size.height/2)
        bottomContaienr.frame = CGRect(x: 0, y: size.height/2, width: size.width, height: size.height/2)
        
        let toTopBorder : CGFloat = 3
        let gerdWH =  (size.height/2 - toTopBorder * 2 )
        let gerdMargin : CGFloat = 5
        let toLeftBorder : CGFloat = ( size.width - gerdWH  * 6 - gerdMargin * 5) / 2
        for (index , label) in bottomContaienr.subviews.enumerated() {
            label.frame = CGRect(x: toLeftBorder + CGFloat(index) * (gerdWH + gerdMargin), y: toTopBorder, width: gerdWH, height: gerdWH)
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        mylog("密码输入框销毁")
    }
}

extension DDPayPasswordInputView : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        mylog(textField.text)
//        mylog(range )
//        mylog(string )
        if textField == backgroundTextfield {
            if range.length == 0{//写
                if let text = textField.text {
                    self.inputString = text + string
                }
            }else if range.length == 1{//删
                if let text = textField.text {
                    var text = text
                    text.removeLast()
                    self.inputString = text
                }
            }
        }
        return true
    }
}
