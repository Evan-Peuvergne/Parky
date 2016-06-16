//
//  FormInput.swift
//  ParkMe
//
//  Created by evan peuvergne on 15/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//

import UIKit





// Class

class FormInput: UITextField {

    
    
    
    
    // Properties
    
    
    // Properties > Outlets
    
    let label : UILabel = UILabel()
    // let input : UITextField = UITextField()
    
    let border : UIView = UIView()
    
    
    
    
    
    
    
    // Methods
    
    
    // Methods > Init
    
    required init?(coder aDecoder: NSCoder)
    {
        
        // Super
        super.init(coder: aDecoder)
        
        // Self
        self.font = UIFont(name: "Avenir-Light", size: 14.0)
        self.textColor = UIColor.blackColor()
        self.backgroundColor = UIColor.clearColor()
        self.layer.borderColor = UIColor.clearColor().CGColor
        
        // Label
        self.label.font = UIFont(name: "Avenir-Heavy", size: 13.0)
        self.label.textColor = UIColor(red: 164.0/255.0, green: 199.0/255.0, blue: 240.0/255.0, alpha: 1)
        self.addSubview(self.label)
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        let labelTop = NSLayoutConstraint(item: self.label, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        let labelLeft = NSLayoutConstraint(item: self.label, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
        let labelWidth = NSLayoutConstraint(item: self.label, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0)
        let labelHeight = NSLayoutConstraint(item: self.label, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        self.addConstraints([labelTop, labelLeft, labelWidth, labelHeight])
        
        // Border
        border.backgroundColor = UIColor(red: 183.0/255.0, green: 211.0/255.0, blue: 244.0/255.0, alpha: 1)
        self.addSubview(border)
        
        self.border.translatesAutoresizingMaskIntoConstraints = false
        let borderBottom = NSLayoutConstraint(item: self.border, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
        let borderLeft = NSLayoutConstraint(item: self.border, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
        let borderWidth = NSLayoutConstraint(item: self.border, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0)
        let borderHeight = NSLayoutConstraint(item: self.border, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 2)
        self.addConstraints([borderLeft, borderWidth, borderBottom, borderHeight])
        
    }
    
    
    
    
    
    
    
    // Override
    
    
    // Ovrride > Rects
    
    override func textRectForBounds(bounds: CGRect) -> CGRect
    {
        
        // Clear
        let boundsWithClear = super.textRectForBounds(bounds)
        let delta : CGFloat = 0.1
        
        // Return
        return CGRect(x: boundsWithClear.minX, y: boundsWithClear.height*delta, width: boundsWithClear.width, height: boundsWithClear.height*(1.0+delta))
        
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect
    {
        
        // Clear
        let boundsWithClear = super.editingRectForBounds(bounds)
        let delta : CGFloat = 0.1
        
        // Return
        return CGRect(x: boundsWithClear.minX, y: boundsWithClear.height*delta, width: boundsWithClear.width, height: boundsWithClear.height*(1.0+delta))
        
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect
    {
        
        // Clear
        let boundsWithClear = super.placeholderRectForBounds(bounds)
        let delta : CGFloat = 0.1
        
        // Return
        return CGRect(x: boundsWithClear.minX, y: boundsWithClear.height*delta, width: boundsWithClear.width, height: boundsWithClear.height*(1.0+delta))
        
    }
    
    

}
