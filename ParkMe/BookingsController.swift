//
//  BookingsController.swift
//  ParkMe
//
//  Created by evan peuvergne on 16/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//








// Imports

import UIKit
import Alamofire







// Class

class BookingsController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    
    
    
    
    
    
    
    // Properties
    
    
    // Variables
    
    var status : Int = 0
    
    var validated : [NSDictionary] = []
    var waiting : [NSDictionary] = []
    
    
    // Properties > Outlets
    
    @IBOutlet weak var bookingsList: UITableView!
    
    let border : UIView = UIView()
    
    @IBOutlet weak var buttonValidates: UIButton!
    @IBOutlet weak var buttonWaiting: UIButton!
    
    
    
    
    
    
    
    
    // Override
    
    
    // Override > Load
    
    override func viewDidLoad()
    {
        
        // Init
        self.border.frame = CGRect(x: 0, y: CGFloat(73) + self.navigationController!.navigationBar.frame.height, width: self.view.bounds.width/2, height: 4)
        self.border.backgroundColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1)
        self.view.addSubview(self.border)
        
        
        super.viewDidLoad()
        
        // List
        self.bookingsList.dataSource = self
        self.bookingsList.delegate = self
        
        self.bookingsList.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        
        self.bookingsList.separatorStyle = .None
        self.bookingsList.clipsToBounds = false
        
        // Data
        let prefs = NSUserDefaults.standardUserDefaults()
        let id = (prefs.objectForKey("user") as! NSDictionary).objectForKey("id") as! Int
        print(id)
        
        Alamofire.request(.GET, "http://37.139.18.66/reservation", parameters: ["userId": id, "status": 0]).responseJSON { response in switch response.result
        {
            case .Success(let json):
                
                let datas : NSArray = json as! NSArray
                for data in datas
                {
                    let booking : NSDictionary = data as! NSDictionary
                    self.validated.append(booking)
                    if self.status == 0 { self.bookingsList.reloadData() }
                    print(self.validated.count)
                }
                break;
            
            default:
                break;
        }}
        
        Alamofire.request(.GET, "http://37.139.18.66/reservation", parameters: ["userId": id, "status": 1]).responseJSON { response in switch response.result
        {
            case .Success(let json):
            
                let datas : NSArray = json as! NSArray
                for data in datas
                {
                    let booking : NSDictionary = data as! NSDictionary
                    self.waiting.append(booking)
                    if self.status == 1 { self.bookingsList.reloadData() }
                }
                break;
            
            default:
                break;
        }}
        
    }
    
    
    
    
    
    
    // List
    
    
    // List > Size
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return 137 }
    
    
    // List > Count
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { if self.status == 0 { return self.validated.count } else { return self.waiting.count } }
    
    
    // List > Cell
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
     
        // Instanciate
        let cell = NSBundle.mainBundle().loadNibNamed("BookingsCell", owner: nil, options: nil)[0] as! BookingsCell
        
        // Data
        if self.status == 0 { cell.fill(self.validated[indexPath.row]) }
        else { cell.fill(self.waiting[indexPath.row]) }
        
        // Return
        return cell
        
    }
    
    
    
    
    
    
    
    
    // Events
    
    
    // Events > Tab
    
    @IBAction func tabDidTouched(sender: AnyObject)
    {
        
        // Avoid
        if self.status == sender.tag as Int { return }
        
        // Status
        self.status = sender.tag as Int
        
        // Border
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
            self.border.frame.origin.x = CGFloat(self.status)*self.view.frame.width/CGFloat(2)
        }, completion: nil)
        
        // Alpha
        if self.status == 0 { self.buttonValidates.alpha = 1; self.buttonWaiting.alpha = 0.65 }
        else { self.buttonWaiting.alpha = 1; self.buttonValidates.alpha = 0.65 }
        
        // Reload
        self.bookingsList.reloadData()
        
    }
    
    
    // Events > Close
    
    @IBAction func buttonCloseDidTouche(sender: AnyObject) { self.dismissViewControllerAnimated(true, completion: nil) }
    
    
    
    
    
    

    

}
