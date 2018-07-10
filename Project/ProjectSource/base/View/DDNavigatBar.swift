//
//  GDNavigatBar.swift
//  hhcszgd
//
//  Created by WY on 17/1/15.
//  Copyright © 2017年 com.16lao.zjlao. All rights reserved.
//

import UIKit

@objc protocol CustomNaviBarDelegate {
    func popToPreviousVC() -> Void
}
protocol CustomnaviBarStatusDelegate {
    func navigationBarHasChanged(status :  NaviBarStatus) -> Void
}
enum LayoutType {
    case desc/*下降的*/ // 监听属性 , 当这个被赋值时 , navibarstatus初始状态必须是消失状态
    case asc /*ascending上升的*/ // 监听属性 , 当这个被赋值时 , navibarstatus初始状态必须是正常状态状态
}

/// 初始化控制器时,导航栏是否带返回按钮
///
/// - withBackBtn:    有返回键
/// - withoutBackBtn: 没有返回键
enum NaviBarStyle {
    case withBackBtn
    case withoutBackBtn
}

/// 导航栏改变的方式
///
/// - offset:   通过改变位置来实现消失/出现
/// - alpha: 通过改变整体透明度实现消失/出现
/// - color: 通过改变背景色实现消失/出现(非子控件不变)
enum NaviBarActionType {
    case offset
    case alpha
    case color
    case other
}

/// 导航栏状态
///
/// - normal:   正常出现状态
/// - changing: 状态改变中
/// - disapear: 已经消失
enum NaviBarStatus {
    case normal
    case changing
    case disapear
}

/// 导航栏过渡的类型
///
/// - immediately: 导航栏的状态 在contentOffset达到某个值时立刻改变 , 默认
/// - gradually: 导航栏的状态根据contentOffset的改变而渐渐的改变
enum TransitionType  {
    case immediately
    case gradually
}

