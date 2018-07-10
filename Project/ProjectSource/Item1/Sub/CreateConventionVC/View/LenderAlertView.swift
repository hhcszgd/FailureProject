//
//  LenderAlertView.swift
//  Project
//
//  Created by wy on 2018/1/5.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
enum LenderType: String {
    case simple = "手动"
    case smart = "自动"
    case average = "平均"
    case custom = "自定义"
    
    case daySettlement = "日结"
    case hourseSettlement = "时结"
    case monthSettlement = "月结"
    case yearSettlement = "年结"
//    case projectSettlement = "项目结"
    
    
}
enum SettlementMethod: String {
    case daySettlement = "日结"
    case hourseSettlement = "时结"
    case monthSettlement = "月结"
    case yearSettlement = "年结"
//    case projectSettlement = "项目结"
}
import RxSwift
class LenderAlertView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.pickerView)
        self.pickerView.backgroundColor = UIColor.white
        self.addSubview(self.backView)
        self.backView.addSubview(self.cancleBtn)
        self.backView.addSubview(self.trueBtn)
        self.backView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
    }
    @objc func cancleAction(btn: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    @objc func trueAction(btn: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
            self.sender.onNext(self.type)
            self.sender.onCompleted()
            self.removeFromSuperview()
        }
    }
    var sender: PublishSubject<LenderType> = PublishSubject<LenderType>.init()
    lazy var cancleBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 15, y: 10, width: 50, height: 35))
        btn.setTitle("取消", for: .normal)
        btn.addTarget(self, action: #selector(cancleAction(btn:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("5585f1"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    lazy var trueBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: SCREENWIDTH - 50 - 15, y: 10, width: 50, height: 35))
        btn.setTitle("确定", for: .normal)
        btn.addTarget(self, action: #selector(trueAction(btn:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("5585f1"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    let backView = UIView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - 162 - 50, width: SCREENWIDTH, height: 50))
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismiss(tap:)))
        
        return tap
    }()
    @objc func dismiss(tap: UITapGestureRecognizer) {
    }
    var dataArr: [LenderType] = [LenderType.simple, LenderType.smart] {
        didSet {
            self.type = self.dataArr.first!
            self.pickerView.reloadAllComponents()
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataArr.count
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SCREENWIDTH
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let type = self.dataArr[row]
        self.type = type
    }
    var type: LenderType = LenderType.simple
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let type = self.dataArr[row]
        let label = UILabel.init()
        label.textColor = UIColor.colorWithHexStringSwift("333333")
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = type.rawValue
        label.textAlignment = .center
        return label
    }
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - 162, width: SCREENWIDTH, height: 162))
        picker.delegate = self
        picker.dataSource = self
        
        return picker
    }()
    deinit {
        mylog("销毁")
    }

}
