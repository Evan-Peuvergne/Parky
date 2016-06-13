//
//  Spot.swift
//  ParkMe
//
//  Created by evan peuvergne on 12/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//

import UIKit
import Mapbox



// Class

class Spot: NSObject
{
    
    
    
    
    // Properties
    
    
    // Properties > Variables
    
    var data : NSDictionary?
    var index: Int!
    
    var lat : Double
    var long : Double
    
    var price : Double?
    var distance : Double?
    
    
    // Map
    
    var marker : MGLPointAnnotation!
    
    
    
    
    // Init
    
    
    // Init
    
    init(data: NSDictionary, index: Int)
    {
        
        // Super
        self.data = data
        self.index = index
        NSLog("%d", index)
        
        self.lat = data.objectForKey("lat") as! Double
        self.long = data.objectForKey("lon") as! Double
        
        self.marker = MGLPointAnnotation()
        self.marker.coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
        
        super.init()
        
    }

}
