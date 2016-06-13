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


class MapController: UIViewController, MGLMapViewDelegate, MenuControllerDelegate, MapSearchControllerDelegate
{
    
    
    
    
    // Properties
    
    
    // Properties > Config
    
    // let mapUrl = "mapbox://styles/luciano93/cip7d5y4n001odmm24kdhtoww"
    // let mapUrl = "mapbox://styles/vavouweb/cii4lkabl004lbklucdsh16mb"
    let mapUrl = "mapbox://styles/luciano93/cip7d5y4n001odmm24kdhtoww"
    
    
    // Properties > Variables
    
    var spots : [Spot] = []
    
    
    // Properties > State
    
    var isFiltering = false
    
    
    // Properties > Outlets
    
    var map: MGLMapView!
    
    var menu: MenuController!
    var search: MapSearchController!
    
    
    
    
    
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
        
        self.search.view.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! + 20, width: self.view.bounds.width, height: 110)
        // self.view.addSubview(self.search.view)
        window?.addSubview(self.search.view)
        self.addChildViewController(self.search)
        
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
    
    
    // Map > Custom Marker
    
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
        
        // Load
        else
        {
            var image = UIImage(named: "pin")
            image = image?.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image!.size.height/2, 0))
            let annotationImage = MGLAnnotationImage(image: image!, reuseIdentifier: "pin")
            return annotationImage
            
        }
        
    }
    
    
    
    
    
    // Search
    
    
    // Search > Started
    
    func onSearchDidStart(lat: Double, long: Double)
    {
        
        // Center
        self.map.setCenterCoordinate(CLLocationCoordinate2DMake(lat, long), zoomLevel: 16, animated: true)
        
        // Point
        let point = LocationMarker(coordinate: CLLocationCoordinate2DMake(lat, long))
        point.reuseIdentifier = "locationMarker"
        self.map.addAnnotation(point)
        
    }
    
    
//    func onSearchDidChange(lat: Double, long: Double, beginning: NSDate, end: NSDate)
//    {
//        
//        // Variables
//        // ...
//        
//        // Data
//        let url = "http://37.139.18.66/search?lat=48.851867&lon=2.419921&arrivalYear=2016&arrivalMonth=6&arrivalDay=7&departureYear=2016&departureMonth=6&departureDay=10"
//        Alamofire.request(.GET, url).responseJSON{ response in switch
//            response.result {
//                case .Success(let json):
//                    
//                    // Datas
//                    let datas = json as! NSArray
//                    for (index, data) in datas.enumerate()
//                    {
//                        let spot = Spot(data: data as! NSDictionary, index: index)
//                        self.map.addAnnotation(spot.marker)
//                        self.spots.append(spot)
//                    }
//            
//                    // Camera
//                    let first : Spot = self.spots[0]
//                    let distLat = abs(lat-first.lat)
//                    let distLong = abs(long-first.long)
//                    var dist = max(distLat, distLong)*1.5
//                    dist = max(dist, 0.01)
//            
//                    let sw = CLLocationCoordinate2D(latitude: lat-dist, longitude: long-dist)
//                    let ne = CLLocationCoordinate2D(latitude: lat+dist, longitude: long+dist)
//                    let bounds = MGLCoordinateBounds(sw: sw, ne: ne)
//                    self.map.setVisibleCoordinateBounds(bounds, animated: true)
//            
//                default:
//                    break;
//            }
//        }
//        
//    }

    

}
