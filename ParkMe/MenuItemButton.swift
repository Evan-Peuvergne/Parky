//
//  MenuItemButton.swift
//  ParkMe
//
//  Created by evan peuvergne on 09/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//

import UIKit

class MenuItemButton: UIButton
{
    
    
    // Variables
    
    var notifs: Int
    
    var border: UIView
    var label: UILabel
    
    
    
    // Init
    
    required init?(coder aDecoder: NSCoder)
    {
        
        // Init
        self.notifs = 0;
        
        self.border = UIView()
        self.label = UILabel()
        super.init(coder: aDecoder)
        
        // Border
        self.border.backgroundColor = UIColorFromRGB(0xe1ecfb)
        self.border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.border)
        
        self.addConstraint(NSLayoutConstraint(item: self.border, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.border, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.border, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 0, constant: 1))
        self.addConstraint(NSLayoutConstraint(item: self.border, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
    
        // Label
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.text = ""
        self.label.font = UIFont(name: "Avenir-Heavy", size: 12)
        self.label.textColor = UIColor.whiteColor()
        self.label.textAlignment = .Center
        self.label.layer.backgroundColor = UIColorFromRGB(0x4a90e2).CGColor
        self.label.layer.cornerRadius = 10
        self.updateLabel(0)
        self.addSubview(self.label)
        
        self.addConstraint(NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20))
        self.addConstraint(NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 0, constant: 20))
        self.addConstraint(NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 0, constant: 20))
        self.addConstraint(NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        

    }
    
    
    
    // Label
    
    func updateLabel(value: Int)
    {
        
        // Value
        self.label.text = String(value)
        self.notifs = value
        
        // Show/Hide
        if(self.notifs <= 0){ self.label.hidden = true }
        else{ self.label.hidden = false }
        
    }

}




// Utils


// Utils > Color

func UIColorFromRGB(rgbValue: UInt) -> UIColor
{
    
    // Calc
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
    
}
