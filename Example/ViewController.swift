//
//  ViewController.swift
//  SimpleTabsViewController
//
//  Created by David Collado Sela on 19/5/15.
//  Copyright (c) 2015 David Collado Sela. All rights reserved.
//

import UIKit

class ViewController: UIViewController,SimpleTabsDelegate {
    
    //Example only code
    var firstTabCount = 0
    @IBAction func increaseCount(sender: AnyObject) {
        firstTabCount++
        vc.setTabCount(0, count: firstTabCount)
    }
    
    @IBAction func decreaseCount(sender: AnyObject) {
        if firstTabCount > 0{
            firstTabCount--
        }
        vc.setTabCount(0, count: firstTabCount)
    }
    
    @IBAction func updateStyle(sender: AnyObject) {
        vc.setTabTitleColor(getRandomColor())
        vc.setNumberColor(getRandomColor())
        vc.setNumberBackgroundColor(getRandomColor())
        vc.setMarkerColor(getRandomColor())
    }
    
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    @IBOutlet weak var indexSelectedLabel: UILabel!

    
    var vc:SimpleTabsViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        let tab1 = SimpleTabItem(title:"Tab 1")
        let tab2 = SimpleTabItem(title:"Another tab",count:3)
        let tab3 = SimpleTabItem(title:"Yay")
        vc = SimpleTabsViewController.create(self, baseView: containerView, delegate: self, items: [tab1,tab2,tab3])
        vc.setTabTitleColor(UIColor.blackColor())
        vc.setNumberColor(UIColor.blackColor())
        vc.setNumberBackgroundColor(UIColor.yellowColor())
        vc.setMarkerColor(UIColor.greenColor())
        vc.setTabTitleFont(UIFont.systemFontOfSize(16))
        vc.setNumberFont(UIFont.systemFontOfSize(15))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var containerView: UIView!
    
    // MARK : - SimpleTabsDelegate
    
    func tabSelected(tabIndex:Int){
        indexSelectedLabel.text = "Index selected: \(tabIndex)"
    }
}

