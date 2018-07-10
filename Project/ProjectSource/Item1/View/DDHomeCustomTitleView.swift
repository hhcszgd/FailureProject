//
//  DDHomeCustomTitleView.swift
//  Project
//
//  Created by WY on 2018/4/3.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
protocol HomeNaviBarDelegate : NSObjectProtocol {
    func performAction(actionType : DDHomeCustomTitleView.HomeNaviBarActionType)
}
class DDHomeCustomTitleView: UIView, UITextFieldDelegate {
//    var model : DDHomeAdvertModel?{
//        didSet{
//
//            self.bannerView.setImageUrl(url: model?.img)
//        }
//    }
    enum HomeNaviBarActionType{
        ///扫一扫
        case scanner
        ///发起约定
        case appoint
        ///加号时间
        case add
        ///付款
        case pay
        ///搜索
        case search
        ///横幅点击
        case bannerAction
    }
    weak var delegate  : HomeNaviBarDelegate?
    
    let searchContainer = UIView()
    let searchBox = UITextField.init()
    var bannerModel : DDHomeAdvertModel?{
        didSet{
            if let imgUrlStr = bannerModel?.img , let url = URL(string: imgUrlStr){
                SDWebImageDownloader.shared().downloadImage(with: url, options: SDWebImageDownloaderOptions.highPriority, progress: nil) { (img , data , error , bool ) in
                    DispatchQueue.main.async {
                        mylog(img)
                        mylog(data)
                        mylog(error)
                        mylog(bool)
                        if let image = img {
                            if let title = self.bannerModel?.font{
                                let attributeImg = image.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -6, width: 26, height: 26))
                                let attributeTitle = NSAttributedString(string: " " +  title)
                                let result = NSMutableAttributedString.init(attributedString: attributeImg)
                                result.append(attributeTitle)
                                self.bannerView.setTitleColor(UIColor.gray, for: UIControlState.normal)
                                self.bannerView.setAttributedTitle(result, for: UIControlState.normal)
                                self.bannerView.setImage(nil , for: UIControlState.normal)
                            }else{
                                self.bannerView.setImageUrl(url: imgUrlStr)
                                self.bannerView.setAttributedTitle(nil , for: .normal)
                            }
                            
                        }else{
                            self.bannerView.setImage(nil , for: UIControlState.normal)
                            self.bannerView.setAttributedTitle(nil , for: .normal)
                            self.bannerView.setTitleColor(UIColor.gray, for: UIControlState.normal)
                            self.bannerView.setTitle(self.bannerModel?.font, for: UIControlState.normal)
                        }
                    }
                    
                }
            }else{
                self.bannerView.setImage(nil , for: UIControlState.normal)
                self.bannerView.setAttributedTitle(nil , for: .normal) 
                self.bannerView.setTitleColor(UIColor.gray, for: UIControlState.normal)
                self.bannerView.setTitle(self.bannerModel?.font, for: UIControlState.normal)
            }
//            if let img = bannerModel?.img{
//                self.bannerView.setImageUrl(url: img)
//                self.bannerView.setTitle(bannerModel?.font, for: UIControlState.normal)
//                
//            }else{
//                self.bannerView.setImage(nil , for: UIControlState.normal)
//                 self.bannerView.setImageUrl(url: nil)
//            }
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    let addIcon = UIButton()
    private var  upHeight : CGFloat{
        return (originHeight - DDStatusBarHeight ) * 0.4
    }
    private var  downHeight : CGFloat{
        return (originHeight - DDStatusBarHeight ) * 0.6
    }
    private var  originUpHeight : CGFloat = 0
    private var  originDownHeight : CGFloat = 0
    private var  originHeight : CGFloat = 0
//    let actionContainerSmall = UIView()
//    let action11 = UIButton()
//    let action22 = UIButton()
//    let action33 = UIButton()
    
