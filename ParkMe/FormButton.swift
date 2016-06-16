//
//  FormButton.swift
//  ParkMe
//
//  Created by evan peuvergne on 15/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//

import UIKit




// Class

class FormButton: UIButton
{

    
    
    
    
    // Methods
    
    
    // Methods > Init
    
    required init(coder aDecoder: NSCoder)
    {
        
        // Super
        super.init(coder: aDecoder)!
        
        // Graphics
        self.layer.cornerRadius = 8.0
        
    }
    
    

}
