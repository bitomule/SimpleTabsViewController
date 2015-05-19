//
//  ViewController.swift
//  SimpleTabsViewController
//
//  Created by David Collado Sela on 19/5/15.
//  Copyright (c) 2015 David Collado Sela. All rights reserved.
//

import UIKit

class ViewController: UIViewController,SimpleTabsDelegate {

    var vc:SimpleTabsViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        let tab1 = SimpleTabItem(title:"Tab 1")
        let tab2 = SimpleTabItem(title:"Another tab",showsCount:true,count:3)
        let tab3 = SimpleTabItem(title:"Yay")
        vc = SimpleTabsViewController.create(self, baseView: containerView, delegate: self, items: [tab1,tab2,tab3], textColor: UIColor.blackColor(), numbersColor: UIColor.redColor(),numbersBackgroundColor:UIColor.yellowColor(), markerColor: UIColor.greenColor())
        
        vc.setTabCount(1, count: 5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var containerView: UIView!
    
    // MARK : - SimpleTabsDelegate
    
    func tabSelected(tabIndex:Int){
        println(tabIndex)
    }
}

