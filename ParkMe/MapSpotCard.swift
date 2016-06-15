//
//  MapSpotCard.swift
//  ParkMe
//
//  Created by evan peuvergne on 14/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//






// Imports

import UIKit





// Class

class MapSpotCard: UIView, UIGestureRecognizerDelegate
{

    
    
    
    // Properties
    
    
    // Properties > Variables
    
    var spot : Spot?
    
    
    // Delegate
    
    var delegate : MapSpotCardDelegate!
    
    
    // Properties > Outlets
    
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelGrade: UILabel!
    
    @IBOutlet weak var buttonnBookingContainer: UIView!
    @IBOutlet weak var buttonBooking: UIButton!
    
    
    
    
    // Methods
    
    
    // Methods > Init
    
    required init(coder aDecoder: NSCoder)
    {
        
        self.spot = nil
        super.init(coder: aDecoder)!
        
    }
    
    func instanciate (spot : Spot)
    {
        
        // Variables
        self.spot = spot
        
        // Content
        if self.spot!.distance > 1000 { self.labelDistance.text = String(format: "%i", self.spot!.distance/1000) + "km" }
        else { self.labelDistance.text = String(format: "%i", self.spot!.distance) + "m" }
        
        if self.spot!.price > 1000 { self.labelPrice.text = String(format: "%i", self.spot!.price/1000) + "k€" }
        else { self.labelPrice.text = String(format: "%i", self.spot!.price) + "€" }
        
        self.labelGrade.text = String(format: "%i", self.spot!.grade) + "/5"
        
        // Radius
        self.layer.cornerRadius = 8.0
        
        self.buttonnBookingContainer.layer.cornerRadius = 8.0
        self.buttonnBookingContainer.clipsToBounds = true
        
        // Shadow
        self.layer.shadowColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1).CGColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSizeZero
        self.layer.shadowRadius = 8.0
        
        // Gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.spotSwipeGestureLeft(_:)))
        swipeLeft.delegate = self
        swipeLeft.direction = .Left
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.spotSwipeGestureRight(_:)))
        swipeRight.delegate = self
        swipeRight.direction = .Right
        
        self.addGestureRecognizer(swipeLeft)
        self.addGestureRecognizer(swipeRight)
        
    }
    
    
    
    
    
    // Events
    
    
    // Events > Swipe
    
    func spotSwipeGestureLeft(sender: UISwipeGestureRecognizer) { self.delegate.mapSpotCardDidSwipe(self.spot!.index, direction: -1) }
    
    func spotSwipeGestureRight(sender: UISwipeGestureRecognizer) { self.delegate.mapSpotCardDidSwipe(self.spot!.index, direction: 1) }
    
    
    // Events > Book
    
    @IBAction func spotBookingButtonTouched(sender: AnyObject){ self.delegate.mapSpotCardDidBook(self.spot!.index) }
    
    
    
    
    
    // Delegate
    
    
    // Delegate > Touch
    
    

}





// Delegate

protocol MapSpotCardDelegate
{
    
    func mapSpotCardDidSwipe(index: Int, direction: Int)
    func mapSpotCardDidBook(index: Int)
    
}
