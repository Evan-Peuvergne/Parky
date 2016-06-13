//
//  MapSearchController.swift
//  ParkMe
//
//  Created by evan peuvergne on 11/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//

import UIKit
import Alamofire



// Class

class MapSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    
    
    // Properties
    
    
    // Delegate
    
    var delegate : MapSearchControllerDelegate!
    
    
    // Properties > Variables
    
    var search : String = "Paris"
    var place : String = "Paris"
    var lat : Double = 48.8534100
    var long : Double = 2.3488000
    
    var beginning : NSDate!
    var end : NSDate!
    
    var suggestions : [NSDictionary] = []
    
    var spots : [Spot] = []
    
    
    // Properties > State
    
    var isFiltering = false
    var isEditingDate = false
    
    var currentFilter : String?
    var previousFilter : String?
    
    
    // Properties > Utils
    
    var requestSuggestion : Alamofire.Request?
    var requestSpots : Alamofire.Request?
    
    var keyboardHeight : CGFloat = 250
    
    
    // Properties > Outlets
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var formViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var adressInput: UITextField!
    
    @IBOutlet weak var dateArrivalLabel: UIButton!
    @IBOutlet weak var dateDepartureLabel: UIButton!
    
    @IBOutlet weak var formStatusContainer: UIView!
    @IBOutlet weak var formStatusContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var formStatusLabel: UILabel!

    
    let autoCompleteView : UITableView = UITableView()
    let datePicker : UIDatePicker = UIDatePicker()
    
    
    // Properties > Config
    
    let apiKey = "pk.eyJ1IjoidmF2b3V3ZWIiLCJhIjoiY2lnenNkeWNxMDBnMXJsbHl3dWhrYTV1MSJ9.tcfJHSc8GwFdTGzf5LX5IA"
    
    
    
    
    
    // Init
    
    
    // Init > Loaded
    
    override func viewDidLoad()
    {
        
        // Super
        self.beginning = NSDate()
        self.end = self.beginning.dateByAddingTimeInterval(60*60*24)
        
        self.requestSuggestion = nil
        self.requestSpots = nil
        
        super.viewDidLoad()
        
        // Form
        self.formView.layer.cornerRadius = 10.0
        self.formView.layer.shadowColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1).CGColor
        self.formView.layer.shadowOpacity = 0.3
        self.formView.layer.shadowOffset = CGSizeZero
        self.formView.layer.shadowRadius = 8.0
        
        self.adressInput.layer.cornerRadius = 8.0
        self.adressInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8.0, height: self.adressInput.bounds.height))
        self.adressInput.leftViewMode = .Always
        
        // Status
        // self.formStatusContainer.hidden = true
        self.formStatusContainer.layer.cornerRadius = 8.0
        self.formStatusContainer.layer.shadowColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1).CGColor
        self.formStatusContainer.layer.shadowOpacity = 0.3
        self.formStatusContainer.layer.shadowOffset = CGSizeZero
        self.formStatusContainer.layer.shadowRadius = 8.0
        self.formStatusContainer.layoutIfNeeded()
        
        // Button
        self.searchButton.layer.cornerRadius = self.searchButton.bounds.width/2
        
        self.searchButton.layer.shadowColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1).CGColor
        self.searchButton.layer.shadowOpacity = 0.3
        self.searchButton.layer.shadowOffset = CGSizeZero
        self.searchButton.layer.shadowRadius = 8.0
        
        // Date
        let bounds = UIScreen.mainScreen().bounds
        
        self.datePicker.frame = CGRect(x: 0, y: 00, width: bounds.width, height: bounds.height*1.2)
        self.datePicker.backgroundColor = UIColor.clearColor()
        self.datePicker.datePickerMode = .Date
        self.datePicker.hidden = true
        self.view.addSubview(self.datePicker)
        self.view.sendSubviewToBack(self.datePicker)
        
        self.datePicker.addTarget(self, action: #selector(MapSearchController.dateDidChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.updateDateLabel(self.dateArrivalLabel, date: self.beginning)
        self.updateDateLabel(self.dateDepartureLabel, date: self.end)
        
        // Adress
        self.autoCompleteView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height-220)
        self.autoCompleteView.contentInset = UIEdgeInsetsMake(170, 0, 0, 0)
        self.autoCompleteView.separatorColor = UIColor.clearColor()
        self.autoCompleteView.backgroundColor = UIColor.clearColor()
        self.autoCompleteView.hidden = true
        
        self.autoCompleteView.delegate = self
        self.autoCompleteView.dataSource = self
        
        self.view.addSubview(self.autoCompleteView)
        self.view.sendSubviewToBack(self.autoCompleteView)
        
        
    }
    
    
    
    
    
    // Methods
    
    
    // Methods > Layout
    
    func setFilderingMode ()
    {
        
        // Animation
        let nav = self.navigationController?.navigationBar
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
            self.view.backgroundColor = UIColor.whiteColor()
            self.view.frame.origin.y = 0
            self.view.frame.size.height = UIScreen.mainScreen().bounds.height
            self.formViewTopConstraint.constant = self.navigationController!.navigationBar.frame.height + 30
            self.formView.layoutIfNeeded()
            self.searchButtonTopConstraint.constant = 30
            self.searchButton.layoutIfNeeded()
            self.formStatusContainerTopConstraint.constant = 70 + nav!.frame.height
            self.formStatusContainer.layoutIfNeeded()
            nav!.frame.origin.y = -nav!.frame.height
        }, completion: nil)
        
    }
    
    func leaveFilteringMode ()
    {
        
        // Contents
        if self.isEditingDate { self.hideDatesDetails(0) }
        else { self.hideAdressDetails(0) }
        
        // Animation
        let nav = self.navigationController?.navigationBar
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
            self.view.backgroundColor = UIColor.clearColor()
            self.view.frame.origin.y = nav!.frame.height + 20
            self.formViewTopConstraint.constant = 10
            self.formView.layoutIfNeeded()
            self.searchButtonTopConstraint.constant = 20
            self.searchButton.layoutIfNeeded()
            self.formStatusContainerTopConstraint.constant = 50
            self.formStatusContainer.layoutIfNeeded()
            nav!.frame.origin.y = 20
        }, completion: { (Bool) -> Void in
            
            // Properties
            self.view.frame.size.height = 110
            
            // State
            self.isFiltering = false
            self.isEditingDate = false
            
            self.previousFilter = self.currentFilter
            self.currentFilter = nil
        })
        
    }
    
    
    // Methods > Adress
    
    func showAdressDetails (delay : Double)
    {
        
        // Start
        self.autoCompleteView.alpha = 0
        self.autoCompleteView.hidden = false
        
        // Animation
        UIView.animateWithDuration(0.2, delay: delay, options: .CurveEaseIn, animations: { () -> Void in
            self.autoCompleteView.alpha = 1
        }, completion: nil)
        
    }
    
    func hideAdressDetails (delay : Double)
    {
        
        // Start
        self.autoCompleteView.alpha = 1
        self.autoCompleteView.hidden = false
        
        // Focus
        self.adressInput.resignFirstResponder()
        
        // Suggestion
        self.suggestions = []
        self.autoCompleteView.reloadData()
        
        // Animation
        UIView.animateWithDuration(0.2, delay: delay, options: .CurveEaseIn, animations: { () -> Void in
            self.autoCompleteView.alpha = 0
        }, completion: { (Bool) -> Void in self.autoCompleteView.hidden = true })
        
    }
    
    
    // Methods > Dates
    
    func showDatesDetails (delay : Double)
    {
        
        // Start
        self.datePicker.alpha = 0
        self.datePicker.hidden = false
        
        // Animation
        UIView.animateWithDuration(0.2, delay: delay, options: .CurveEaseIn, animations: { () -> Void in
            self.datePicker.alpha = 1
        }, completion: nil)
        
    }
    
    func hideDatesDetails (delay : Double)
    {
        
        // Start
        self.datePicker.alpha = 1
        self.datePicker.hidden = false
        
        // Animation
        UIView.animateWithDuration(0.2, delay: delay, options: .CurveEaseIn, animations: { () -> Void in
                self.datePicker.alpha = 0
        }, completion: { (Bool) -> Void in self.datePicker.hidden = true })
        
    }
    
    func updateDateLabel (label : UIButton, date : NSDate)
    {
        
        // Datas
        let calendar = NSCalendar.currentCalendar()
        
        var day = String(calendar.component(.Day, fromDate: date))
        if day.characters.count < 2 { day = "0" + day }
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let month : String = months[calendar.component(.Month, fromDate: date)-1]
        
        let year = String(calendar.component(.Year, fromDate: date))
        
        // Label
        let string : String = day + " " + String(month) + ". " + String(year)
        label.setTitle(string, forState: .Normal)
        
    }
    
    
    // Methods > Search
    
    func searchSpots ()
    {
        
        // Reinit
        if self.requestSpots != nil { self.requestSpots!.cancel() }
        self.spots = []
        
        if self.delegate.onSearchDidStart != nil { self.delegate.onSearchDidStart!(self.lat, long: self.long) }
        
        // Status
        self.formStatusLabel.text = "Searching ..."
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
            self.formStatusContainerTopConstraint.constant = 85
            self.formStatusContainer.layoutIfNeeded()
        }, completion: nil)
        
        // Dates
        let calendar = NSCalendar.currentCalendar()
        
        // Request
        let url = "http://37.139.18.66/search"
        var parameters : [String : AnyObject] = [:]
        parameters["lat"] = self.lat
        parameters["lon"] = self.long
        parameters["arrivalYear"] = calendar.component(.Year, fromDate: self.beginning)
        parameters["arrivalMonth"] = calendar.component(.Month, fromDate: self.beginning)
        parameters["arrivalDay"] = calendar.component(.Day, fromDate: self.beginning)
        parameters["departureYear"] = calendar.component(.Year, fromDate: self.end)
        parameters["departureMonth"] = calendar.component(.Month, fromDate: self.end)
        parameters["departureDay"] = calendar.component(.Day, fromDate: self.end)
        
        self.requestSpots = Alamofire.request(.GET, url, parameters: parameters).responseJSON { response in switch response.result
        {
            case .Success(let json):
                
                // Browse
                let datas = json as! NSArray
                for(index, data) in datas.enumerate()
                {
                    let spot = Spot(data: data as! NSDictionary, index: index)
                    self.spots.append(spot)
                }
                
                // Status
                self.formStatusLabel.text = String(self.spots.count) + " results founded !"
                UIView.animateWithDuration(0.2, delay: 3, options: .CurveEaseIn, animations: { () -> Void in
                    self.formStatusContainerTopConstraint.constant = 50
                    self.formStatusContainer.layoutIfNeeded()
                }, completion: nil)
                
                // Delegate
                if self.delegate.onSearchDidSuccess != nil { self.delegate.onSearchDidSuccess!(self.lat, long: self.long, spots: self.spots) }
            
                break;
            
            default:
                break;
        }}
        
        
    }

    
    
    
    
    // Events
    
    
    // Events > Adress
    
    @IBAction func adressDidFocus(sender: AnyObject)
    {

        // Filter Mode
        self.setFilderingMode()
        
        self.previousFilter = self.currentFilter
        self.currentFilter = "adress"
        
        // Date
        if self.isFiltering && self.isEditingDate { self.hideDatesDetails(0) }
        
        // Adress
        if !self.isFiltering || self.isEditingDate { self.showAdressDetails(0.2) }
        
        // State
        self.isFiltering = true
        self.isEditingDate = false
        
    }
    
    @IBAction func adressDidChanged(sender: AnyObject){ self.suggestionsUpdate() }
    
    
    
    // Events > Date
    
    @IBAction func dateDidTouched(sender: AnyObject)
    {
        
        // Filter Mode
        self.setFilderingMode()
        
        self.previousFilter = self.currentFilter
        if sender.tag == 0 { self.currentFilter = "arrivalDate" }
        else{ self.currentFilter = "departureDate" }
        
        // Adress
        if self.isFiltering && !self.isEditingDate { self.hideAdressDetails(0) }
        
        // Date
        if !self.isEditingDate { self.showDatesDetails(0.2) }
        
        var date = self.beginning
        if self.currentFilter == "departureDate" { date = self.end }
        if self.isFiltering && self.isEditingDate { self.datePicker.setDate(date, animated: true) }
        else { self.datePicker.setDate(date, animated: false) }
        
        // State
        self.isFiltering = true
        self.isEditingDate = true
        
        
    }
    
    func dateDidChanged (sender : UIDatePicker)
    {
        
        // Button
        let label : UIButton
        if self.currentFilter == "arrivalDate" { label = self.dateArrivalLabel }
        else { label = self.dateDepartureLabel }
        
        // Update
        self.updateDateLabel(label, date: sender.date)
        
        // Properties
        if self.currentFilter == "arrivalDate" { self.beginning = sender.date }
        else { self.end = sender.date }
        
    }
    
    
    // Events > Search
    
    @IBAction func searchButtonDidTouched(sender: AnyObject)
    {
        
        // Filtering Mode
        self.leaveFilteringMode()
        
        // Search
        self.searchSpots()
        
    }
    
    
    
    
    // Suggestion
    
    
    // Suggestion > Update
    
    func suggestionsUpdate ()
    {
        
        // Cancel
        if self.requestSuggestion != nil { self.requestSuggestion!.cancel() }
        self.suggestions = []
        
        if self.adressInput.text == "" { return }
        
        // Formating
        var url = "http://api.tiles.mapbox.com/geocoding/v5/mapbox.places/"
        url += self.adressInput.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        url += ".json"
    
        // Request
        self.requestSuggestion = Alamofire.request(.GET, url, parameters: ["access_token": apiKey]).responseJSON { response in switch response.result
        {
            case .Success(let json):
                
                // Browse
                let datas = (json as! NSDictionary).objectForKey("features") as! NSArray
                for data in datas
                {
                    let object = data as! NSDictionary
                    self.suggestions.append(object)
                }
                
                // Reload
                self.autoCompleteView.reloadData()
                
                break;
            
            default:
                break;
        }}
        
    }
    
    
    // Suggestion > Number
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        // Return
        return self.suggestions.count
    
    }
    
    
    // Suggestion > Cell
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        // Data
        let data : NSDictionary = self.suggestions[indexPath.row]
        
        // Object
        let cell = UITableViewCell()
        
        // Content
        var label : String = data.objectForKey("text") as! String
        label = "  " + String(label)
        cell.textLabel?.text = label
        
        // Design
        cell.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        cell.textLabel?.textColor = UIColor(red: 109.0/255.0, green: 110.0/255.0, blue: 111.0/255.0, alpha: 1)
        
        // Return
        return cell
        
    }
    
    
    // Suggestion > Selection
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        // Data
        let data : NSDictionary = self.suggestions[indexPath.row]
        
        self.place = data.objectForKey("text") as! String
        self.lat = (data.objectForKey("center") as! NSArray).objectAtIndex(1) as! Double
        self.long = (data.objectForKey("center") as! NSArray).objectAtIndex(0) as! Double
        
        // Update
        self.adressInput.text = self.place
        
    }
    
    

    
}




// Delegate

@objc protocol MapSearchControllerDelegate
{
    
    optional func onSearchDidStart(lat: Double, long: Double)
    optional func onSearchDidSuccess(lat: Double, long: Double, spots: [Spot])

}

