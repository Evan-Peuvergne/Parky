//
//  SpotMarker.swift
//  ParkMe
//
//  Created by evan peuvergne on 14/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//

import UIKit
import Mapbox


// Class

class SpotMarker: NSObject, MGLAnnotation
{

    
    
    
    // Properties
    
    
    // Properties > Variables
    
    var coordinate: CLLocationCoordinate2D
    
    var index : Int
    
    
    
    
    
    
    // Methods
    
    
    // Methods > Init
    
    init(coordinate: CLLocationCoordinate2D, index: Int)
    {
        
        // Instanciate
        self.coordinate = coordinate
        self.index = index
        
        super.init()
        
    }
    

    
    
    
}
