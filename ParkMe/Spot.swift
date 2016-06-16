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
    
    var distance : Int
    var price : Int
    var grade : Int
    
    
    // Map
    
    var marker : SpotMarker!
    
    
    
    
    // Init
    
    
    // Init
    
    init(data: NSDictionary, index: Int)
    {
        
        // Super
        self.data = data
        self.index = index
        
        self.lat = data.objectForKey("lat") as! Double
        self.long = data.objectForKey("lon") as! Double
        print(self.lat)
        
        self.distance = data.objectForKey("distance") as! Int
        self.price = data.objectForKey("price") as! Int
        self.grade = data.objectForKey("rate") as! Int
        
        self.marker = SpotMarker(coordinate: CLLocationCoordinate2D(latitude: self.lat, longitude: self.long), index: index)
        
        super.init()
        
    }

}
