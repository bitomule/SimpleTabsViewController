//
//  SimpleTabberViewController.swift
//  SimpleTabberViewController
//
//  Created by David Collado Sela on 19/5/15.
//  Copyright (c) 2015 David Collado Sela. All rights reserved.
//

import UIKit

public struct SimpleTabItem {
    var title = ""
    var showsCount = false
    var count = 0
}

public class SimpleTabsViewController: UIViewController {
    
    class func create(parentVC:UIViewController,baseView:UIView?,delegate:SimpleTabsDelegate?,items:[SimpleTabItem],textColor:UIColor = UIColor.blackColor(),numbersColor:UIColor = UIColor.blackColor(),numbersBackgroundColor:UIColor = UIColor.yellowColor(),markerColor:UIColor = UIColor.redColor(),tabsFont:UIFont = UIFont.systemFontOfSize(15),numbersFont:UIFont = UIFont.systemFontOfSize(15)) -> SimpleTabsViewController{
        let newVC = SimpleTabsViewController(items: items)
        newVC.textColor = textColor
        newVC.numbersColor = numbersColor
        newVC.markerColor = markerColor
        newVC.tabsFont = tabsFont
        newVC.numbersFont = numbersFont
        newVC.willMoveToParentViewController(parentVC)
        if let baseView = baseView{
            baseView.addSubview(newVC.view)
        }else{
            parentVC.view.addSubview(newVC.view)
        }
        newVC.didMoveToParentViewController(parentVC)
        if let baseView = baseView{
            newVC.view.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: baseView.frame.size)
        }else{
            newVC.view.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: parentVC.view.frame.size)
        }
        return newVC
    }
    
    var items:[SimpleTabItem] = [SimpleTabItem]()
    var tabs:[UIView] = [UIView]()
    var tabsCountLabel:[UILabel?] = [UILabel?]()
    var currentTab = 0
    var delegate:SimpleTabsDelegate?
    
    var tabsContainer: UIView!
    
    var activeMarker: UIView!
    
    var bottomReference: UIView!
    
    var centerMarkerConstraint:NSLayoutConstraint?
    var widthMarkerConstraint:NSLayoutConstraint?
    
    var textColor:UIColor = UIColor.blackColor()
    var numbersColor:UIColor = UIColor.blackColor()
    var numbersBackgroundColor:UIColor = UIColor.yellowColor()
    var markerColor:UIColor = UIColor.redColor()
    var tabsFont = UIFont.systemFontOfSize(15)
    var numbersFont = UIFont.systemFontOfSize(15)
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createBaseView()
        createMenu()
        setCurrentTab(0, animated: false)
    }
    
    convenience init(items:[SimpleTabItem]) {
        self.init(nibName: nil, bundle: nil)
        self.items = items
        self.tabsCountLabel = [UILabel?](count:items.count, repeatedValue: nil)
    }
    
    func setTabCount(tabIndex:Int,count:Int){
        if(tabsCountLabel[tabIndex] != nil){
            tabsCountLabel[tabIndex]!.text = String(count)
        }
    }
    
    //MARK: - Base View
    
    private func createBaseView(){
        createBottomView()
        createTabsContainer()
        createMarker()
    }
    
    private func createBottomView(){
        bottomReference = UIView(frame: CGRect(x: -10, y: 48, width: self.view.bounds.width, height: 2))
        bottomReference.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(bottomReference)
        let trailingConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: bottomReference, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -10)
        let leadingConstraint = NSLayoutConstraint(item: bottomReference, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: -10)
        let bottomSpaceConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bottomReference, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: bottomReference, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 2)
        bottomReference.addConstraint(heightConstraint)
        self.view.addConstraints([trailingConstraint,leadingConstraint,bottomSpaceConstraint])
    }
    
    private func createTabsContainer(){
        tabsContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        tabsContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(tabsContainer)
        let centerXConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: tabsContainer, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: tabsContainer, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -4)
        let topConstraint = NSLayoutConstraint(item: tabsContainer, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        self.view.addConstraints([centerXConstraint,centerYConstraint,topConstraint])
    }
    
    private func createMarker(){
        activeMarker = UIView(frame: CGRect(x: 50, y: 50, width: 200, height: 2))
        activeMarker.backgroundColor = markerColor
        activeMarker.setTranslatesAutoresizingMaskIntoConstraints(false)
        tabsContainer.addSubview(activeMarker)
        let bottomSpaceConstraint = NSLayoutConstraint(item: tabsContainer, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: activeMarker, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8)
        let heightConstraint = NSLayoutConstraint(item: activeMarker, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 2)
        activeMarker.addConstraint(heightConstraint)
        tabsContainer.addConstraints([bottomSpaceConstraint])
    }
    
    //MARK: - Tabs
    
    public func setCurrentTab(tab:Int,animated:Bool){
        currentTab = tab
        delegate?.tabSelected(tab)
        if(centerMarkerConstraint != nil && widthMarkerConstraint != nil){
            self.tabsContainer.removeConstraints([centerMarkerConstraint!,widthMarkerConstraint!])
        }
        centerMarkerConstraint = NSLayoutConstraint(item: activeMarker, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: tabs[currentTab], attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        widthMarkerConstraint = NSLayoutConstraint(item: activeMarker, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: tabs[currentTab], attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        if(animated){
            self.tabsContainer.addConstraints([self.widthMarkerConstraint!,self.centerMarkerConstraint!])
            self.tabsContainer.setNeedsUpdateConstraints()
            UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.view.layoutIfNeeded()
                
                }, completion: { finished in
            })
        }else{
            tabsContainer.addConstraints([widthMarkerConstraint!,centerMarkerConstraint!])
        }
    }
    
    func tabPressed(sender:UIButton!){
        setCurrentTab(sender.tag,animated: true)
    }
    
    //MARK: - Menu Creation
    
    private func createMenu(){
        for(var i=0;i<items.count;i++){
            let tab = createTab()
            self.tabsContainer.addSubview(tab)
            tabs.append(tab)
            setTabCommonConstraints(tab)
            if(i == 0){
                setFirstTabConstraints(tab)
            }else if(i == (items.count - 1)){
                setLastTabConstraints(tab)
            }else{
                setMiddleTabConstraints(tab)
            }
        }
    }
    
    private func setItems(items:[SimpleTabItem]){
        self.items = items
        for(var i=0;i<items.count;i++){
            let tab = createTab()
            self.tabsContainer.addSubview(tab)
            tabs.append(tab)
            if(i == 0){
                setFirstTabConstraints(tab)
            }else if(i == (items.count - 1)){
                setLastTabConstraints(tab)
            }else{
                setMiddleTabConstraints(tab)
            }
        }
    }
    
    private func createTab() -> UIView{
        let tabView = UIView(frame: CGRect(x: 100*tabs.count, y: 0, width: 115, height: 43))
        tabView.frame.size.width = 100
        tabView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let label = UILabel()
        label.setContentHuggingPriority(251, forAxis: UILayoutConstraintAxis.Horizontal)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.text = items[tabs.count].title
        label.font = tabsFont
        label.textColor = textColor
        tabView.addSubview(label)
        
        if(items[tabs.count].showsCount){
            //Create count view
            let countView = UIView()
            countView.backgroundColor = numbersBackgroundColor
            countView.setTranslatesAutoresizingMaskIntoConstraints(false)
            countView.layer.cornerRadius = 6
            let countLabel = UILabel()
            countLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            countLabel.font = numbersFont
            countLabel.textColor = numbersColor
            countLabel.text = String(items[tabs.count].count)
            countView.addSubview(countLabel)
            tabView.addSubview(countView)
            setCountLabelConstraints(countLabel,container:countView)
            setLabelWithCountConstraints(label,countView:countView,container: tabView)
            tabsCountLabel[tabs.count] = countLabel
        }else{
            setLabelConstraints(label,container: tabView)
            tabsCountLabel[tabs.count] = nil
        }
        
        
        let button = UIButton()
        button.tag = tabs.count
        button.addTarget(self, action: "tabPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setContentHuggingPriority(250, forAxis: UILayoutConstraintAxis.Horizontal)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        tabView.addSubview(button)
        setButtonConstraints(button,container: tabView)
        
        return tabView
    }
    
    //MARK: - Constraints makers
    
    private func setCountLabelConstraints(countLabel:UILabel,container:UIView){
        let trailingSpace = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: countLabel, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 5)
        let leadingSpace = NSLayoutConstraint(item: countLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 5)
        let bottonSpace = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: countLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 2)
        let topSpace = NSLayoutConstraint(item: countLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 2)
        container.addConstraints([trailingSpace,leadingSpace,bottonSpace,topSpace])
    }
    
    private func setLabelWithCountConstraints(label:UILabel,countView:UIView,container:UIView){
        let alignYCenter = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -4)
        
        let trailingSpace = NSLayoutConstraint(item: countView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: label, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 11)
        
        let trailingSpaceFromCount = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: countView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 11)
        let leadingSpace = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 11)
        let centerY = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: countView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        container.addConstraints([alignYCenter,trailingSpace,trailingSpaceFromCount,leadingSpace,centerY])
    }
    
    private func setButtonConstraints(button:UIButton,container:UIView){
        let trailingSpace = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        let leadingSpace = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        let bottonSpace = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let topSpace = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        container.addConstraints([trailingSpace,leadingSpace,bottonSpace,topSpace])
    }
    
    private func setLabelConstraints(label:UILabel,container:UIView){
        let alignYCenter = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -4)
        let trailingSpace = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: label, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 11)
        let leadingSpace = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 11)
        container.addConstraints([alignYCenter,trailingSpace,leadingSpace])
    }
    
    private func setTabCommonConstraints(tab:UIView){
        let bottonSpace = NSLayoutConstraint(item: tab, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tabsContainer, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -1)
        let topSpace = NSLayoutConstraint(item: tab, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tabsContainer, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        self.tabsContainer.addConstraints([bottonSpace,topSpace])
    }
    
    private func setFirstTabConstraints(tab:UIView){
        let leadingSpace = NSLayoutConstraint(item: tab, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.tabsContainer, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        self.tabsContainer.addConstraints([leadingSpace])
    }
    
    private func setLastTabConstraints(tab:UIView){
        let trailingSpace = NSLayoutConstraint(item: tab, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.tabsContainer, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        
        let leadingSpace = NSLayoutConstraint(item: tab, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: tabs[tabs.count - 2], attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        self.tabsContainer.addConstraints([trailingSpace,leadingSpace])
    }
    
    private func setMiddleTabConstraints(tab:UIView){
        let leadingSpace = NSLayoutConstraint(item: tab, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: tabs[tabs.count - 2], attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        self.tabsContainer.addConstraints([leadingSpace])
    }
    
}