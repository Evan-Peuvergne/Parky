//
//  MapControllerViewController.swift
//  ParkMe
//
//  Created by evan peuvergne on 10/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//

import UIKit
import Mapbox
import Alamofire


class MapController: UIViewController, MGLMapViewDelegate, MenuControllerDelegate, MapSearchControllerDelegate, MapSpotCardDelegate
{
    
    
    
    
    // Properties
    
    
    // Properties > Config
    
    // let mapUrl = "mapbox://styles/luciano93/cip7d5y4n001odmm24kdhtoww"
    // let mapUrl = "mapbox://styles/vavouweb/cii4lkabl004lbklucdsh16mb"
    let mapUrl = "mapbox://styles/luciano93/cip7d5y4n001odmm24kdhtoww"
    
    
    // Properties > Variables
    
    var spots : [Spot] = []
    
    var currentLat : Double?
    var currentLong : Double?
    
    var currentCard : Int? = 0
    var totalCards : Int? = 0
    
    
    // Properties > State
    
    var isFiltering = false
    
    
    // Properties > Outlets
    
    var map: MGLMapView!
    
    var menu: MenuController!
    var search: MapSearchController!
    
    var locationAnnotation : LocationMarker?
    var spotsAnnotations : [SpotMarker] = []
    
    var spotCards : [MapSpotCard?] = [nil, nil, nil]
    
    
    
    
    
    
    // Override
    
    
    // Override > Loaded

    override func viewDidLoad()
    {
        
        // Super
        super.viewDidLoad()
        
        // Variables
        let window = UIApplication.sharedApplication().keyWindow
        
        // Map
        let url = NSURL(string: mapUrl)
        self.map = MGLMapView(frame: self.view.bounds, styleURL: url)
        self.map.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.map.setCenterCoordinate(CLLocationCoordinate2D(latitude: 48.8534100, longitude: 2.3488000), zoomLevel: 16, animated: false)
        self.map.delegate = self
        self.view.addSubview(self.map)
        
        // Search
        self.search = self.storyboard?.instantiateViewControllerWithIdentifier("MapSearchController") as! MapSearchController
        self.search.delegate = self
        self.addChildViewController(self.search)
        
        self.search.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 110)
        self.view.addSubview(self.search.view)
        
        // Menu
        self.menu = self.storyboard?.instantiateViewControllerWithIdentifier("MenuController") as! MenuController
        self.menu.delegate = self
        
        self.menu.view.frame = CGRect(x: -self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.menu.menuOverlay.alpha = 0
        self.menu.menuContainerLeadingConstraint.constant = -self.view.bounds.width
        self.menu.menuContainerTrailingConstraint.constant = self.view.bounds.width
        self.menu.menuContainer.layoutIfNeeded()
        
        window?.addSubview(self.menu.view)
        self.addChildViewController(self.menu)
        self.menu.view.layoutIfNeeded()
        
    }
    
    
    // Override > Appear
    
    override func viewDidAppear(animated: Bool)
    {
        
        // Super
        NSLog("coucou")
        super.viewDidAppear(animated)
        
        
        
    }
    
    
    // Override > PrefersStatusBarHidden
    
    override func prefersStatusBarHidden() -> Bool
    {
        
        // if self.search == nil { return false }
        // else { return self.search.isFiltering }
        return false
    
    }
    
    
    
    
    
    // Events
    
    
    // Events > Menu
    
    @IBAction func onButtonMenuOpened(sender: AnyObject)
    {
        
        // Frame
        self.menu.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.menu.menuOverlay.alpha = 1
            self.menu.menuContainerLeadingConstraint.constant = 0
            self.menu.menuContainerTrailingConstraint.constant = 0
            self.menu.menuContainer.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func onButtonMenuClosed()
    {
        
        // Animation
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
            self.menu.menuOverlay.alpha = 0
            self.menu.menuContainerLeadingConstraint.constant = -self.view.bounds.width
            self.menu.menuContainerTrailingConstraint.constant = self.view.bounds.width
            self.menu.menuContainer.layoutIfNeeded()
        },completion:{ finished in
            self.menu.view.frame = CGRect(x: -self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        })
        
    }
    
    
    // Events > Menu item
    
