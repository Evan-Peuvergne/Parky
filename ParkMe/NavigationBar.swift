//
//  NavigationBar.swift
//  ParkMe
//
//  Created by evan peuvergne on 10/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationBar
{

    
    // Init
    
    
    // Init > Coder
    
    required init?(coder aDecoder: NSCoder)
    {
    
        // Init
        super.init(coder: aDecoder)
        
        // Title
        let titleLabel = UILabel()
        // let colour = UIColor.init(red: 134.0/255.0, green: 134.0/255.0, blue: 134.0/255.0, alpha: 1)
        // let colour = UIColor.init(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1)
        // let colour = UIColor.whiteColor()
        let colour = UIColor.blackColor()
        let attributes: [String : AnyObject] = [NSFontAttributeName: UIFont.init(name: "Avenir-Heavy", size: 17)!, NSForegroundColorAttributeName: colour, NSKernAttributeName : 1.5]
        titleLabel.attributedText = NSAttributedString(string: (self.topItem?.title)!, attributes: attributes)
        titleLabel.sizeToFit()
        self.topItem?.titleView = titleLabel
        
    }

}
