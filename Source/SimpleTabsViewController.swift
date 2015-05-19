//
//  SimpleTabberViewController.swift
//  SimpleTabberViewController
//
//  Created by David Collado Sela on 19/5/15.
//  Copyright (c) 2015 David Collado Sela. All rights reserved.
//

import UIKit

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
    }
    
    func setTabCount(tabIndex:Int,count:Int){
        if(self.items[tabIndex].countLabel != nil){
            self.items[tabIndex].countLabel.text = String(count)
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
        centerMarkerConstraint = NSLayoutConstraint(item: activeMarker, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.items[currentTab].tabView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        widthMarkerConstraint = NSLayoutConstraint(item: activeMarker, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.items[currentTab].tabView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
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
            items[i].index = i
            let tab = createTab(items[i])
            self.tabsContainer.addSubview(tab)
            items[i].setConstraints()
        }
    }
    
    private func createTab(item:SimpleTabItem) -> UIView{
        var previousItem:SimpleTabItem?
        if((item.index - 1) >= 0){
            previousItem = self.items[item.index - 1]
        }
        var nextItem:SimpleTabItem?
        if((item.index + 1) < self.items.count){
            nextItem = self.items[item.index + 1]
        }
        return item.createTabView(tabsFont, textColor: textColor, numberFont: numbersFont, numberColor: numbersColor, numberBackgroundColor: numbersBackgroundColor, tabContainer: self,previousTab:previousItem,nextTab:nextItem)
    }
    
    
}