    func onMenuSelected(bundle: String)
    {
    
        let dest : UIViewController = (self.storyboard?.instantiateViewControllerWithIdentifier(bundle))!
        self.presentViewController(dest, animated: true, completion: nil)
        
    }
    
    
    
    
    
    // Map
    
    
    // Map > Loaded
    
    func mapViewDidFinishLoadingMap(mapView: MGLMapView) { self.search.searchSpots() }
    
    
    // Map > Marker
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage?
    {
        
        // Location Marker
        if let point = annotation as? LocationMarker
        {
            let image : UIImage = point.image!
            let reuseIdentifier = point.reuseIdentifier
            if let annotationImage = self.map.dequeueReusableAnnotationImageWithIdentifier(reuseIdentifier!) { return annotationImage }
            else { return MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier!) }
        }
            
        // Spot Marker
        else
        {
            var image = UIImage(named: "spot")
            image = image?.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image!.size.height/2, 0))
            let annotationImage = MGLAnnotationImage(image: image!, reuseIdentifier: "pin")
            return annotationImage
            
        }
        
    }
    
    
    // Map > Select
    
    func mapView(mapView: MGLMapView, didSelectAnnotation annotation: MGLAnnotation)
    {
    
        // Spot
        if let spot : SpotMarker = annotation as? SpotMarker { self.showCard(spot.index) }
        
    }
    
    
    // Map > Camera
    
    func setCameraPositionForMarker(marker: MGLAnnotation)
    {
        
        // Coordinatates
        let lat = marker.coordinate.latitude
        let long = marker.coordinate.longitude
        
        // Distances
        let distLat = abs(self.currentLat! - lat)
        let distLong = abs(self.currentLong! - long)
        let dist = max(max(distLat, distLong)*1.3, 0.001)
        
        // Camera
        let sw = CLLocationCoordinate2D(latitude: self.currentLat! - dist, longitude: self.currentLong! - dist)
        let ne = CLLocationCoordinate2D(latitude: self.currentLat! + dist, longitude: self.currentLong! + dist)
        let bounds = MGLCoordinateBounds(sw: sw, ne: ne)
        self.map.setVisibleCoordinateBounds(bounds, animated: true)

        
    }
    
    
    
    
    
    // Search
    
    
    // Search > Started
    
    func onSearchDidStart(lat: Double, long: Double)
    {
        
        // Reinit
        if self.locationAnnotation != nil { self.map.removeAnnotation(self.locationAnnotation!) }
        self.map.removeAnnotations(self.spotsAnnotations)
        
        self.currentLat = lat
        self.currentLong = long
        
        // Center
        self.map.setCenterCoordinate(CLLocationCoordinate2DMake(lat, long), zoomLevel: 16, animated: true)
        
        // Point
        self.locationAnnotation = LocationMarker(coordinate: CLLocationCoordinate2DMake(lat, long))
        self.locationAnnotation!.reuseIdentifier = "locationMarker"
        self.map.addAnnotation(self.locationAnnotation!)
        
    }
    
    
    // Search > Success
    
    func onSearchDidSuccess(lat: Double, long: Double, spots: [Spot])
    {
        
        // Fail
        if spots.count <= 0 { return }
        
        // Markers
        self.spots = spots
        
        for spot in self.spots
        {
            self.spotsAnnotations.append(spot.marker)
            self.map.addAnnotation(spot.marker)
        }
        
        // Camera
        if self.spotsAnnotations.count > 0 { self.setCameraPositionForMarker(self.spotsAnnotations[0]) }
        
        // Cards
        self.currentCard = 0
        self.totalCards = self.spots.count
    
        self.showCard(self.currentCard!)
        
    }
    
    
    
    
    
    // Cards
    
    
    // Cards > Show
    
    func showCard (index: Int)
    {
        
        // Variables
        let bounds = UIScreen.mainScreen().bounds
        
        // Animation
        for i in [-1, 0, 1]
        {
            
            // Previous animation
            if self.spotCards[i+1] != nil
            {
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                    self.spotCards[i+1]?.frame.origin.y = bounds.height + 10
                }, completion: nil)
            }
            
            // Data
            if (index + i < 0) || (index + i > self.totalCards! - 1) { continue }
            let spot : Spot = self.spots[index + i]
            
            // Instanciate
            let vue : MapSpotCard = NSBundle.mainBundle().loadNibNamed("MapSpotCard", owner: self, options: nil)[0] as! MapSpotCard
            vue.instanciate(spot)
            vue.delegate = self
            vue.frame = CGRect(x: 30 + CGFloat(i)*(bounds.width-50), y: bounds.height + 10, width: bounds.width - 60, height: 123)
            self.view.insertSubview(vue, belowSubview: self.search.view)
            
            // New animation
            UIView.animateWithDuration(0.3, delay: 0.15, options: .CurveEaseIn, animations: { () -> Void in
                vue.frame.origin.y = bounds.height - 133
            }, completion: { (Bool) -> Void in
                self.spotCards[i+1] = vue
            })

        }
        
        // Properties
        self.currentCard = index
        
    }
    
    
    // Cards > Swipe
    
    func mapSpotCardDidSwipe(index: Int, direction: Int)
    {
 
        // Limits
        if (self.currentCard! - direction < 0) || (self.currentCard! - direction > self.totalCards! - 1) { return }
        
        // Variables
        let bounds = UIScreen.mainScreen().bounds
        
        // Animation
        for item in self.spotCards
        {
            // Animation
            if item == nil { continue }
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                item?.frame.origin.x += CGFloat(direction)*(bounds.width-50)
            }, completion: { (Bool) -> Void in
            
            })
        }
        
        // Positions
        var cpt = 0
        for item in self.spotCards
        {
            
            // Manip
            var i = cpt+direction
            if i >= 0 && i <= 2 { self.spotCards[i] = item }
            else { item?.removeFromSuperview() }
            
            // Cpt
            cpt += 1
        }
        
        // New
        let newIndex = self.currentCard! - direction*2
        if(newIndex >= 0) && (newIndex <= self.totalCards! - 1)
        {
            print("cacacaacacaca")
            // Data
            let spot = self.spots[newIndex]

            // View
            let vue : MapSpotCard = NSBundle.mainBundle().loadNibNamed("MapSpotCard", owner: self, options: nil)[0] as! MapSpotCard
            vue.instanciate(spot)
            vue.delegate = self
            // vue.frame = CGRect(x: 30 + CGFloat(newIndex)*(bounds.width-50), y: bounds.height + 10, width: bounds.width - 60, height: 123)
            vue.frame = CGRect(x: 30 + CGFloat(-direction*2)*(bounds.width-50), y: bounds.height - 133, width: bounds.width - 60, height: 123)
            self.view.insertSubview(vue, belowSubview: self.search.view)

            // Animation
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                vue.frame.origin.x = 30 + CGFloat(-direction)*(bounds.width-50)
            }, completion: { (Bool) -> Void in
                if direction == -1 { self.spotCards[2] = vue } else { self.spotCards[0] = vue }
            })
        }
        
        // Properties
        self.currentCard! -= direction
        
        // Map
        self.setCameraPositionForMarker(self.spots[self.currentCard!].marker)
        
    }
    
    
    // Cards > Booked
    
    func mapSpotCardDidBook(index: Int)
    {
    
        // let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MenuController") as! ViewController
        
        
        
    }
    
    

    

}