    let actionContainer = UIView()
    let action1 = ImgTxtView()
    let action2 = ImgTxtView()
    let action3 = ImgTxtView()
//    let action4 = UIButton()
    let bannerView = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configSearchBox()
        self.configActions()
//        self.configActionsTop()
        self.backgroundColor = UIColor.clear
    }

    func relayoutView(){
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.originHeight < self.bounds.height { self.originHeight = self.bounds.height}
        if self.originUpHeight < upHeight { self.originUpHeight = upHeight}
        if self.originDownHeight < downHeight{ self.originDownHeight = downHeight}
        layoutSearchBox()
        layoutActions()
        if let bannerModelReal = bannerModel {
            if self.bannerView.superview == nil {
//                self.superview?.addSubview(bannerView)
                self.superview?.insertSubview(bannerView, belowSubview: self)
                bannerView.backgroundColor = .white
            }
            bannerView.adjustsImageWhenHighlighted = false
            bannerView.isHidden = false
            bannerView.frame = CGRect(x: 0, y: self.frame.maxY, width: self.bounds.width, height: 30)
        }else{
            bannerView.isHidden = true
        }
//        layoutActionsTop()
    }
    
    /// switchShowStatus
    ///
    /// - Parameter scale: scale 0~1
    func switchStatus(scale:CGFloat) {
//        mylog(scale)
        self.actionContainer.alpha = 1 - scale
        if originHeight > self.originUpHeight {
        self.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: originHeight - self.originDownHeight *  scale)
//        self.frame.size.height = originHeight - self.originDownHeight *  scale
        }
    }
    
    /// switchShowStatus
    ///
    /// - Parameter scale: scale 0~1
    func hideStatus(scale:CGFloat) {
        //        mylog(scale)
        bannerView.frame = CGRect(x: 0, y: self.frame.maxY - 30 * scale, width: self.bounds.width, height: 30)
    }
    
    func layoutActions() {
        actionContainer.frame = CGRect(x: 0, y: DDStatusBarHeight + self.upHeight, width: self.bounds.width , height: self.downHeight)
        let virticalMargin : CGFloat = 6
        let leftMargin : CGFloat = 20
        let btnH = (actionContainer.bounds.height - virticalMargin * 2 )
        let btnW = (actionContainer.bounds.height - virticalMargin * 2 ) * 1.5
        let btnY = virticalMargin
        let buttonMargin : CGFloat = (self.bounds.width - leftMargin * 2 - btnW * CGFloat(actionContainer.subviews.count) ) / CGFloat(actionContainer.subviews.count - 1)
        
        for (index,button)  in actionContainer.subviews.enumerated() {
//            if let b = button as? UIButton{
//                b.imageView?.contentMode = .scaleToFill
//                b.imageRect(forContentRect: CGRect(x: 0, y: 0, width: btnWH, height: btnWH))
//            }
            button.frame = CGRect(x: leftMargin + (CGFloat(index) * (btnW + buttonMargin)), y: btnY, width: btnW, height: btnH)
        }
        
    }
    func layoutSearchBox(){
        searchContainer.frame =  CGRect(x: 0, y: DDStatusBarHeight, width: self.bounds.width - 44, height: upHeight)
        let searchBoxEdgeInset = UIEdgeInsetsMake(10, 10, 10, 10)
        searchBox.frame = CGRect(x: searchBoxEdgeInset.left, y: searchBoxEdgeInset.top, width: self.searchContainer.bounds.width - searchBoxEdgeInset.left - searchBoxEdgeInset.right, height: searchContainer.bounds.height - searchBoxEdgeInset.top - searchBoxEdgeInset.bottom)
        addIcon.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        addIcon.center = CGPoint(x: self.bounds.width - 28, y: searchContainer.frame.midY)
//        let rightView = UIButton(frame: CGRect(x: -10, y: 0, width: 20, height: 20))
//        rightView.setImage(UIImage(named: "search"), for: UIControlState.normal)
//        rightView.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
//        searchBox.rightView = rightView
//        searchBox.rightViewMode = .always
//        searchBox.placeholder = "search"
    }

    func configSearchBox(){
        self.addSubview(searchContainer)
       
        searchContainer.backgroundColor = UIColor.clear
        searchBox.delegate =  self //UITextFieldDelegate
        searchContainer.addSubview(searchBox)
        
        searchBox.backgroundColor = UIColor.white
        searchBox.borderStyle = UITextBorderStyle.roundedRect
        let rightView = UIButton(frame: CGRect(x: -10, y: 0, width: 20, height: 20))
        rightView.setImage(UIImage(named: "search"), for: UIControlState.normal)
        rightView.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        searchBox.rightView = rightView
        searchBox.rightViewMode = .always
        searchBox.placeholder = "搜索"
        self.addSubview(addIcon)
        addIcon.setImage(UIImage(named:"addto"), for: UIControlState.normal)
        addIcon.addTarget(self, action: #selector(actionClick(sender:)), for: UIControlEvents.touchUpInside)
    }
    //textfieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        self.actionClick(sender: textField)
        //perform push viewController
        return false
    }
    
    func configActions() {
        self.addSubview(actionContainer)
        actionContainer.backgroundColor = UIColor.clear
        actionContainer.addSubview(action1)
        actionContainer.addSubview(action2)
        actionContainer.addSubview(action3)//修改
        action1.imgToLblMargin = 8
        action2.imgToLblMargin = 8
        action3.imgToLblMargin = 8
        //        actionContainer.addSubview(action4)
        action1.imageView.image = UIImage(named:"scan_icon 2")
        action1.label.text = "扫一扫"
        action2.imageView.image = UIImage(named:"convention_icon 2")
        action2.label.text = "发起约定"
//        action3.imageView.image = UIImage(named:"payment_icon 2")
        action3.imageView.image = UIImage(named:"addpartnerNew")
        
//        action3.label.text = "直接付款"
        action3.label.text = "添加伙伴"
        action1.addTarget(self, action: #selector(actionClick(sender:)), for: UIControlEvents.touchUpInside)
        action2.addTarget(self, action: #selector(actionClick(sender:)), for: UIControlEvents.touchUpInside)
        action3.addTarget(self, action: #selector(actionClick(sender:)), for: UIControlEvents.touchUpInside)
        bannerView.addTarget(self, action: #selector(actionClick(sender:)), for: UIControlEvents.touchUpInside)
        //        action4.setImage(UIImage(named:"search_small"), for: UIControlState.normal)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func layoutActionsTop() {
//        actionContainerSmall.frame = CGRect(x: 0, y: DDStatusBarHeight + self.upHeight, width: self.bounds.width , height: self.downHeight)
//        let virticalMargin : CGFloat = 0
//        let leftMargin : CGFloat = 0
//        let buttonMargin : CGFloat = 0
//        let btnWH = (actionContainerSmall.bounds.height - virticalMargin * 2 )
//        let btnY = virticalMargin
//
//        for (index,button)  in actionContainerSmall.subviews.enumerated() {
//            if let b = button as? UIButton{
//                b.imageView?.contentMode = .scaleToFill
//                b.imageRect(forContentRect: CGRect(x: 0, y: 0, width: btnWH, height: btnWH))
//            }
//            button.frame = CGRect(x: leftMargin + (CGFloat(index) * (btnWH + buttonMargin)), y: btnY, width: btnWH, height: btnWH)
//        }
//
//    }
    
    
    
    
    //    func configActionsTop() {
    //        self.addSubview(actionContainerSmall)
    //        actionContainer.backgroundColor = UIColor.clear
    //        actionContainer.addSubview(action11)
    //        actionContainer.addSubview(action22)
    //        actionContainer.addSubview(action33)
    //        //        actionContainer.addSubview(action4)
    //        action1.setImage(UIImage(named:"scan_icon_small"), for: UIControlState.normal)
    //        action2.setImage(UIImage(named:"convention_icon_small"), for: UIControlState.normal)
    //        action3.setImage(UIImage(named:"payment_icon_small"), for: UIControlState.normal)
    //        //        action4.setImage(UIImage(named:"search_small"), for: UIControlState.normal)
    //    }
}

extension DDHomeCustomTitleView {

    @objc func actionClick(sender : UIControl){
        switch sender  {
        case addIcon:
            self.delegate?.performAction(actionType: DDHomeCustomTitleView.HomeNaviBarActionType.add)
        case action1:
            self.delegate?.performAction(actionType: DDHomeCustomTitleView.HomeNaviBarActionType.scanner)
        case action2:
            self.delegate?.performAction(actionType: DDHomeCustomTitleView.HomeNaviBarActionType.appoint)
        case action3:
            self.delegate?.performAction(actionType: DDHomeCustomTitleView.HomeNaviBarActionType.pay)
        case searchBox:
            self.delegate?.performAction(actionType: DDHomeCustomTitleView.HomeNaviBarActionType.search)
        case bannerView:
            self.delegate?.performAction(actionType: DDHomeCustomTitleView.HomeNaviBarActionType.bannerAction)
        default:
            break
        }
    }
   
}
