//
//  MenuControllerViewController.swift
//  ParkMe
//
//  Created by evan peuvergne on 08/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//

import UIKit





// Class

class MenuController: UIViewController
{

    
    
    
    
    
    // Properties
    
    
    // Properties > Variables
    
    var userData : NSDictionary!
    var userId : Int!
    var userName : String!
    var userEmail : String!
    var userBookings : Int!
    
    
    // Properties > Delegate
    
    var delegate : MenuControllerDelegate?
    
    
    // Properties > Outlets
    
    @IBOutlet weak var menuOverlay: UIView!
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var menuContainerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuContainerTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userReservationsLabel: UILabel!
    
    @IBOutlet weak var menuItemBookings: MenuItemButton!
    @IBOutlet weak var menuItemHistorical: MenuItemButton!
    @IBOutlet weak var menuItemPayment: MenuItemButton!
    @IBOutlet weak var menuItemSettings: MenuItemButton!
    
    

    
    
    
    
    // Methods
    
    
    // Methods > View

    override func viewDidLoad()
    {
        
        // Init
        let defaults = NSUserDefaults.standardUserDefaults()
        self.userData = defaults.objectForKey("user") as! NSDictionary
        
        self.userId = self.userData.objectForKey("id") as! Int
        self.userName = self.userData.objectForKey("name") as! String
        self.userEmail = self.userData.objectForKey("mail") as! String
        self.userBookings = (self.userData.objectForKey("reservations") as! NSArray).count
        
        // Super
        super.viewDidLoad()
        
        // UI
        self.userNameLabel.text = self.userName
        self.userReservationsLabel.text = String(format: "%i", self.userBookings) + " bookings"
        
        // self.menu.updateLabel(5)
        // self.menuItemBooking.updateLabel(1)

    }
    
    
    
    
    
    
    
    // Events
    
    
    // Events > Profile
    
    @IBAction func profileSelected(sender: UIButton)
    {
        
        self.delegate?.onButtonMenuClosed()
        // self.delegate?.onMenuSelected("BookingsNavigationController")
    
    }
    
    
    // Events > Booking
    
    @IBAction func bookingsButtonDidTouched(sender: AnyObject)
    {
        
        self.delegate?.onButtonMenuClosed()
        self.delegate?.onMenuSelected("BookingsNavigationController")
        
    }
    
    
    // Events > Logout
    
    @IBAction func buttonLogoutDidTouched(sender: AnyObject)
    {
        
        // Defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("user")
        
        // Redirect
        let auth : UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AuthNavigationController") as! UINavigationController
        self.delegate?.onButtonMenuClosed()
        self.presentViewController(auth, animated: true, completion: nil)
        
    }
    
    
    
    // Events > Close
    
    @IBAction func overlaySelected(sender: AnyObject){ self.delegate?.onButtonMenuClosed() }
    
    
    

}




// Delegate

protocol MenuControllerDelegate
{
    
    func onButtonMenuClosed()
    func onMenuSelected(bundle: String)
    
}
