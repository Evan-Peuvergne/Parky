//
//  BookingsCellTableViewCell.swift
//  ParkMe
//
//  Created by evan peuvergne on 16/06/2016.
//  Copyright © 2016 evan peuvergne. All rights reserved.
//







// Import

import UIKit






// Class

class BookingsCell: UITableViewCell
{

    
    
    
    

    
    // Properties
    
    
    
    // Properties > Outlets
    
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var beginningLabel: UILabel!
    @IBOutlet weak var endingLabel: UILabel!
    
    @IBOutlet weak var cellContainer: UIView!
    
    
    
    
    
    // Methods
    
    
    // Methods > Init
    
    override func awakeFromNib()
    {
        
        // Super
        super.awakeFromNib()
        
        // Graphics
        self.backgroundColor = UIColor.clearColor()
        self.cellContainer.backgroundColor = UIColor.whiteColor()
        
        self.cellContainer.layer.cornerRadius = 8.0
        
        self.cellContainer.layer.shadowColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1).CGColor
        self.cellContainer.layer.shadowOpacity = 0.2
        self.cellContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.cellContainer.layer.shadowRadius = 4.0
        
    }
    
    
    // Fill
    
    func fill (data: NSDictionary)
    {
       
        // Texts
        self.adressLabel.text = data.objectForKey("street") as? String
        self.streetLabel.text = (data.objectForKey("zipCode") as! String) + ", " + (data.objectForKey("city") as! String)
        self.priceLabel.text = String(format: "%i", arc4random()%200) + "€"
        
        // Variables
        let months = ["Jan", "Feb", "Mar", "May", "Apr", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dev"]
        
        let arrival = data.objectForKey("rental")?.objectForKey("arrival")
        let departure = data.objectForKey("rental")?.objectForKey("departure")
        
        // Dates
        self.beginningLabel.text = String(format: "%i", arrival?.objectForKey("day") as! Int) + " " + months[(arrival?.objectForKey("month") as! Int)] + ". " + String(format: "%i", arrival?.objectForKey("year") as! Int)
        self.endingLabel.text = String(format: "%i", departure?.objectForKey("day") as! Int) + " " + months[(departure?.objectForKey("month") as! Int)] + ". " + String(format: "%i", departure?.objectForKey("year") as! Int)
        
    }
    
    
    
    
    
    
    
    
    // Override
    
    
    // Override > Select

    override func setSelected(selected: Bool, animated: Bool)
    {
        
        // Super
        // super.setSelected(selected, animated: animated)

    }
    
}