class DDNavigatBar: UIView {
    var  currentType : NaviBarStyle  = NaviBarStyle.withBackBtn{
        willSet{
            switch newValue {

            case .withBackBtn:

                leftSubViewsContainer.backgroundColor = UIColor.randomColor()
                rightSubViewsContainer.backgroundColor = UIColor.randomColor()
                
                self.addSubview(backBtn)
                self.addSubview(leftSubViewsContainer)
                self.addSubview(rightSubViewsContainer)
//                backBtn.backgroundColor = UIColor.randomColor()
                backBtn.setImage(UIImage(named:"back_icon"), for: UIControlState.normal)
                backBtn.addTarget(self, action:#selector(backAction(_:)) , for:UIControlEvents.touchUpInside)
                break
            case .withoutBackBtn:
                for item in self.subviews {
                    item.removeFromSuperview()
                }
                leftSubViewsContainer.backgroundColor = UIColor.randomColor()
                rightSubViewsContainer.backgroundColor = UIColor.randomColor()
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
    var backBtn : UIButton! //= UIButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
    private var  titleLabel : UILabel! // = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 88.0, height: 44))
    var attributeTitle : NSAttributedString {
        set{
            mylog(newValue)
            titleLabel.isHidden = false
            if titleLabel.superview == nil  {
                self.addSubview(titleLabel)
                titleLabel.textColor = UIColor.white
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
                titleLabel.textColor = UIColor.white
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
    
    
    var  leftSubViewsContainer : UIView! // = UIView()
    
    
    var leftBarButtons  = [UIView]() {
        
        willSet{
            
        }
        didSet{
            for oldSub in leftSubViewsContainer.subviews {
                oldSub.removeFromSuperview()
            }
            
            if currentType == .withBackBtn {
                let leftSubViewsContainerW = 44.0  * CGFloat( leftBarButtons.count)  > UIScreen.main.bounds.size.width * 0.5 - 44.0 ? UIScreen.main.bounds.size.width * 0.5 - 44.0 : CGFloat( 44 * leftBarButtons.count)
                leftSubViewsContainer.frame = CGRect(x: 44, y: DDNavigationBarHeight - 44, width: leftSubViewsContainerW, height: 44)
                for (index , newSub) in leftBarButtons.enumerated() {
                    if 44.0  * CGFloat(index+1)  > UIScreen.main.bounds.size.width * 0.5 - 44.0 {
                        leftSubViewsContainer.frame = CGRect(x: 44, y: DDNavigationBarHeight - 44, width: 44.0  * CGFloat(index), height: 44)
                        return
                    }
                    
                    leftSubViewsContainer.addSubview(newSub)
                    newSub.frame = CGRect(x: index * 44, y: 0, width: 44, height: 44)
                    
                }
            }else{
                let leftSubViewsContainerW = 44.0  * CGFloat( leftBarButtons.count)  > UIScreen.main.bounds.size.width * 0.5  ? UIScreen.main.bounds.size.width * 0.5 : CGFloat( 44 * leftBarButtons.count)
                leftSubViewsContainer.frame = CGRect(x: 0, y: DDNavigationBarHeight - 44 , width: leftSubViewsContainerW, height: 44)
                for (index , newSub) in leftBarButtons.enumerated() {
                    if 44.0  * CGFloat(index+1)  > UIScreen.main.bounds.size.width * 0.5  {
                        leftSubViewsContainer.frame = CGRect(x: 0, y: DDNavigationBarHeight - 44, width: 44.0  * CGFloat(index), height: 44)
                        return
                    }
                    
                    leftSubViewsContainer.addSubview(newSub)
                    newSub.frame = CGRect(x: index * 44, y: 0, width: 44, height: 44)
                }
            }
            
            
        }
        
    }
    
    
    
    var  rightSubViewsContainer : UIView!// = UIView()
    
    var rightBarButtons  = [UIView]() {
        
        willSet{
            
        }
        didSet{
            for oldSub in rightSubViewsContainer.subviews {
                oldSub.removeFromSuperview()
            }
            let rightSubViewsContainerW = 44.0  * CGFloat( rightBarButtons.count)  > UIScreen.main.bounds.size.width * 0.5  ? UIScreen.main.bounds.size.width * 0.5  : CGFloat( 44 * rightBarButtons.count)
            rightSubViewsContainer.frame = CGRect(x: UIScreen.main.bounds.size.width - rightSubViewsContainerW, y: DDNavigationBarHeight - 44, width: rightSubViewsContainerW, height: 44)
            for (index , newSub) in rightBarButtons.enumerated() {
                if 44.0  * CGFloat(index + 1 )  > UIScreen.main.bounds.size.width * 0.5  {
                    rightSubViewsContainer.frame = CGRect(x: UIScreen.main.bounds.size.width - 44.0 * CGFloat(index), y: DDNavigationBarHeight - 44, width: 44.0  * CGFloat(index), height: 44)
                    return
                }
                
                rightSubViewsContainer.addSubview(newSub)
                newSub.frame = CGRect(x: index * 44, y: 0, width: 44, height: 44)
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
            let y : CGFloat = DDNavigationBarHeight - 44 + inset.top
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
    /*
    convenience init(type:NaviBarStyle){
        self.init(frame: CGRect.zero)
        currentType = type
        switch currentType {
        case .withBackBtn:
            leftSubViewsContainer.backgroundColor = UIColor.randomColor()
            rightSubViewsContainer.backgroundColor = UIColor.randomColor()
            
            self.addSubview(backBtn)
            self.addSubview(leftSubViewsContainer)
            self.addSubview(rightSubViewsContainer)
            backBtn.backgroundColor = UIColor.randomColor()
            backBtn.addTarget(self, action:#selector(backAction(_:)) , for:UIControlEvents.touchUpInside)
            break
        case .withoutBackBtn:
            leftSubViewsContainer.backgroundColor = UIColor.randomColor()
            rightSubViewsContainer.backgroundColor = UIColor.randomColor()
            self.addSubview(leftSubViewsContainer)
            self.addSubview(rightSubViewsContainer)
            break
        }
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        backBtn = UIButton(frame: CGRect(x: 0, y: DDNavigationBarHeight - 44, width: 44, height: 44))
        backBtn.adjustsImageWhenHighlighted = false 
        titleLabel = UILabel(frame: CGRect(x: 0, y: DDNavigationBarHeight - 44 , width: UIScreen.main.bounds.size.width - 88.0, height: 44))
        titleLabel.isHidden = true;
        titleLabel.textAlignment = NSTextAlignment.center
        self.addSubview(titleLabel)
        titleLabel.textColor = .white
        leftSubViewsContainer  = UIView()
        rightSubViewsContainer = UIView()
        titleLabel.center = CGPoint(x: UIScreen.main.bounds.size.width/2.0, y: DDNavigationBarHeight - 44 + 22  );
        leftSubViewsContainer.backgroundColor = UIColor.randomColor()
        rightSubViewsContainer.backgroundColor = UIColor.randomColor()
        
        //        self.addSubview(backBtn)
        self.addSubview(leftSubViewsContainer)
        self.addSubview(rightSubViewsContainer)
//        backBtn.backgroundColor = UIColor.randomColor()
        backBtn.setImage(UIImage(named:"back_icon"), for: UIControlState.normal)
        backBtn.addTarget(self, action:#selector(backAction(_:)) , for:UIControlEvents.touchUpInside)
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
//                mylog("下拉刷新部分")
                //导航栏应处于原始状态
                self.gobackOriginStatus()
                if (self.layoutType == .desc ){
                    if self.currentBarActionType == .color  {
                        self.alpha = 0
                    }else if (self.currentBarActionType == .offset ){ /*暂时没用,目前需求不可能刷新时让navibar移除,留出大片空间*/
                    }else if (self.currentBarActionType == .alpha){/*暂时没用,目前需求不可能一开始就透明*/}
                }
            }else  if scrollView.contentOffset.y >= -originContentInset.top && scrollView.contentOffset.y <= 0 {//inset.top范围
//                mylog("inset.top范围")
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
//                mylog("正常范围")
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
//                mylog("inset.bottom范围")
                
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
//                mylog("上拉加载部分")
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
    let targetFrame = CGRect(x: 0, y: -DDNavigationBarHeight, width: SCREENHEIGHT, height: DDNavigationBarHeight)
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
class NavTitleView: UIView {
    var insets : UIEdgeInsets = UIEdgeInsets.zero
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}
