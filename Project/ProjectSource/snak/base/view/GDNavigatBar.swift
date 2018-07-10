//
//  GDNavigatBar.swift
//  zjlao
//
//  Created by WY on 17/1/15.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit


class GDNavigatBar: UIView {
    var  currentType : NaviBarStyle  = NaviBarStyle.withBackBtn{
        willSet{
            switch newValue {

            case .withBackBtn:

                leftSubViewsContainer.backgroundColor = UIColor.clear
                rightSubViewsContainer.backgroundColor = UIColor.clear
                
                self.addSubview(backBtn)
                self.addSubview(leftSubViewsContainer)
                self.addSubview(rightSubViewsContainer)
                backBtn.backgroundColor = UIColor.clear
                backBtn.addTarget(self, action:#selector(backAction(_:)) , for:UIControlEvents.touchUpInside)
                break
            case .withoutBackBtn:
                for item in self.subviews {
                    
//                    if item == naviagationBackImage {
//
//                    }else if item == titleLabel {
//
//                    }else {
//
//                    }
                    item.removeFromSuperview()
                }
                self.addSubview(self.naviagationBackImage)
                self.addSubview(self.titleLabel)
                self.addSubview(self.navTitleView)
                leftSubViewsContainer.backgroundColor = UIColor.clear
                rightSubViewsContainer.backgroundColor = UIColor.clear
                self.addSubview(leftSubViewsContainer)
                self.addSubview(rightSubViewsContainer)
                break
            }
        }
        didSet{}
    }
    var currentBarActionType = NaviBarActionType.offset{
        willSet{}
        didSet{}
    }
    var transitionType = TransitionType.immediately{
        didSet{ }
        
    }
    
    var layoutType = LayoutType.asc{
        willSet {}
        didSet{
            if self.transitionType == TransitionType.immediately {
                if layoutType == .asc {
                    self.currentBarStatus = .normal
                    if currentBarActionType == .offset {//只有移动是一点驱动
                        self.frame = self.originFrame
                    }else if(currentBarActionType == .alpha){//这个是根据fload来实现渐变
                        self.alpha = self.originAlpha
                        
                    }else if(currentBarActionType == .color){//这个是根据fload来实现渐变
                        self.backgroundColor = self.originColorAlpha
                    }
                }else if (layoutType == .desc){
                    self.currentBarStatus = .disapear
                    if currentBarActionType == .offset {//只有移动是一点驱动
                        self.frame = self.targetFrame
                    }else if(currentBarActionType == .alpha){//这个是根据fload来实现渐变
                        self.alpha = self.targetAlpha
                        
                    }else if(currentBarActionType == .color){//这个是根据fload来实现渐变
                        self.backgroundColor = self.targetColorAlpha
                    }
                }
            } else if self.transitionType == TransitionType.gradually{
                //MARK:             todo something
            }
            
            
        }
    }
    
    var currentBarStatus = NaviBarStatus.normal{
        willSet {}
        didSet{   }
    }
    
    
    weak var delegate  :  CustomNaviBarDelegate?
    let backBtn = UIButton(frame: CGRect(x: 0, y: ((DDDevice.type == .iphoneX) ? 44 : 20), width: 44, height: 44))
    fileprivate let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 88.0, height: 44))
    var attributeTitle : NSAttributedString {
        set{
            titleLabel.isHidden = false
            if titleLabel.superview == nil  {
                self.addSubview(titleLabel)
            }
            titleLabel.attributedText =  newValue
        }
        get{
            if let a = titleLabel.attributedText {
                return a
            }else{
                return NSAttributedString()
            }
        }
    }
    
    
    var title : String {
        set{
            mylog(self)
            mylog(titleLabel)
            mylog(titleLabel.superview)
            mylog(newValue)
            if titleLabel.superview == nil  {
                self.addSubview(titleLabel)
            }
            titleLabel.isHidden = false
            titleLabel.text =  newValue
        }
        get{
            if let a = titleLabel.text {
                return a
            }else{
                return ""
            }
        }
    }
    
    
    let leftSubViewsContainer : UIView = UIView()
    
    
    var leftBarButtons  = [UIView]() {
        
        willSet{
            
        }
        didSet{
            for oldSub in leftSubViewsContainer.subviews {
                oldSub.removeFromSuperview()
            }
            
            if currentType == .withBackBtn {
                var totalWidth: CGFloat = 0
                let margin: CGFloat = 5
                leftBarButtons.forEach({ (btn) in
                    let width: CGFloat = btn.bounds.size.width
                    totalWidth += margin + width
                })
                self.leftSubViewsContainer.frame = CGRect.init(x: 49, y: DDnavigationStateHeight, width: totalWidth, height: 44)
                totalWidth = 0
                
                for (index , newSub) in leftBarButtons.enumerated() {
                    
                    let x: CGFloat = totalWidth
                    let y: CGFloat = 0
                    let width: CGFloat = newSub.bounds.size.width
                    let height: CGFloat = 44
                    leftSubViewsContainer.addSubview(newSub)
                    newSub.frame = CGRect(x: x, y: y, width: width, height: height)
                    totalWidth += CGFloat(index) * margin + width
                }
            }else{
                var totalWidth: CGFloat = 0
                let margin: CGFloat = 5
                leftBarButtons.forEach({ (btn) in
                    let width: CGFloat = btn.bounds.size.width
                    totalWidth += margin + width
                })
                leftSubViewsContainer.frame = CGRect(x: 0, y: DDnavigationStateHeight, width: totalWidth, height: 44)
                totalWidth = 0
                for (index , newSub) in leftBarButtons.enumerated() {
                    let x: CGFloat = totalWidth
                    let y: CGFloat = 0
                    let width: CGFloat = newSub.bounds.size.width
                    let height: CGFloat = 44
                    leftSubViewsContainer.addSubview(newSub)
                    newSub.frame = CGRect(x: x, y: y, width: width, height: height)
                    totalWidth += CGFloat(index) * margin + width
                }
            }
            
            
        }
        
    }
    var showLineview: Bool = false {
        didSet{
            if showLineview {
                self.lineView.alpha = 1.0
            }else {
                self.lineView.alpha = 0.0
            }
            self.lineView.snp.makeConstraints { (make) in
                make.left.bottom.right.equalTo(0)
                make.height.equalTo(1)
            }
            
        }
    }
    
    lazy var lineView: UIView = {
        let view = UIView.init()
        self.addSubview(view)
        view.backgroundColor = UIColor.colorWithHexStringSwift("e4e4e4")
        return view
    }()
    
    
    
    
    let rightSubViewsContainer : UIView = UIView()
    
    var rightBarButtons  = [UIView]() {
        
        willSet{
            
        }
        didSet{
            for oldSub in rightSubViewsContainer.subviews {
                oldSub.removeFromSuperview()
            }
            var totalWidth: CGFloat = 0
            let margin: CGFloat = 5
            rightBarButtons.forEach { (view) in
                let width = view.bounds.size.width + margin
                totalWidth += width
            }
            self.rightSubViewsContainer.frame = CGRect.init(x: SCREENWIDTH - totalWidth, y: DDnavigationStateHeight, width: totalWidth, height: 44)
            totalWidth = 0
            for (index, newBtn) in rightBarButtons.enumerated() {
                self.rightSubViewsContainer.addSubview(newBtn)
                let x: CGFloat = totalWidth
                let y: CGFloat = 0
                let width: CGFloat = newBtn.bounds.size.width
                let height: CGFloat = 44
                newBtn.frame = CGRect.init(x: x, y: y, width: width, height: height)
                totalWidth += margin * CGFloat(index) + width
                
            }
            
            
            
        }
        
    }
    
    var navTitleView   =  NavTitleView(){
        willSet {
            navTitleView.removeFromSuperview()
        }
        
        didSet {
            self.addSubview(navTitleView)
            let inset =   navTitleView.insets
            var x : CGFloat = 0.0
            let y : CGFloat = (DDDevice.type == .iphoneX) ? (44 + inset.top) : (20 + inset.top)
            var w : CGFloat = 0.0
            let h : CGFloat = 44.0 - inset.top - inset.bottom
            if leftBarButtons.count>0 && rightBarButtons.count>0 {//左右都有
                x = leftSubViewsContainer.frame.maxX + inset.left
                //                y = inset.top
                w = rightSubViewsContainer.frame.minX - inset.right - x
                //                h = 44.0 - inset.top - inset.bottom
            }else if leftBarButtons.count>0{//左有 ,右没有
                x = leftSubViewsContainer.frame.maxX + inset.left
                w = UIScreen.main.bounds.size.width - inset.right - x
            }else if rightBarButtons.count>0{//左没有,右有
                x = backBtn.frame.maxX + inset.left
                w = rightSubViewsContainer.frame.minX - inset.right - x
            }else {//左右都没有
                x = backBtn.frame.maxX + inset.left
                w = UIScreen.main.bounds.size.width - inset.right - x
            }
            navTitleView.frame = CGRect(x: x, y: y, width: w, height: h);
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.naviagationBackImage.backgroundColor = UIColor.clear
        titleLabel.isHidden = true
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = font13
        titleLabel.textColor = color11
        self.addSubview(titleLabel)
        titleLabel.center = CGPoint(x: UIScreen.main.bounds.size.width/2.0, y:22 + ((DDDevice.type == .iphoneX) ? 44 : 20));
        leftSubViewsContainer.backgroundColor = UIColor.clear
        rightSubViewsContainer.backgroundColor = UIColor.clear
        //        self.addSubview(backBtn)
        self.addSubview(leftSubViewsContainer)
        self.addSubview(rightSubViewsContainer)
        backBtn.backgroundColor = UIColor.clear
        backBtn.setImage(UIImage.init(named: "back_icon"), for: UIControlState.normal)
        backBtn.addTarget(self, action:#selector(backAction(_:)) , for:UIControlEvents.touchUpInside)
        
    }
    lazy var naviagationBackImage: UIImageView = {
        let image = UIImageView.init()
        self.addSubview(image)
        image.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: DDNavigationBarHeight)
        image.contentMode = UIViewContentMode.scaleToFill
        return image
    }()
    
    
    class func attributeTitle(font: UIFont = UIFont.systemFont(ofSize: 17), textColor: UIColor = UIColor.white, text: String) -> NSAttributedString {
        let dict = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: textColor]
        var trasnText = DDLanguageManager.text(text)
        if trasnText == "nil"  {
           trasnText = text
        }
        let attributeString = NSAttributedString.init(string: trasnText, attributes: dict)
        return attributeString

    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**移动位置*/
    private  func changeOffsetWith(scrollView : UIScrollView)  {
        let offsetScale :  CGFloat = scrollView.contentOffset.y / scrollView.contentSize.height
        
        if currentBarStatus == .normal {
            if offsetScale > self.previousOffset {
                self.currentBarStatus = .changing
                self.gotoTargetStatus()
            }else{//jia
                self.currentBarStatus = .changing
                self.gobackOriginStatus()
            }
        }else if (currentBarStatus == .disapear){
            if offsetScale < self.previousOffset   {
                self.currentBarStatus = .changing
                self.gobackOriginStatus()
            }else{//jia
                self.currentBarStatus = .changing
                self.gotoTargetStatus()
            }
        }else if (currentBarStatus == .changing){/*啥也不干*/  }
        self.previousOffset = offsetScale//记录上次一的偏移量
    }
    /**更改自身透明度的方法*/
    private func changeAlpha(scrollView : UIScrollView) -> Void {
        let offsetScale :  CGFloat = scrollView.contentOffset.y / scrollView.contentSize.height
        if currentBarStatus == .normal {
            if offsetScale > self.previousOffset {
                self.currentBarStatus = .changing
                self.gotoTargetStatus()
            }else{//jia
                self.currentBarStatus = .changing
                self.gobackOriginStatus()
            }
        }else if (currentBarStatus == .disapear){
            if offsetScale < self.previousOffset   {
                self.currentBarStatus = .changing
                self.gobackOriginStatus()
            }else{//jia
                self.currentBarStatus = .changing
                self.gotoTargetStatus()
            }
        }else if (currentBarStatus == .changing){/*啥也不干*/  }
        self.previousOffset = offsetScale//记录上次一的偏移量
        
    }
    /**更改背景色透明度*/
    private func changeBackgroundColorAlpha(scrollView : UIScrollView) -> Void {
        let offsetScale :  CGFloat = scrollView.contentOffset.y / scrollView.contentSize.height
        if currentBarStatus == .normal {
            if offsetScale > self.previousOffset {
                self.currentBarStatus = .changing
                self.gotoTargetStatus()
            }else{//jia
                self.currentBarStatus = .changing
                self.gobackOriginStatus()
            }
        }else if (currentBarStatus == .disapear){
            if offsetScale < self.previousOffset   {
                self.currentBarStatus = .changing
                self.gobackOriginStatus()
            }else{//jia
                self.currentBarStatus = .changing
                self.gotoTargetStatus()
                
            }
        }else if (currentBarStatus == .changing){/*啥也不干*/  }
        self.previousOffset = offsetScale//记录上次一的偏移量
        
    }
    private func gotoTargetStatus(){
        
        if self.layoutType == .asc {
            if self.currentBarActionType == .offset {
                UIView.animate(withDuration: 0.4, animations: {
                    self.frame = self.targetFrame
                }, completion: { (finish) in
                    self.currentBarStatus = .disapear
                })
            }else if (self.currentBarActionType == .color){
                UIView.animate(withDuration: 0.4, animations: {
                    self.backgroundColor = self.targetColorAlpha
                }, completion: { (finish) in
                    self.currentBarStatus = .disapear
                })
            }else if (self.currentBarActionType == .alpha){
                UIView.animate(withDuration: 0.4, animations: {
                    self.alpha = self.targetAlpha
                }, completion: { (finish) in
                    self.currentBarStatus = .disapear
                })
            }
        }else if (self.layoutType == .desc){
            if self.currentBarActionType == .offset {
                UIView.animate(withDuration: 0.4, animations: {
                    self.frame = self.originFrame
                }, completion: { (finish) in
                    self.currentBarStatus = .normal
                })
            }else if (self.currentBarActionType == .color){
                UIView.animate(withDuration: 0.4, animations: {
                    self.backgroundColor = self.originColorAlpha
                }, completion: { (finish) in
                    self.currentBarStatus = .normal
                })
            }else if (self.currentBarActionType == .alpha){
                UIView.animate(withDuration: 0.4, animations: {
                    self.alpha = self.originAlpha
                }, completion: { (finish) in
                    self.currentBarStatus = .normal
                })
            }
        }
        
    }
    private func gobackOriginStatus(){
        if self.layoutType == .asc {
            if self.currentBarActionType == .offset {
                UIView.animate(withDuration: 0.4, animations: {
                    self.frame = self.originFrame
                }, completion: { (finish) in
                    self.currentBarStatus = .normal
                })
            }else if (self.currentBarActionType == .color){
                UIView.animate(withDuration: 0.4, animations: {
                    self.backgroundColor = self.originColorAlpha
                }, completion: { (finish) in
                    self.currentBarStatus = .normal
                })
            }else if (self.currentBarActionType == .alpha){
                UIView.animate(withDuration: 0.4, animations: {
                    self.alpha = self.originAlpha
                }, completion: { (finish) in
                    self.currentBarStatus = .normal
                })
            }
        }else if (self.layoutType == .desc){
            if self.currentBarActionType == .offset {
                UIView.animate(withDuration: 0.4, animations: {
                    self.frame = self.targetFrame
                }, completion: { (finish) in
                    self.currentBarStatus = .disapear
                })
            }else if (self.currentBarActionType == .color){
                UIView.animate(withDuration: 0.4, animations: {
                    self.backgroundColor = self.targetColorAlpha
                }, completion: { (finish) in
                    self.currentBarStatus = .disapear
                })
            }else if (self.currentBarActionType == .alpha){
                UIView.animate(withDuration: 0.4, animations: {
                    self.alpha = self.targetAlpha
                }, completion: { (finish) in
                    self.currentBarStatus = .disapear
                })
            }
        }
        
    }
    
    /// 动态改变导航栏状态
    ///
    /// - parameter scrollView: 滚动视图
    
    var previousOffset : CGFloat = 0
    var scrollView : UIScrollView = UIScrollView()
    var originContentInset = UIEdgeInsets.zero
    func change(by scrollView : UIScrollView) {
        //        mylog(scrollView.contentOffset)
        if self.transitionType == TransitionType.immediately{
            if self.scrollView != scrollView {
                self.scrollView = scrollView
                self.originContentInset = scrollView.contentInset//有必要记录 , 刷新是会改变的
            }
            //        mylog(scrollView.contentOffset)
            if scrollView.contentOffset.y < -originContentInset.top {//下拉刷新部分
                mylog("下拉刷新部分")
                //导航栏应处于原始状态
                self.gobackOriginStatus()
                if (self.layoutType == .desc ){
                    if self.currentBarActionType == .color  {
                        self.alpha = 0
                    }else if (self.currentBarActionType == .offset ){ /*暂时没用,目前需求不可能刷新时让navibar移除,留出大片空间*/
                    }else if (self.currentBarActionType == .alpha){/*暂时没用,目前需求不可能一开始就透明*/}
                }
            }else  if scrollView.contentOffset.y >= -originContentInset.top && scrollView.contentOffset.y <= 0 {//inset.top范围
                mylog("inset.top范围")
                //                mylog(scrollView.contentOffset.y)
                //                mylog(scrollView.contentInset.top)
                //导航栏应处于原始状态
                self.gobackOriginStatus()
                if self.layoutType == .desc  && self.alpha <= 0.0{
                    if self.currentBarActionType == .color {
                        self.alpha = 1
                        self.backgroundColor = targetColorAlpha
                    }
                }
            }else if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y <= scrollView.contentSize.height - scrollView.bounds.size.height){//正常范围
                mylog("正常范围")
                let temp = self.currentBarActionType
                if self.layoutType == .desc  && self.alpha <= 0.0{
                    if self.currentBarActionType == .color {
                        self.currentBarActionType = .other
                    }
                }
                if currentBarActionType == .offset {//只有移动是一点驱动
                    self.changeOffsetWith(scrollView: scrollView)
                }else if(currentBarActionType == .alpha){//这个是根据fload来实现渐变
                    self.changeAlpha(scrollView: scrollView)
                }else if(currentBarActionType == .color){//这个是根据fload来实现渐变
                    self.changeBackgroundColorAlpha(scrollView: scrollView)
                }else if (self.currentBarActionType == .other){
                    if self.layoutType == .desc && self.alpha <= 0.0{
                        if temp == .color {
                            self.alpha = 1
                            self.backgroundColor = targetColorAlpha
                        }
                    }
                }
                self.currentBarActionType  = temp
                
            }else if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height &&  scrollView.contentOffset.y <= scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom){//inset.bottom范围
                mylog("inset.bottom范围")
                
                let temp = self.currentBarActionType
                if self.layoutType == .desc  && self.alpha <= 0.0{
                    if self.currentBarActionType == .color {
                        self.currentBarActionType = .other
                    }
                }
                if currentBarActionType == .offset {//只有移动是一点驱动
                    self.changeOffsetWith(scrollView: scrollView)
                }else if(currentBarActionType == .alpha){//这个是根据fload来实现渐变
                    self.changeAlpha(scrollView: scrollView)
                }else if(currentBarActionType == .color){//这个是根据fload来实现渐变
                    self.changeBackgroundColorAlpha(scrollView: scrollView)
                }else if (self.currentBarActionType == .other){
                    if self.layoutType == .desc && self.alpha <= 0.0{
                        if temp == .color {
                            self.alpha = 1
                            self.backgroundColor = targetColorAlpha
                        }
                    }
                }
                self.currentBarActionType  = temp
                
                
                
            }else if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom){//上拉加载部分
                mylog("上拉加载部分")
            }
        }else if self.transitionType == TransitionType.gradually {
            
            
            
        }
        
    }
    
    
    
    
    
    func changeWithOffset(offset : CGFloat){
        if offset > 1 || offset < 0 {
            return
        }
        if currentBarActionType == .offset {//只有移动是一点驱动
            if currentBarStatus == .normal {
                if offset > self.previousOffset {
                    self.currentBarStatus = .changing
                    UIView.animate(withDuration: 0.4, animations: {
                        self.frame = self.targetFrame
                    }, completion: { (finish) in
                        self.currentBarStatus = .disapear
                    })
                }
            }else if (currentBarStatus == .disapear){
                if offset < self.previousOffset   {
                    self.currentBarStatus = .changing
                    UIView.animate(withDuration: 0.4, animations: {
                        self.frame = self.originFrame
                    }, completion: { (finish) in
                        self.currentBarStatus = .normal
                    })
                    
                }
            }else if (currentBarStatus == .changing){/*啥也不干*/  }
            
        }else if(currentBarActionType == .alpha){//这个是根据fload来实现渐变
            
            
            
            
            
        }else if(currentBarActionType == .color){//这个是根据fload来实现渐变
            
        }
        self.previousOffset = offset
    }
    
    let originFrame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: DDNavigationBarHeight)
    let targetFrame = CGRect(x: 0, y: -DDNavigationBarHeight, width: SCREENWIDTH, height: DDNavigationBarHeight)
    let originAlpha : CGFloat = 1.0
    let targetAlpha : CGFloat = 0.0
    var originColorAlpha  : UIColor{ return (self.backgroundColor ?? UIColor.white).withAlphaComponent(1.0)}
    var targetColorAlpha : UIColor {return (self.backgroundColor ?? UIColor.white).withAlphaComponent(0)}
    //    let originColorAlpha  = originBackgroundColor.withAlphaComponent(1.0)
    //    let targetColorAlpha = originBackgroundColor.withAlphaComponent(0)
    
    @objc fileprivate  func backAction(_ sender : UIButton) -> () {
        delegate?.popToPreviousVC()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    
}
