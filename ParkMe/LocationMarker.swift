//
//  LocationMarker.swift
//  ParkMe
//
//  Created by evan peuvergne on 14/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//

import UIKit
import Mapbox


// Class

class LocationMarker: NSObject, MGLAnnotation
{

    
    
    
    // Properties
    
    
    // Properties > Variables
    
    var coordinate: CLLocationCoordinate2D
    
    var image : UIImage?
    var reuseIdentifier : String?
    
    
    
    
    
    
    // Methods
    
    
    // Methods > Init
    
    init(coordinate: CLLocationCoordinate2D)
    {
        
        // Properties
        self.coordinate = coordinate
        
        // Image
        self.image = generateImage(20)
        
    }
    

    
    
    
}





// Utils


// Utils > Generate Image

func generateImage(size: CGFloat) -> (UIImage)
{
    
    let rect = CGRectMake(0, 0, size, size)
    let strokeWidth: CGFloat = 1
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
    
    let ovalPath = UIBezierPath(ovalInRect: CGRectInset(rect, strokeWidth, strokeWidth))
    UIColor(red: 255.0/255.0, green: 84.0/255.0, blue: 107.0/255.0, alpha: 1).setFill()
    ovalPath.fill()
    
    UIColor.whiteColor().setStroke()
    ovalPath.lineWidth = strokeWidth
    ovalPath.stroke()
    
    let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
    
}
