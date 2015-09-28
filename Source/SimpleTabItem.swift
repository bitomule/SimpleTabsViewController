//
//  SimpleTabItem.swift
//  SimpleTabsViewController
//
//  Created by David Collado Sela on 19/5/15.
//  Copyright (c) 2015 David Collado Sela. All rights reserved.
//

import UIKit

public class SimpleTabItem:NSObject{
    var title = ""
    var forceShowCount = false
    var count = 0
    var index = 0
    
    internal var tabView:UIView!
    internal var label:UILabel!
    internal var countView:UIView!
    internal var countLabel:UILabel!
    internal var button:UIButton!
    
    internal var titleColor:UIColor!
    internal var titleFont:UIFont!
    internal var numberBackgroundColor:UIColor!
    internal var numberFont:UIFont!
    internal var numberColor:UIColor!
    
    private var tabContainer:SimpleTabsViewController!
    
    private var previousTab:SimpleTabItem?
    private var nextTab:SimpleTabItem?
    
    private var labelConstraints = [NSLayoutConstraint]()
    
    public init(title:String,forceShowCount:Bool = false,count:Int=0){
        self.title = title
        self.forceShowCount = forceShowCount
        self.count = count
    }
    
    public func createTabView(textFont:UIFont,textColor:UIColor,numberFont:UIFont,numberColor:UIColor,numberBackgroundColor:UIColor,tabContainer:SimpleTabsViewController,previousTab:SimpleTabItem?,nextTab:SimpleTabItem?)->UIView{
        
        self.titleColor = textColor
        self.titleFont = textFont
        self.numberBackgroundColor = numberBackgroundColor
        self.numberFont = numberFont
        self.numberColor = numberColor
        
        self.tabContainer = tabContainer
        tabView = UIView(frame: CGRect(x: 100, y: 0, width: 100, height: 43))
        tabView.translatesAutoresizingMaskIntoConstraints = false
        label = UILabel()
        label.setContentHuggingPriority(251, forAxis: UILayoutConstraintAxis.Horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.title
        tabView.addSubview(label)
        if(self.forceShowCount || self.count > 0){
            showCountView()
        }else{
            setLabelConstraints(label,container: tabView)
        }
        
        button = UIButton()
        button.addTarget(self, action: "tabPressed", forControlEvents: UIControlEvents.TouchUpInside)
        button.setContentHuggingPriority(250, forAxis: UILayoutConstraintAxis.Horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        tabView.addSubview(button)
        setButtonConstraints(button,container: tabView)
        
        self.previousTab = previousTab
        self.nextTab = nextTab
        updateStyle()
        return tabView
    }
    
    internal func updateStyle(){
        if let countLabel = countLabel{
            countLabel.font = numberFont
            countLabel.textColor = numberColor
        }
        if let countView = countView{
            countView.backgroundColor = numberBackgroundColor
        }
        label.font = titleFont
        label.textColor = titleColor
    }
    
    internal func updateCount(count:Int){
        self.count = count
        if(self.forceShowCount || self.count > 0){
            showCountView()
        }else{
            hideCountView()
        }
    }
    
    private func showCountView(){
        if(countView == nil){
            countView = UIView()
            countView.translatesAutoresizingMaskIntoConstraints = false
            countView.layer.cornerRadius = 6
            countLabel = UILabel()
            countLabel.translatesAutoresizingMaskIntoConstraints = false
            countView.addSubview(countLabel)
            tabView.addSubview(countView)
            tabView.removeConstraints(labelConstraints)
            label.removeConstraints(labelConstraints)
            setCountLabelConstraints(countLabel,container:countView)
            setLabelWithCountConstraints(label,countView:countView,container: tabView)
            updateStyle()
        }
        countLabel.text = String(self.count)
    }
    
    private func hideCountView(){
        if(countView != nil){
            countView.removeFromSuperview()
            countView = nil
            setLabelConstraints(label,container: tabView)
        }
    }
    
    internal func tabPressed(){
        tabContainer.tabSelected(self.index)
    }
    
    //MARK: - Constraints
    
    internal func setConstraints(){
        setTabCommonConstraints()
        
        if let previousTab = previousTab{
            if(nextTab != nil){
                //Middle
                setMiddleTabConstraints(previousTab)
            }else{
                //Last
                setLastTabConstraints(previousTab)
            }
        }else{
            //First
            setFirstTabConstraints()
        }
    }
    
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
        labelConstraints = [alignYCenter,trailingSpace,trailingSpaceFromCount,leadingSpace,centerY]
        container.addConstraints(labelConstraints)
    }
    
    private func setLabelConstraints(label:UILabel,container:UIView){
        let alignYCenter = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -4)
        let trailingSpace = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: label, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 11)
        let leadingSpace = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 11)
        labelConstraints = [alignYCenter,trailingSpace,leadingSpace]
        container.addConstraints(labelConstraints)
    }
    
    private func setButtonConstraints(button:UIButton,container:UIView){
        let trailingSpace = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        let leadingSpace = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        let bottonSpace = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let topSpace = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        container.addConstraints([trailingSpace,leadingSpace,bottonSpace,topSpace])
    }
    
    // MARK : - Tab constraints
    
    private func setTabCommonConstraints(){
        let bottonSpace = NSLayoutConstraint(item: tabView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: tabContainer.tabsContainer, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -1)
        let topSpace = NSLayoutConstraint(item: tabView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: tabContainer.tabsContainer, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        tabContainer.tabsContainer.addConstraints([bottonSpace,topSpace])
    }
    
    private func setFirstTabConstraints(){
        let leadingSpace = NSLayoutConstraint(item: tabView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: tabContainer.tabsContainer, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        tabContainer.tabsContainer.addConstraints([leadingSpace])
    }
    
    private func setMiddleTabConstraints(previousTab:SimpleTabItem){
        let leadingSpace = NSLayoutConstraint(item: tabView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: previousTab.tabView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        tabContainer.tabsContainer.addConstraints([leadingSpace])
    }
    
    private func setLastTabConstraints(previousTab:SimpleTabItem){
        let trailingSpace = NSLayoutConstraint(item: tabView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: tabContainer.tabsContainer, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        
        let leadingSpace = NSLayoutConstraint(item: tabView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: previousTab.tabView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        tabContainer.tabsContainer.addConstraints([trailingSpace,leadingSpace])
    }
}
