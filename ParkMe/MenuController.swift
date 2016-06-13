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
    
    
    // Properties > Delegate
    
    var delegate : MenuControllerDelegate?
    
    
    // Properties > Outlets
    
    @IBOutlet weak var menuOverlay: UIView!
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var menuContainerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuContainerTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuItemMap: MenuItemButton!
    @IBOutlet weak var menuItemBooking: MenuItemButton!
    @IBOutlet weak var menuItemPayment: MenuItemButton!
    @IBOutlet weak var menuItemSettings: MenuItemButton!
    
    
    
    
    // Methods
    
    
    // Methods > View

    override func viewDidLoad()
    {
        
        // Super
        super.viewDidLoad()
        
        // Notifs
        self.menuItemMap.updateLabel(5)
        self.menuItemBooking.updateLabel(1)

    }

    override func didReceiveMemoryWarning()
    {
        
        // Super
        super.didReceiveMemoryWarning()
        
        // ...
        // ...
        
    }
    
    
    // Events
    
    
    // Events > Profile
    
    @IBAction func profileSelected(sender: UIButton)
    {
        
        self.delegate?.onButtonMenuClosed()
        self.delegate?.onMenuSelected("BookedBundle")
    
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
