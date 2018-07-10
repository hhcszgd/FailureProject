//
//  DDSearchBar.swift
//  Project
//
//  Created by 金曼立 on 2018/5/22.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDSearchBar: UISearchBar {
    
    let searchIconW : CGFloat = 20.0
    let iconSpacing : CGFloat = 10.0
    var placeHolder : String = ""
    var fontPh : CGFloat = 15.0
    
    // placeholder 和icon 间隙的整体宽度
    var _placeholderW : CGFloat?
    var placeholderW : CGFloat? {
        set{
            _placeholderW = placeholderW
        }
        get{
            if _placeholderW ?? 0.0 <= CGFloat(0.0) {
                let size = self.placeholder?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)], context: nil).size
                _placeholderW = (size?.width ?? 0.0) + searchIconW + iconSpacing
            }
            return _placeholderW
        }
    }
    
    init(frame: CGRect, placeholder: String, fontPh: CGFloat) {
        super.init(frame: frame)
        self.placeHolder = placeholder
        self.fontPh = fontPh
        
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let subViewsArr = self.subviews.last?.subviews {
            for view in subViewsArr {
                if view.isKind(of: UITextField.self) {
                    let txtField : UITextField = view as! UITextField
                    txtField.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH - 30, height: 30)
                    txtField.backgroundColor = UIColor.white
                    txtField.textColor = UIColor.colorWithRGB(red: 51, green: 51, blue: 51)
                    txtField.borderStyle = UITextBorderStyle.none
                    let leftView = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                    leftView.setImage(UIImage(named: "search_blue"), for: UIControlState.normal)
                    txtField.leftView = leftView
                    let str = NSAttributedString(string: self.placeHolder, attributes: [NSAttributedStringKey.foregroundColor:UIColor.DDThemeColor, NSAttributedStringKey.font:UIFont.systemFont(ofSize:self.fontPh)])
                    txtField.attributedPlaceholder = str
                    // 设置放大镜和placeHolder之间的距离
                    self.searchTextPositionAdjustment = UIOffsetMake(iconSpacing, 0)
                    if #available(iOS 11.0, *) {
                        self.setPositionAdjustment(UIOffsetMake((self.frame.size.width - (placeholderW ?? 0.0)) / 2 - 10 , 0), for: UISearchBarIcon.search)
                    }

                }
            }
        }
    }

}

extension DDSearchBar : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.delegate?.responds(to: #selector(textFieldShouldBeginEditing(_:))) ?? false {
            self.delegate?.searchBarShouldBeginEditing?(self)
        }
        if #available(iOS 11.0, *) {
            self.setPositionAdjustment(UIOffset.zero, for: UISearchBarIcon.search)
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if self.delegate?.responds(to: #selector(textFieldShouldEndEditing(_:))) ?? false {
            self.delegate?.searchBarShouldEndEditing?(self)
        }
        if #available(iOS 11.0, *) {
            self.setPositionAdjustment(UIOffsetMake((textField.frame.size.width - (placeholderW ?? 0.0)) / 2, 0), for: UISearchBarIcon.search)
        }
        return true
    }
}
