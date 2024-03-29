//
//  LoginController.swift
//  ParkMe
//
//  Created by evan peuvergne on 16/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//






// Imports

import UIKit
import Alamofire






// Class

class LoginController: UIViewController
{
    
    
    
    
    
    
    
    // Properties
    
    
    // Properties > Outlets
    
    
    @IBOutlet weak var inputEmail: FormInput!
    @IBOutlet weak var inputPassword: FormInput!
    
    
    
    
    
    
    
    
    // Override
    
    
    // Override > View

    override func viewDidLoad()
    {
        
        // Super
        super.viewDidLoad()
        
        // Center
        let center = NSNotificationCenter.defaultCenter()
        // center.addObserver(self, selector: "keyboardOnscreen:", name: UIKeyboardDidShowNotification, object: nil)
        // center.addObserver(self, selector: "keyboardOffScreen:", name: UIKeyboardDidHideNotification, object: nil)

    }
    
    
    
    
    
    
    
    // Events
    
    
    // Events > Login
    
    @IBAction func loginButtonDidTouched(sender: AnyObject)
    {
        
        // Request
        let url = "http://37.139.18.66/users"
        Alamofire.request(.GET, url, parameters: ["mail": self.inputEmail.text!, "password" : self.inputPassword.text!]).responseJSON { response in switch response.result
        {
            case .Success(let json):
            
                // Success
                if let data : NSDictionary = (json as! NSArray).objectAtIndex(0) as? NSDictionary
                {
                    // Store
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(data, forKey: "user")
                    
                    // Leave
                    let main : UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
                    self.presentViewController(main, animated: true, completion: nil)
                    
                }
                
                // Failed
                else
                {
                    
                }
                
            
                break;
            
            default:
                break;
        }}
        
    }
    
    
    // Keyboard
    
    func keyboardOnScreen(notification: NSNotification)
    {
        
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        
        // let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        self.view.frame = aRect

        
    }
    

    
    
    

}
