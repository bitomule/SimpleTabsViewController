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
    var showsCount = false
    var count = 0
    var index = 0
    
    var tabView:UIView!
    var label:UILabel!
    var countView:UIView!
    var countLabel:UILabel!
    var button:UIButton!
    
    var tabContainer:SimpleTabsViewController!
    
    var previousTab:SimpleTabItem?
    var nextTab:SimpleTabItem?
    
    init(title:String,showsCount:Bool = false,count:Int=0){
        self.title = title
        self.showsCount = showsCount
        self.count = count
    }
    
    func createTabView(textFont:UIFont,textColor:UIColor,numberFont:UIFont,numberColor:UIColor,numberBackgroundColor:UIColor,tabContainer:SimpleTabsViewController,previousTab:SimpleTabItem?,nextTab:SimpleTabItem?)->UIView{
        self.tabContainer = tabContainer
        tabView = UIView(frame: CGRect(x: 100, y: 0, width: 100, height: 43))
        tabView.setTranslatesAutoresizingMaskIntoConstraints(false)
        label = UILabel()
        label.setContentHuggingPriority(251, forAxis: UILayoutConstraintAxis.Horizontal)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.text = self.title
        label.font = textFont
        label.textColor = textColor
        tabView.addSubview(label)
        if(self.showsCount){
            //Create count view
            countView = UIView()
            countView.backgroundColor = numberBackgroundColor
            countView.setTranslatesAutoresizingMaskIntoConstraints(false)
            countView.layer.cornerRadius = 6
            countLabel = UILabel()
            countLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            countLabel.font = numberFont
            countLabel.textColor = numberColor
            countLabel.text = String(self.count)
            countView.addSubview(countLabel)
            tabView.addSubview(countView)
            setCountLabelConstraints(countLabel,container:countView)
            setLabelWithCountConstraints(label,countView:countView,container: tabView)
        }else{
            setLabelConstraints(label,container: tabView)
        }
        
        button = UIButton()
        button.addTarget(self, action: "tabPressed", forControlEvents: UIControlEvents.TouchUpInside)
        button.setContentHuggingPriority(250, forAxis: UILayoutConstraintAxis.Horizontal)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        tabView.addSubview(button)
        setButtonConstraints(button,container: tabView)
        
        self.previousTab = previousTab
        self.nextTab = nextTab
        
        return tabView
    }
    
    func tabPressed(){
        tabContainer.setCurrentTab(self.index, animated: true)
    }
    
    
    //MARK: - Constraints
    
    func setConstraints(){
        setTabCommonConstraints()
        
        if let previousTab = previousTab{
            if let nextTab = nextTab{
                //Intermedio
                setMiddleTabConstraints(previousTab)
            }else{
                //Ultimo
                setLastTabConstraints(previousTab)
            }
        }else{
            //Primero
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
        container.addConstraints([alignYCenter,trailingSpace,trailingSpaceFromCount,leadingSpace,centerY])
    }
    
    private func setLabelConstraints(label:UILabel,container:UIView){
        let alignYCenter = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -4)
        let trailingSpace = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: label, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 11)
        let leadingSpace = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 11)
        container.addConstraints([alignYCenter,trailingSpace,leadingSpace])
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
